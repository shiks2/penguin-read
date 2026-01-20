class TextProcessor {
  const TextProcessor._();

  /// Splits text into words while keeping punctuation attached to the preceding word.
  static List<String> splitText(String text) {
    if (text.isEmpty) return [];
    // Split by whitespace but keep the token clean
    return text.trim().split(RegExp(r'\s+')).where((element) => element.isNotEmpty).toList();
  }

  /// Calculates the display duration for a word in milliseconds.
  /// Base delay = 60000 / wpm
  /// Bonuses:
  /// - Word length > 8: +20%
  /// - Ends with punctuation (., !, ?, :, ;): +50%
  static int calculateDelay(String word, int wpm) {
    if (wpm <= 0) return 600; // Fallback

    final double baseDelayMs = 60000 / wpm;
    double totalDelay = baseDelayMs;

    // Length bonus
    if (word.length > 8) {
      totalDelay += baseDelayMs * 0.20;
    }

    // Punctuation bonus
    final lastChar = word.isNotEmpty ? word[word.length - 1] : '';
    if (['.', '!', '?', ':', ';'].contains(lastChar)) {
      totalDelay += baseDelayMs * 0.50;
    } else if (lastChar == ',') {
      // Comma bonus (smaller)
      totalDelay += baseDelayMs * 0.20;
    }

    return totalDelay.round();
  }
}
