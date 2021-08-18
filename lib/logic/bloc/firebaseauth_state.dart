part of 'firebaseauth_bloc.dart';

@immutable
abstract class FirebaseauthState {}

class FirebaseauthInitial extends FirebaseauthState {}

class UserLoggedIn extends FirebaseauthState {}

class UserLoggedOut extends FirebaseauthState {}

class UserSignedUp extends FirebaseauthState {}

class RequestedOperationFailed extends FirebaseauthState {}
