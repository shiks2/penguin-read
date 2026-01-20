import 'package:equatable/equatable.dart';

class ReadingSession extends Equatable {
  final int? id;
  final String userId;
  final int wpm;
  final int wordsRead;
  final int durationSeconds;
  final DateTime createdAt;

  const ReadingSession({
    this.id,
    required this.userId,
    required this.wpm,
    required this.wordsRead,
    required this.durationSeconds,
    required this.createdAt,
  });

  @override
  List<Object?> get props =>
      [id, userId, wpm, wordsRead, durationSeconds, createdAt];
}
