/* docx kabuğunun mantığı.
 *
 * docx-preview bu kopyada üç yama taşıyor (themeFill, themeTint/Shade,
 * `w:val="auto"` tema rengini ezme) — ayrıntı vendor/PATCHES-docx-preview.md.
 */
(function () {
  'use strict';

  const stage = document.getElementById('stage');

  /* Word sayfası sabit genişlikte (A4 ≈ 794 px); telefon ekranı ~390 px.
     Ölçekleyerek sığdırıyoruz — yatay kaydırma bir belge okuyucuda kabul
     edilemez. Ölçek düzeni bozmuyor, yalnızca küçültüyor; kullanıcı
     yakınlaştırma jestiyle büyütebiliyor. */
  function fitToWidth() {
    const wrapper = stage.querySelector('.docx-wrapper');
    if (!wrapper) {
      return;
    }
    const page = wrapper.querySelector('section');
    if (!page) {
      return;
    }

    // Reset styles to accurately measure natural dimensions
    wrapper.style.transform = '';
    wrapper.style.transformOrigin = 'top left';
    wrapper.style.width = '';
    wrapper.style.height = '';
    stage.style.height = '';

    const pageWidth = page.offsetWidth;
    if (!pageWidth) {
      return;
    }
    const available = document.documentElement.clientWidth;
    if (pageWidth <= available) {
      return;
    }
    const scale = available / pageWidth;

    wrapper.style.transformOrigin = 'top left';
    wrapper.style.transform = 'scale(' + scale + ')';
    // Stage height holds the visually scaled height so all pages are visible without cutoff or blank screen
    stage.style.height = (Math.ceil(wrapper.offsetHeight * scale) + 48) + 'px';
    stage.style.width = available + 'px';
    stage.style.overflow = 'hidden';
  }

  /** Anahat için başlıkları toplar — görüntüleyicideki "İçindekiler". */
  function collectOutline() {
    const headings = stage.querySelectorAll('h1, h2, h3');
    const labels = [];
    headings.forEach(function (node, index) {
      const text = (node.textContent || '').trim();
      if (text) {
        node.setAttribute('data-outline', String(index));
        labels.push(text);
      }
    });
    return labels;
  }

  async function render(bytes) {
    const started = performance.now();
    stage.innerHTML = '';

    await docx.renderAsync(bytes, stage, null, {
      className: 'docx',
      inWrapper: true,
      breakPages: true,
      experimental: true,
      // Görselleri data URI olarak göm: blob URL'leri sıkı CSP altında
      // engellenebiliyor, data: img-src'de açıkça izinli.
      useBase64URL: true,
      renderHeaders: true,
      renderFooters: true,
      renderFootnotes: true
    });

    fitToWidth();
    window.addEventListener('resize', fitToWidth);
    const outline = collectOutline();

    Bridge.send('rendered', {
      ms: Math.round(performance.now() - started),
      units: stage.querySelectorAll('.docx-wrapper > section').length || 1,
      styled: true,
      outline: outline
    });
  }

  Bridge.on('goto', function (payload) {
    const target = stage.querySelector('[data-outline="' + payload.index + '"]');
    if (target) {
      target.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
  });

  Bridge.on('search', function (payload) {
    const query = (payload.query || '').toLocaleLowerCase('tr');

    // Önceki vurguları temizle.
    stage.querySelectorAll('mark.hit').forEach(function (mark) {
      const parent = mark.parentNode;
      parent.replaceChild(document.createTextNode(mark.textContent), mark);
      parent.normalize();
    });

    if (!query) {
      Bridge.send('searchResult', { hits: 0 });
      return;
    }

    let hits = 0;
    const walker = document.createTreeWalker(stage, NodeFilter.SHOW_TEXT);
    const targets = [];
    while (walker.nextNode()) {
      const node = walker.currentNode;
      if (node.nodeValue.toLocaleLowerCase('tr').indexOf(query) >= 0) {
        targets.push(node);
      }
    }

    targets.forEach(function (node) {
      const value = node.nodeValue;
      const lower = value.toLocaleLowerCase('tr');
      const fragment = document.createDocumentFragment();
      let cursor = 0;
      let found = lower.indexOf(query, cursor);
      while (found >= 0) {
        fragment.appendChild(
          document.createTextNode(value.slice(cursor, found))
        );
        const mark = document.createElement('mark');
        mark.className = 'hit';
        mark.textContent = value.slice(found, found + query.length);
        fragment.appendChild(mark);
        hits++;
        cursor = found + query.length;
        found = lower.indexOf(query, cursor);
      }
      fragment.appendChild(document.createTextNode(value.slice(cursor)));
      node.parentNode.replaceChild(fragment, node);
    });

    const first = stage.querySelector('mark.hit');
    if (first) {
      first.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }
    Bridge.send('searchResult', { hits: hits });
  });

  Bridge.start(render);
})();
