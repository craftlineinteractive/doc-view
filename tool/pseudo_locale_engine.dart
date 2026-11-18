/// Engine for generating debug pseudo-locale (en_XA) strings.
///
/// Features:
/// - Transforms Latin characters to accented/expanded variants.
/// - Increases text length by ~40% to test UI clipping and text-overflow.
/// - Strictly preserves `{placeholder}` tokens and ICU plural/select structures.
class PseudoLocaleEngine {
  static const Map<String, String> _charMap = {
    'a': 'à', 'b': 'ƀ', 'c': 'ç', 'd': 'đ', 'e': 'é', 'f': 'ƒ', 'g': 'ĝ',
    'h': 'ĥ', 'i': 'î', 'j': 'ĵ', 'k': 'ƙ', 'l': 'ł', 'm': 'ɱ', 'n': 'ñ',
    'o': 'ô', 'p': 'þ', 'q': 'ʠ', 'r': 'ř', 's': 'š', 't': 'ţ', 'u': 'û',
    'v': 'ṽ', 'w': 'ŵ', 'x': 'ẋ', 'y': 'ý', 'z': 'ž',
    'A': 'Å', 'B': 'Ɓ', 'C': 'Ç', 'D': 'Ð', 'E': 'É', 'F': 'Ƒ', 'G': 'Ĝ',
    'H': 'Ħ', 'I': 'Î', 'J': 'Ĵ', 'K': 'Ķ', 'L': 'Ł', 'M': 'Ṁ', 'N': 'Ñ',
    'O': 'Ö', 'P': 'Þ', 'Q': 'Ǫ', 'R': 'Ř', 'S': 'Š', 'T': 'Ť', 'U': 'Û',
    'V': 'Ṽ', 'W': 'Ŵ', 'X': 'Ẋ', 'Y': 'Ý', 'Z': 'Ž',
  };

  /// Transforms [text] into pseudo-localized text while preserving placeholders.
  static String transform(String text) {
    if (text.isEmpty) return text;

    // Check if the string is an ICU expression (e.g. "{count, plural, ...}")
    if (text.startsWith('{') && (text.contains(', plural,') || text.contains(', select,'))) {
      return _transformIcu(text);
    }

    return _transformSimpleString(text);
  }

  /// Transforms a simple string that may contain inline placeholders like `{name}`.
  static String _transformSimpleString(String text) {
    final buffer = StringBuffer();
    int i = 0;
    final int len = text.length;

    while (i < len) {
      if (text[i] == '{') {
        // Find closing brace
        final closeIdx = text.indexOf('}', i);
        if (closeIdx != -1) {
          buffer.write(text.substring(i, closeIdx + 1));
          i = closeIdx + 1;
          continue;
        }
      }
      final char = text[i];
      buffer.write(_charMap[char] ?? char);
      i++;
    }

    final accented = buffer.toString();
    // Compute ~40% expansion padding
    final int padLen = (text.length * 0.4).ceil().clamp(2, 20);
    final String pad = ' ${'ẋ' * padLen}';
    return '[$accented$pad]';
  }

  /// Recursively transforms branches in an ICU expression while preserving syntax.
  static String _transformIcu(String icuText) {
    // Find matching closing brace for top-level ICU block
    int depth = 0;
    int icuEnd = -1;
    for (int k = 0; k < icuText.length; k++) {
      if (icuText[k] == '{') depth++;
      if (icuText[k] == '}') {
        depth--;
        if (depth == 0) {
          icuEnd = k;
          break;
        }
      }
    }
    if (icuEnd == -1) return _transformSimpleString(icuText);

    final icuBlock = icuText.substring(0, icuEnd + 1);
    final trailing = icuText.substring(icuEnd + 1);

    final firstComma = icuBlock.indexOf(',');
    if (firstComma == -1) return _transformSimpleString(icuText);

    final secondComma = icuBlock.indexOf(',', firstComma + 1);
    if (secondComma == -1) return _transformSimpleString(icuText);

    final prefix = icuBlock.substring(0, secondComma + 1); // e.g. "{count, plural,"
    final body = icuBlock.substring(secondComma + 1, icuBlock.length - 1);

    final buffer = StringBuffer(prefix);

    // Parse branches: [keyword]{content}
    int i = 0;
    while (i < body.length) {
      // Skip whitespace
      while (i < body.length && (body[i] == ' ' || body[i] == '\t' || body[i] == '\n' || body[i] == '\r')) {
        buffer.write(body[i]);
        i++;
      }
      if (i >= body.length) break;

      // Read branch keyword (e.g. "=0", "=1", "one", "other")
      final openBrace = body.indexOf('{', i);
      if (openBrace == -1) {
        buffer.write(body.substring(i));
        break;
      }
      final keyword = body.substring(i, openBrace);
      buffer.write(keyword);
      buffer.write('{');

      // Find matching closing brace for this branch (taking nested braces into account)
      int branchDepth = 1;
      int j = openBrace + 1;
      while (j < body.length && branchDepth > 0) {
        if (body[j] == '{') branchDepth++;
        if (body[j] == '}') branchDepth--;
        j++;
      }

      final branchContent = body.substring(openBrace + 1, j - 1);
      buffer.write(transform(branchContent));
      buffer.write('}');
      i = j;
    }

    buffer.write('}');
    if (trailing.isNotEmpty) {
      buffer.write(transform(trailing));
    }
    return buffer.toString();
  }
}
