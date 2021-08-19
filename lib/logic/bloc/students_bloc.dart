import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tech_teacher/data/currentUser.dart';
import 'package:tech_teacher/data/students.dart';
import 'package:tech_teacher/repositories/students_repo.dart';

part 'students_event.dart';
part 'students_state.dart';

class StudentsBloc extends Bloc<StudentsEvent, StudentsState> {
  final StudentsRepository notesRepository;
  StudentsBloc({required this.notesRepository}) : super(StudentsInitial());

  @override
  Stream<StudentsState> mapEventToState(
    StudentsEvent event,
  ) async* {
 if (event is AddNote) {
      yield* _mapAddStudentsToState(event);
    } else if (event is UpdateNote) {
      yield* _mapUpdateStudentsToState(event);
    } else if (event is FetchAllStudents) {
      yield* _mapFetchAllStudentsToState(event);
    } 
  }

  Stream<StudentsState> _mapAddStudentsToState(AddNote event) async* {
    yield StudentsOperationInProgress();
    bool response = await notesRepository.addNewStudents(event.note,event.user);
    yield StudentsOperationSuccess(response);
  }

  Stream<StudentsState> _mapUpdateStudentsToState(UpdateNote event) async* {
    yield StudentsOperationInProgress();

    bool response = await notesRepository.updateExistingStudents(event.note,event.user);
    yield StudentsOperationSuccess(response);
  }



  Stream<StudentsState> _mapFetchAllStudentsToState(FetchAllStudents event) async* {
    print("Hey");
    var notes = await notesRepository.fetchAllStudents(event.user);
    yield StudentsLoadSuccess(notes);
  }



  @override
  void add(StudentsEvent event) {
    super.add(event);
  }


}
