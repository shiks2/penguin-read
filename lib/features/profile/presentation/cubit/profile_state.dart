part of 'profile_cubit.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileGuest extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final List<ReadingSession> sessions;
  final int totalWordsRead;
  final int bestWpm;
  final String userEmail;

  const ProfileLoaded({
    required this.sessions,
    required this.totalWordsRead,
    required this.bestWpm,
    required this.userEmail,
  });

  @override
  List<Object> get props => [sessions, totalWordsRead, bestWpm, userEmail];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object> get props => [message];
}
