
import 'package:tech_teacher/data/students.dart';

abstract class AbstractAuthRepo {
  Future<bool> isAuthenticated();

  Future<void> verifyEmailId();

  Future<Students> getUser();
}