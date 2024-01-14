import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

part 'network_event.dart';
part 'network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  NetworkBloc() : super(NetworkInitial()) {
    on<NetworkObserve>(_networkObserve);
    on<NetworkNotify>(_networkNotify);
  }

  FutureOr<void> _networkObserve(event, emit) async {
    bool isConnected = (await Connectivity().checkConnectivity()) != ConnectivityResult.none;
    isConnected ? emit(NetworkSuccess()) : emit(NetworkFailed());
    Connectivity().onConnectivityChanged.listen((ConnectivityResult status) {
      log(status.toString());
      add(NetworkNotify(isConnected: status != ConnectivityResult.none));
    });
  }

  FutureOr<void> _networkNotify(NetworkNotify event, emit) {
    event.isConnected ? emit(NetworkSuccess()) : emit(NetworkFailed());
  }
}
