import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/reader_session.dart';
import '../../domain/utils/text_processor.dart';

// Events
abstract class ReaderEvent extends Equatable {
  const ReaderEvent();

  @override
  List<Object> get props => [];
}

class ReaderStarted extends ReaderEvent {
  final String text;
  const ReaderStarted(this.text);

  @override
  List<Object> get props => [text];
}

class ReaderPaused extends ReaderEvent {}

class ReaderResumed extends ReaderEvent {}

class ReaderStopped extends ReaderEvent {}

class ReaderWPMUpdated extends ReaderEvent {
  final int wpm;
  const ReaderWPMUpdated(this.wpm);

  @override
  List<Object> get props => [wpm];
}

class _ReaderTick extends ReaderEvent {} // Internal event

// State
class ReaderState extends Equatable {
  final ReaderSession session;
  final bool isCompleted;

  const ReaderState({
    required this.session,
    this.isCompleted = false,
  });

  factory ReaderState.initial() {
    return ReaderState(session: ReaderSession.initial());
  }

  ReaderState copyWith({
    ReaderSession? session,
    bool? isCompleted,
  }) {
    return ReaderState(
      session: session ?? this.session,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object> get props => [session, isCompleted];
}

// BLoC
class ReaderBloc extends Bloc<ReaderEvent, ReaderState> {
  Timer? _timer;

  ReaderBloc() : super(ReaderState.initial()) {
    on<ReaderStarted>(_onStarted);
    on<ReaderPaused>(_onPaused);
    on<ReaderResumed>(_onResumed);
    on<ReaderStopped>(_onStopped);
    on<ReaderWPMUpdated>(_onWPMUpdated);
    on<_ReaderTick>(_onTick);
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  void _onStarted(ReaderStarted event, Emitter<ReaderState> emit) {
    _timer?.cancel();
    final words = TextProcessor.splitText(event.text);
    if (words.isEmpty) return;

    final newSession = ReaderSession(
      words: words,
      currentWordIndex: 0,
      wpm: state.session.wpm,
      isPlaying: true,
    );

    emit(state.copyWith(session: newSession, isCompleted: false));
    _scheduleNextTick(newSession.currentWord, newSession.wpm);
  }

  void _onPaused(ReaderPaused event, Emitter<ReaderState> emit) {
    _timer?.cancel();
    emit(state.copyWith(
      session: state.session.copyWith(isPlaying: false),
    ));
  }

  void _onResumed(ReaderResumed event, Emitter<ReaderState> emit) {
    if (state.isCompleted) {
        // Restart if completed
        add(ReaderStarted(state.session.words.join(' ')));
        return;
    }
    
    emit(state.copyWith(
      session: state.session.copyWith(isPlaying: true),
    ));
    _scheduleNextTick(state.session.currentWord, state.session.wpm);
  }

  void _onStopped(ReaderStopped event, Emitter<ReaderState> emit) {
    _timer?.cancel();
    emit(ReaderState.initial());
  }

  void _onWPMUpdated(ReaderWPMUpdated event, Emitter<ReaderState> emit) {
    emit(state.copyWith(
      session: state.session.copyWith(wpm: event.wpm),
    ));
    // If playing, the next tick will naturally pick up the delay, 
    // or we could cancel and reschedule immediately for responsiveness.
    // simpler to just let the current word finish its duration.
  }

  void _onTick(_ReaderTick event, Emitter<ReaderState> emit) {
    if (!state.session.isPlaying) return;

    final nextIndex = state.session.currentWordIndex + 1;
    if (nextIndex >= state.session.words.length) {
      _timer?.cancel();
      emit(state.copyWith(
        session: state.session.copyWith(isPlaying: false),
        isCompleted: true,
      ));
    } else {
      final updatedSession = state.session.copyWith(currentWordIndex: nextIndex);
      emit(state.copyWith(session: updatedSession));
      _scheduleNextTick(updatedSession.currentWord, updatedSession.wpm);
    }
  }

  void _scheduleNextTick(String currentWord, int wpm) {
    final delay = TextProcessor.calculateDelay(currentWord, wpm);
    _timer = Timer(Duration(milliseconds: delay), () {
      if (!isClosed) add(_ReaderTick());
    });
  }
}
