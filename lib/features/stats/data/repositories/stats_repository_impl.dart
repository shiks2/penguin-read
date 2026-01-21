import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/reading_session.dart';
import '../../domain/repositories/stats_repository.dart';
import '../models/reading_session_model.dart';

class StatsRepositoryImpl implements StatsRepository {
  final SupabaseClient supabaseClient;

  StatsRepositoryImpl({required this.supabaseClient});

  @override
  Future<void> saveSession(ReadingSession session) async {
    try {
      final model = ReadingSessionModel(
        userId: session.userId,
        wpm: session.wpm,
        wordsRead: session.wordsRead,
        durationSeconds: session.durationSeconds,
        createdAt: session.createdAt,
      );

      await supabaseClient.from('reading_sessions').insert(model.toJson());
    } catch (e) {
      // In a real app, wrap in Failure
    }
  }

  @override
  Future<List<ReadingSession>> getWeeklyStats() async {
    try {
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) return [];

      // Get date 7 days ago
      final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));

      final data = await supabaseClient
          .from('reading_sessions')
          .select()
          .eq('user_id', userId)
          .gte('created_at', sevenDaysAgo.toIso8601String())
          .order('created_at', ascending: false);

      return (data as List)
          .map((json) => ReadingSessionModel.fromJson(json))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
