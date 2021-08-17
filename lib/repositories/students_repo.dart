import 'package:tech_teacher/data/dataProviderFirebase.dart';
import 'package:tech_teacher/data/students.dart';

class StudentsRepository {
  final DataProviderFirebase dataProviderFirebase;

  StudentsRepository({required this.dataProviderFirebase});

  Future<bool> addNewStudents(Students notes) async {
    return dataProviderFirebase.addNewStudents(notes);
  }

  Future<bool> updateExistingStudents(Students notes) async {
    return dataProviderFirebase.updateExistingStudents(notes);
  }

  Future<void> deleteStudents(List<String?> notes) async {
    dataProviderFirebase.deleteStudents(notes);
  }

  Future<List<Students?>?>? fetchAllStudents() async {
    List<Students?>? x = <Students>[];
    x = await dataProviderFirebase.fetchAllStudents();
    return x;
  }
}
