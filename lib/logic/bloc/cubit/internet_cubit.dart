import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:meta/meta.dart';

part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  final Connectivity connectivity;
  StreamSubscription? streamSubscription;
  InternetCubit({required this.connectivity}) : super(InternetInitial()) {
    streamSubscription = connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.none) {
        emit(InternetDisconnected());
      } else {
        emit(InternetConnected());
      }
    });
  }

  @override
  Future<void> close() {
    streamSubscription?.cancel();
    return super.close();
  }
}
