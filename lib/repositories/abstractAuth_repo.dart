import 'package:tech_teacher/data/students.dart';

abstract class AbstractAuthRepo {
  Future<void> signUp(String emailid, String password);
  Future<void> signIn(String emailid, String password);
  Future<void> signOut();
}
