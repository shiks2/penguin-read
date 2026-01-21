import 'package:penread_v1/features/reader/domain/utils/text_processor.dart';

void main() {
  final stopwatch = Stopwatch()..start();
  const iterations = 10000000;
  final words = ['hello', 'world.', 'longword!!', 'test,', 'short', 'punctuation?'];
  final wpm = 300;

  print('Starting benchmark with $iterations iterations...');

  for (int i = 0; i < iterations; i++) {
    TextProcessor.calculateDelay(words[i % words.length], wpm);
  }

  stopwatch.stop();
  print('Time taken for $iterations iterations: ${stopwatch.elapsedMilliseconds} ms');
}
