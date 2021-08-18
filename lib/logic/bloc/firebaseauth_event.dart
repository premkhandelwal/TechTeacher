part of 'firebaseauth_bloc.dart';

@immutable
abstract class FirebaseauthEvent {}

class SignUpRequested extends FirebaseauthEvent {
   final String emailId;
  final String password;

  SignUpRequested({required this.emailId, required this.password});
}

class SignInRequested extends FirebaseauthEvent {
  final String emailId;
  final String password;

  SignInRequested({required this.emailId, required this.password});
}

class SignOutRequested extends FirebaseauthEvent {}
