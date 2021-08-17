import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'firebaseauth_event.dart';
part 'firebaseauth_state.dart';

class FirebaseauthBloc extends Bloc<FirebaseauthEvent, FirebaseauthState> {
  FirebaseauthBloc() : super(FirebaseauthInitial());

  @override
  Stream<FirebaseauthState> mapEventToState(
    FirebaseauthEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
