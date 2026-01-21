import 'package:flutter/material.dart';

class AnchorTextBuilder {
  /// Transforms a word into a TextSpan with "Anchor" highlighting.
  /// Logic:
  /// - Word length 1-3: Bold 1 letter
  /// - Word length 4-5: Bold 2 letters
  /// - Word length 6+: Bold 3 letters
  static InlineSpan build({
    required String word,
    required TextStyle baseStyle,
    required bool isAnchorMode,
  }) {
    if (!isAnchorMode || word.isEmpty) {
      return TextSpan(text: word, style: baseStyle);
    }

    int boldCount;
    if (word.length <= 3) {
      boldCount = 1;
    } else if (word.length <= 5) {
      boldCount = 2;
    } else {
      boldCount = 3;
    }

    if (boldCount > word.length) boldCount = word.length;

    return TextSpan(
      children: [
        TextSpan(
          text: word.substring(0, boldCount),
          style: baseStyle.copyWith(fontWeight: FontWeight.w900),
        ),
        TextSpan(
          text: word.substring(boldCount),
          style: baseStyle.copyWith(
            fontWeight: FontWeight.normal,
            color: baseStyle.color
                ?.withOpacity(0.65), // Reduce contrast of non-bold part
          ),
        ),
      ],
    );
  }
}
