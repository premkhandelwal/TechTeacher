import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:tech_teacher/data/currentUser.dart';
import 'package:tech_teacher/repositories/firebaseAuth_repo.dart';

part 'firebaseauth_event.dart';
part 'firebaseauth_state.dart';

class FirebaseauthBloc extends Bloc<FirebaseauthEvent, FirebaseauthState> {
  final FirebaseAuthRepo firebaseAuthRepo;
  FirebaseauthBloc({required this.firebaseAuthRepo})
      : super(FirebaseauthInitial());

  @override
  Stream<FirebaseauthState> mapEventToState(
    FirebaseauthEvent event,
  ) async* {
    if (event is UserStateRequested) {
      yield* _mapUserStatetoState();
    } else if (event is SignInRequested) {
      yield* _mapSignInRequestedtoState(event);
    } else if (event is SignUpRequested) {
      yield* _mapSignUpRequestedtoState(event);
    } else if (event is SignOutRequested) {
      yield* _mapSignOutRequestedtoState();
    } 
  }

  Stream<FirebaseauthState> _mapUserStatetoState() async* {
    CurrentUser? user = firebaseAuthRepo.isSignedIn();
    if (user != null) {
      yield UserLoggedIn(currentUser: user);
    } else {
      yield UserLoggedOut();
    }
  }

  Stream<FirebaseauthState> _mapSignInRequestedtoState(
      SignInRequested event) async* {
    try {
      yield UserLoggingIn();
      CurrentUser user =
          await firebaseAuthRepo.signIn(event.emailId, event.password);
      yield UserLoggedIn(currentUser: user);
    } catch (e) {
      yield RequestedOperationFailed();
    }
  }

  Stream<FirebaseauthState> _mapSignUpRequestedtoState(
      SignUpRequested event) async* {
    try {
      yield UserLoggingIn();
      CurrentUser user =
          await firebaseAuthRepo.signUp(event.emailId, event.password);
      yield UserSignedUp(currentUser: user);
    } catch (e) {
      yield RequestedOperationFailed();
    }
  }

  Stream<FirebaseauthState> _mapSignOutRequestedtoState() async* {
    try {
      yield UserLoggingIn();
      await firebaseAuthRepo.signOut();
      yield UserLoggedOut();
    } catch (e) {
      yield RequestedOperationFailed();
    }
  }

/*   Stream<FirebaseauthState> _mapEmailVerificationRequestedtoState(
      EmailVerificationRequested event) async* {
    yield EmailVerificationInProgress();
    bool emailVerified = await firebaseAuthRepo.verifyEmail(event.user!);
    if (emailVerified)
      yield EmailVerificationCompleted();
    else {
      yield EmailVerificationFailure();
    }
  } */
}
