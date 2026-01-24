import 'package:flutter_test/flutter_test.dart';
import 'package:penread_v1/features/reader/domain/utils/text_processor.dart';

void main() {
  group('TextProcessor', () {
    test('calculateDelay calculates correctly', () {
      const wpm = 300;
      // base delay = 60000 / 300 = 200 ms

      // Basic word
      expect(TextProcessor.calculateDelay('hello', wpm), 200);

      // Long word > 8 chars. "extraordinary" is 13 chars.
      // 200 + 200 * 0.20 = 240
      expect(TextProcessor.calculateDelay('extraordinary', wpm), 240);

      // Word ending with punctuation. "hello."
      // 200 + 200 * 0.50 = 300
      expect(TextProcessor.calculateDelay('hello.', wpm), 300);
      expect(TextProcessor.calculateDelay('hello!', wpm), 300);
      expect(TextProcessor.calculateDelay('hello?', wpm), 300);
      expect(TextProcessor.calculateDelay('hello:', wpm), 300);
      expect(TextProcessor.calculateDelay('hello;', wpm), 300);

      // Word ending with comma. "hello,"
      // 200 + 200 * 0.20 = 240
      expect(TextProcessor.calculateDelay('hello,', wpm), 240);

      // Combined: Long word + Punctuation
      // "extraordinary."
      // 200 + (200 * 0.20) + (200 * 0.50) = 200 + 40 + 100 = 340
      expect(TextProcessor.calculateDelay('extraordinary.', wpm), 340);

      // Empty word
      expect(TextProcessor.calculateDelay('', wpm), 200); // 200 base
    });
  });
}
