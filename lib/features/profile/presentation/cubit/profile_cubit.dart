import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../stats/domain/entities/reading_session.dart';
import '../../../stats/domain/repositories/stats_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final StatsRepository _statsRepository;
  final AuthRepository _authRepository;

  ProfileCubit({
    required StatsRepository statsRepository,
    required AuthRepository authRepository,
  })  : _statsRepository = statsRepository,
        _authRepository = authRepository,
        super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    try {
      final currentUser = _authRepository.getCurrentUser();
      if (currentUser == null) {
        emit(ProfileGuest());
        return;
      }

      final sessions = await _statsRepository.getWeeklyStats();

      int totalWords = 0;
      int bestWpm = 0;

      for (var session in sessions) {
        totalWords += session.wordsRead;
        if (session.wpm > bestWpm) {
          bestWpm = session.wpm;
        }
      }

      emit(ProfileLoaded(
        sessions: sessions,
        totalWordsRead: totalWords,
        bestWpm: bestWpm,
        userEmail: currentUser.email ?? 'User',
      ));
    } catch (e) {
      emit(ProfileError('Failed to load profile data: $e'));
    }
  }
}
