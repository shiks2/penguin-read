import 'package:equatable/equatable.dart';

class ReaderSession extends Equatable {
  final List<String> words;
  final int currentWordIndex;
  final int wpm;
  final bool isPlaying;

  const ReaderSession({
    required this.words,
    required this.currentWordIndex,
    required this.wpm,
    required this.isPlaying,
  });

  factory ReaderSession.initial() {
    return const ReaderSession(
      words: [],
      currentWordIndex: 0,
      wpm: 300,
      isPlaying: false,
    );
  }

  ReaderSession copyWith({
    List<String>? words,
    int? currentWordIndex,
    int? wpm,
    bool? isPlaying,
  }) {
    return ReaderSession(
      words: words ?? this.words,
      currentWordIndex: currentWordIndex ?? this.currentWordIndex,
      wpm: wpm ?? this.wpm,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }

  String get currentWord => 
      (words.isNotEmpty && currentWordIndex < words.length && currentWordIndex >= 0) 
      ? words[currentWordIndex] 
      : '';
  
  double get progress => words.isEmpty ? 0 : (currentWordIndex / words.length);

  @override
  List<Object?> get props => [words, currentWordIndex, wpm, isPlaying];
}
