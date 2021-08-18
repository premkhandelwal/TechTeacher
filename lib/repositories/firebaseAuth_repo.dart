import 'package:firebase_auth/firebase_auth.dart';
import 'package:tech_teacher/data/students.dart';
import 'package:tech_teacher/repositories/abstractAuth_repo.dart';

class FirebaseAuthRepo implements AbstractAuthRepo {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthRepo({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<void> signUp(String emailid, String password) async {
    
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: emailid, password: password);
      // await _firebaseAuth.signInWithCredential(credential);
      // await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)
      if (_firebaseAuth.currentUser != null) {
        // await verifyEmailId(_firebaseAuth.currentUser!);
        await _firebaseAuth.currentUser!.sendEmailVerification();
        if (_firebaseAuth.currentUser!.emailVerified) {
          print("Yayyyy email verified");
        } else {
          print("Not verified");
        }
      }
    } catch (e) {
      print(e);
    } finally {
      // always stop the progress indicator
    }
  }


  @override
    Future<void> signOut() async {
    try {
      _firebaseAuth.signOut();
      _firebaseAuth.authStateChanges();
    } catch (e) {}
  }


  @override
  Future<void> signIn(String emailid, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: emailid, password: password);
      // await _firebaseAuth.signInWithCredential(credential);
      // await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)
      _firebaseAuth.authStateChanges();
    } catch (e) {
      print(e);
    } finally {
      // always stop the progress indicator
    }
  }
}
