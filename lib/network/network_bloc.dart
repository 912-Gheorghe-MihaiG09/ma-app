import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

part 'network_event.dart';
part 'network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  NetworkBloc() : super(NetworkInitial()) {
    on<NetworkObserve>(_networkObserve);
    on<NetworkNotify>(_networkNotify);
  }

  FutureOr<void> _networkObserve(event, emit) async {
    bool isConnected = await InternetConnectionChecker().hasConnection;
    isConnected ? emit(NetworkSuccess()) : emit(NetworkFailed());
    InternetConnectionChecker().onStatusChange.listen((InternetConnectionStatus status) {
      add(NetworkNotify(isConnected: status == InternetConnectionStatus.connected));
    });
  }

  FutureOr<void> _networkNotify(NetworkNotify event, emit) {
    event.isConnected ? emit(NetworkSuccess()) : emit(NetworkFailed());
  }
}
