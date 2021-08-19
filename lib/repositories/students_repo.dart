import 'package:tech_teacher/data/currentUser.dart';
import 'package:tech_teacher/data/dataProviderFirebase.dart';
import 'package:tech_teacher/data/students.dart';

class StudentsRepository {
  final DataProviderFirebase dataProviderFirebase;

  StudentsRepository({required this.dataProviderFirebase});

  Future<bool> addNewStudents(Students notes, CurrentUser user) async {
    return dataProviderFirebase.addNewStudents(notes,user);
  }

  Future<bool> updateExistingStudents(Students notes, CurrentUser user) async {
    return dataProviderFirebase.updateExistingStudents(notes,user);
  }



  Future<List<Students?>?>? fetchAllStudents(CurrentUser user) async {
    List<Students?>? x = <Students>[];
    x = await dataProviderFirebase.fetchAllStudents(user);
    return x;
  }
}
