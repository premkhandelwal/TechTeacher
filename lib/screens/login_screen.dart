import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth? _firebaseAuth;
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();
  String _errorMessage = "";
  bool _loggingIn = false;
  Future<void> verifyEmailId(User? user) async {
    user!.sendEmailVerification();
  }

  void _signInWithGoogle() async {
    _setLoggingIn(); // show progress
    String errMsg = "";

    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      await _auth.signInWithCredential(credential);
      await verifyEmailId(_auth.currentUser);
    } catch (e) {
      errMsg = 'Login failed, please try again later.';
    } finally {
      _setLoggingIn(false, errMsg); // always stop the progress indicator
    }
  }

  void _setLoggingIn([bool loggingIn = true, String errMsg = ""]) {
    if (mounted) {
      setState(() {
        _loggingIn = loggingIn;
        _errorMessage = errMsg;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text("Verify EMail"),
          onPressed: _signInWithGoogle,
        ),
      ),
    );
  }
}
