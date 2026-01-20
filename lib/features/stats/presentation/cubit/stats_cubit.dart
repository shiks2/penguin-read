import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/reading_session.dart';
import '../../domain/repositories/stats_repository.dart';

part 'stats_state.dart';

class StatsCubit extends Cubit<StatsState> {
  final StatsRepository _repository;

  StatsCubit({required StatsRepository repository})
      : _repository = repository,
        super(StatsInitial());

  Future<void> loadStats() async {
    emit(StatsLoading());
    try {
      final sessions = await _repository.getWeeklyStats();
      emit(StatsLoaded(sessions));
    } catch (e) {
      emit(const StatsError("Failed to load stats"));
    }
  }
}
