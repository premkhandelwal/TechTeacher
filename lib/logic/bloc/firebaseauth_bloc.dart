import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tech_teacher/repositories/firebaseAuth_repo.dart';

part 'firebaseauth_event.dart';
part 'firebaseauth_state.dart';

class FirebaseauthBloc extends Bloc<FirebaseauthEvent, FirebaseauthState> {
  final FirebaseAuthRepo firebaseAuthRepo;
  FirebaseauthBloc({required this.firebaseAuthRepo})
      : super(UserLoggedOut());

  @override
  Stream<FirebaseauthState> mapEventToState(
    FirebaseauthEvent event,
  ) async* {
    if (event is SignInRequested) {
      yield* _mapSignInRequestedtoState(event);
    } else if (event is SignUpRequested) {
      yield* _mapSignUpRequestedtoState(event);
    }else if(event is SignOutRequested){
      yield* _mapSignOutRequestedtoState();

    }
  }

  Stream<FirebaseauthState> _mapSignInRequestedtoState(
      SignInRequested event) async* {
    try {
      await firebaseAuthRepo.signIn(event.emailId, event.password);
      yield UserLoggedIn();
    } catch (e) {
      yield RequestedOperationFailed();
    }
  }

  Stream<FirebaseauthState> _mapSignUpRequestedtoState(
      SignUpRequested event) async* {
    try {
      await firebaseAuthRepo.signUp(event.emailId, event.password);
      yield UserSignedUp();
    } catch (e) {
      yield RequestedOperationFailed();
    }
  }

  Stream<FirebaseauthState> _mapSignOutRequestedtoState() async* {
    try {
      await firebaseAuthRepo.signOut();
      yield UserLoggedOut();
    } catch (e) {
      yield RequestedOperationFailed();
    }
  }
}
