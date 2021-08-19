import 'package:tech_teacher/data/currentUser.dart';

abstract class AbstractAuthRepo {
  CurrentUser? isSignedIn();
  Future<CurrentUser> signUp(String emailid, String password);
  Future<CurrentUser> signIn(String emailid, String password);
  Future<void> signOut();
  Future<bool> verifyEmail(CurrentUser user);
}
