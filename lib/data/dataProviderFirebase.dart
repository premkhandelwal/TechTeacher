import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tech_teacher/data/students.dart';

class DataProviderFirebase {
  final notesCollection = FirebaseFirestore.instance.collection('student');

  Future<bool> addNewStudents(Students notes) async {
    bool responseVal = false;
    await notesCollection.add({
      'studentName': "${notes.studentName}",
      'dateofBirth': "${notes.dateofBirth}",
      'studentGender': notes.studentGender,
    });
    responseVal = true;
    return responseVal;
  }

  Future<bool> updateExistingStudents(Students notes) async {
    // FirebaseFirestore.instance.collection('collection_Name').doc('doc_Name').collection('collection_Name').doc(code.documentId).update({'redeem': true});
    bool responseVal = false;
    notesCollection.doc("${notes.id}").update({
      'studentName': "${notes.studentName}",
      'dateofBirth': "${notes.dateofBirth}",
      'studentGender': notes.studentGender,
    });
    responseVal = true;
    return responseVal;
  }

  Future<List<Students?>> fetchAllStudents() async {
    print("Hello");
    List<Students?> listStudents = [];

    await notesCollection.get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        listStudents.add(
          Students(
            studentName: result.data()["studentName"],
            id: result.id,
            dateofBirth: result.data()["dateofBirth"],
            studentGender: result.data()["studentGender"],
          ),
        );
      });
    });
    print(listStudents);
    return listStudents;
  }

  Future<void> deleteStudents(List<String?> notes) async {
    for (var i = 0; i < notes.length; i++) {
      return notesCollection
          .doc("${notes[i]}")
          .update({
            'isDeleted': true,
          })
          .then((value) => print("User Deleted"))
          .catchError((error) => print("Failed to delete user: $error"));
    }
  }
}
