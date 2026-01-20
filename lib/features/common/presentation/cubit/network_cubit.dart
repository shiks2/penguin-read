import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

part 'network_state.dart';

class NetworkCubit extends Cubit<NetworkState> {
  final Connectivity _connectivity;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  NetworkCubit({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity(),
        super(NetworkState.initial()) {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.none)) {
      emit(state.copyWith(status: NetworkStatus.offline));
    } else {
      emit(state.copyWith(status: NetworkStatus.online));
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}
