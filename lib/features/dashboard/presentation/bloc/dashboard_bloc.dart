import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/dashboard_repository.dart';
import '../../domain/entities/text_entity.dart';

// Events
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
  @override
  List<Object> get props => [];
}

class LoadLibrary extends DashboardEvent {}

// States
abstract class DashboardState extends Equatable {
  const DashboardState();
  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final List<TextEntity> texts;
  const DashboardLoaded(this.texts);
  @override
  List<Object> get props => [texts];
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError(this.message);
  @override
  List<Object> get props => [message];
}

// BLoC
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository repository;

  DashboardBloc({required this.repository}) : super(DashboardInitial()) {
    on<LoadLibrary>(_onLoadLibrary);
  }

  Future<void> _onLoadLibrary(LoadLibrary event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());
    final result = await repository.fetchPublicTexts();
    result.fold(
      (failure) => emit(const DashboardError("Failed to load library")),
      (texts) => emit(DashboardLoaded(texts)),
    );
  }
}
