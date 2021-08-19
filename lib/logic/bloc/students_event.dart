part of 'students_bloc.dart';

@immutable
abstract class StudentsEvent {}

class AddNote extends StudentsEvent {
  AddNote(this.note, this.user);
  final Students note;
  final CurrentUser user;
}

class FetchAllStudents extends StudentsEvent {
  FetchAllStudents(this.user);
  final CurrentUser user;
}

class FetchDeletedStudents extends StudentsEvent {}

class UpdateNote extends StudentsEvent {
  final Students note;
  final CurrentUser user;

  UpdateNote(this.note, this.user);
}

class DeleteStudents extends StudentsEvent {
  final List<String?> notes;
  final CurrentUser user;

  DeleteStudents(this.notes, this.user);
}
