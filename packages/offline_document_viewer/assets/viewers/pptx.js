/* pptx kabuğunun mantığı.
 *
 * PPTXjs bu kopyada beş yama taşıyor (madde imi buFont mirası, Wingdings
 * dingbat dönüşümü, XML karakter referansı, eksik docProps/app.xml'de çökme,
 * numCol/vert) — ayrıntı vendor/pptxjs/PATCHES.md.
 *
 * PPTXjs bir dosya girdisine bağlanmayı bekliyor; byte'lar köprüden geldiği
 * için gizli bir input'a DataTransfer ile yazıp change olayını tetikliyoruz.
 */
(function () {
  'use strict';

  const stage = document.getElementById('stage');
  let settleTimer = null;
  let startedAt = 0;

  /* PPTXjs senkron bir "bitti" sinyali vermiyor: slaytlar DOM'a düştükçe
     sayacı sıfırlıyoruz, 400 ms sessizlik render'ın bittiği anlamına geliyor. */
  function watchForCompletion() {
    const observer = new MutationObserver(function () {
      if (!startedAt) {
        return;
      }
      clearTimeout(settleTimer);
      settleTimer = setTimeout(function () {
        const slides = stage.querySelectorAll('.slide');
        if (!slides.length) {
          Bridge.send('error', {
            code: 'no_slides',
            detail: 'PPTXjs DOM\'a slayt basmadı'
          });
          startedAt = 0;
          return;
        }
        fitToWidth(slides);
        const outline = [];
        slides.forEach(function (slide, index) {
          slide.setAttribute('data-slide', String(index));
          const text = (slide.textContent || '').trim().split('\n')[0];
          outline.push(text ? text.slice(0, 60) : 'Slayt ' + (index + 1));
        });
        Bridge.send('rendered', {
          ms: Math.round(performance.now() - startedAt),
          units: slides.length,
          styled: true,
          outline: outline
        });
        startedAt = 0;
      }, 400);
    });
    observer.observe(stage, { childList: true, subtree: true });
  }

  /* Slaytları ekrana sığdır ve CSS ölçeklemeden kaynaklanan hayali
     kaydırma boşluklarını/beyaz boşlukları yok et.
     Her slaytı tam ölçeklenmiş yükseklikte taşma-kırpılmış bir sarmalayıcıya
     alıyoruz, böylece tarayıcı layout kutusu görsel kutuyla birebir örtüşür. */
  function fitToWidth(slides) {
    const available = document.documentElement.clientWidth;
    let totalHeight = 0;
    slides.forEach(function (slide) {
      const naturalWidth = slide.dataset.naturalWidth ? parseFloat(slide.dataset.naturalWidth) : slide.offsetWidth;
      const naturalHeight = slide.dataset.naturalHeight ? parseFloat(slide.dataset.naturalHeight) : slide.offsetHeight;
      if (!slide.dataset.naturalWidth && naturalWidth) {
        slide.dataset.naturalWidth = naturalWidth;
        slide.dataset.naturalHeight = naturalHeight;
      }

      const width = naturalWidth || 960;
      const height = naturalHeight || 720;
      const scale = available < width ? available / width : 1;
      const scaledWidth = Math.round(width * scale);
      const scaledHeight = Math.round(height * scale);

      let wrapper = slide.parentElement;
      if (!wrapper || !wrapper.classList.contains('slide-wrapper')) {
        wrapper = document.createElement('div');
        wrapper.className = 'slide-wrapper';
        slide.parentNode.insertBefore(wrapper, slide);
        wrapper.appendChild(slide);
      }

      wrapper.style.width = scaledWidth + 'px';
      wrapper.style.height = scaledHeight + 'px';
      wrapper.style.margin = '0 auto 16px auto';
      wrapper.style.overflow = 'hidden';
      wrapper.style.position = 'relative';

      slide.style.position = 'absolute';
      slide.style.top = '0';
      slide.style.left = '0';
      slide.style.transformOrigin = 'top left';
      slide.style.transform = 'scale(' + scale + ')';
      slide.style.margin = '0';

      totalHeight += scaledHeight + 16;
    });

    stage.style.minHeight = totalHeight + 'px';
    stage.style.paddingBottom = '32px';
  }

  window.addEventListener('resize', function () {
    const slides = stage.querySelectorAll('.slide');
    if (slides.length) {
      fitToWidth(slides);
    }
  });

  function render(bytes) {
    startedAt = performance.now();

    const input = document.createElement('input');
    input.type = 'file';
    input.id = 'pptx-source';
    input.style.display = 'none';
    document.body.appendChild(input);

    // PPTXjs MIME'ı tam eşleşme ile kontrol ediyor.
    const file = new File([bytes], 'doc.pptx', {
      type: 'application/vnd.openxmlformats-officedocument.presentationml.presentation'
    });
    const transfer = new DataTransfer();
    transfer.items.add(file);
    input.files = transfer.files;

    watchForCompletion();

    window.jQuery('#stage').pptxToHtml({
      fileInputId: 'pptx-source',
      slideMode: false,
      keyBoardShortCut: false,
      mediaProcess: true,
      themeProcess: true
    });

    input.dispatchEvent(new Event('change', { bubbles: true }));
  }

  Bridge.on('goto', function (payload) {
    const target = stage.querySelector('[data-slide="' + payload.index + '"]');
    if (target) {
      target.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
  });

  Bridge.on('search', function (payload) {
    const query = (payload.query || '').toLocaleLowerCase('tr');
    let hits = 0;
    stage.querySelectorAll('.slide').forEach(function (slide) {
      const match =
        query && (slide.textContent || '').toLocaleLowerCase('tr').indexOf(query) >= 0;
      slide.classList.toggle('hit', Boolean(match));
      if (match) {
        hits++;
      }
    });
    const first = stage.querySelector('.slide.hit');
    if (first) {
      first.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
    Bridge.send('searchResult', { hits: hits });
  });

  Bridge.start(render);
})();
