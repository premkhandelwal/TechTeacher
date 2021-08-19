import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:tech_teacher/data/currentUser.dart';
import 'package:tech_teacher/repositories/abstractAuth_repo.dart';

class FirebaseAuthRepo implements AbstractAuthRepo {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthRepo({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  CurrentUser? isSignedIn() {
    try {
      if (_firebaseAuth.currentUser == null) {
        return null;
      }
      return CurrentUser.create(_firebaseAuth.currentUser);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<CurrentUser> signUp(String emailid, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: emailid, password: password);
      await _firebaseAuth.currentUser!.sendEmailVerification();

      return CurrentUser.create(_firebaseAuth.currentUser);
      // await _firebaseAuth.signInWithCredential(credential);
      // await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)
      /* 
      } */
    } catch (e) {
      throw Exception(e);
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
  Future<CurrentUser> signIn(String emailid, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: emailid, password: password);
      // await _firebaseAuth.signInWithCredential(credential);
      // await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)
      _firebaseAuth.authStateChanges();
      return CurrentUser.create(_firebaseAuth.currentUser);
    } catch (e) {
      throw Exception(e);
    } finally {
      // always stop the progress indicator
    }
  }

  @override
  Future<bool> verifyEmail(CurrentUser user) async {
    if (_firebaseAuth.currentUser != null) {

          await _firebaseAuth.currentUser!.sendEmailVerification();
       
  
     if (_firebaseAuth.currentUser!.emailVerified) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
    }
      // await verifyEmailId(_firebaseAuth.currentUser!);

      /* Future.delayed(Duration(seconds: 120), () async {
        await _firebaseAuth.currentUser!.sendEmailVerification();
        if (_firebaseAuth.currentUser!.emailVerified) {
          break;
      });
 */
     
  }

