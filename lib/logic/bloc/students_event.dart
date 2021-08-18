part of 'students_bloc.dart';

@immutable
abstract class StudentsEvent {}

class AddNote extends StudentsEvent {
  AddNote(this.note);
  final Students note;
}

class FetchAllStudents extends StudentsEvent {}

class FetchDeletedStudents extends StudentsEvent {}

class UpdateNote extends StudentsEvent {
  final Students note;

  UpdateNote(
    this.note,
  );
}

class DeleteStudents extends StudentsEvent {
  final List<String?> notes;
  DeleteStudents(
    this.notes,
  );
}

