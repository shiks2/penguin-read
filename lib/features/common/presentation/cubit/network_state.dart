part of 'network_cubit.dart';

enum NetworkStatus { online, offline }

class NetworkState extends Equatable {
  final NetworkStatus status;

  const NetworkState({required this.status});

  factory NetworkState.initial() {
    return const NetworkState(status: NetworkStatus.online);
  }

  NetworkState copyWith({NetworkStatus? status}) {
    return NetworkState(status: status ?? this.status);
  }

  @override
  List<Object> get props => [status];
}
