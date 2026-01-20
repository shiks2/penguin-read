import '../entities/reading_session.dart';

abstract class StatsRepository {
  Future<void> saveSession(ReadingSession session);
  Future<List<ReadingSession>> getWeeklyStats();
}
