import 'package:firebase_auth/firebase_auth.dart';
import 'package:tech_teacher/data/students.dart';
import 'package:tech_teacher/repositories/abstractAuth_repo.dart';

class FirebaseAuthRepo implements AbstractAuthRepo {
  final FirebaseAuth? _firebaseAuth;

  FirebaseAuthRepo({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<Students> getUser() async {
    User firebaseUser = _firebaseAuth!.currentUser!;
    return Students(id: firebaseUser.uid, emailId: firebaseUser.email);
  }

  @override
  Future<bool> isAuthenticated() async {
    final User? currentUser = _firebaseAuth != null
        ? _firebaseAuth!.currentUser != null
            ? _firebaseAuth!.currentUser
            : null
        : null;
    // return true or false depending on whether we have a current user
    return currentUser != null;
  }

  @override
  Future<void> verifyEmailId() async {
    final User? currentUser = _firebaseAuth != null
        ? _firebaseAuth!.currentUser != null
            ? _firebaseAuth!.currentUser
            : null
        : null;
    currentUser!.sendEmailVerification(ActionCodeSettings(url: "",androidPackageName: "com.example.tech_teacher"));
  }
}
