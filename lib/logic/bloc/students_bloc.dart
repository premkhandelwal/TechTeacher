import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
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
    if (state is StudentsInitial) {
      yield* _mapFetchAllStudentsToState();
    } else if (event is AddNote) {
      yield* _mapAddStudentsToState(event);
    } else if (event is UpdateNote) {
      yield* _mapUpdateStudentsToState(event);
    } else if (event is FetchAllStudents || state is StudentsInitial) {
      yield* _mapFetchAllStudentsToState();
    } else if (event is DeleteStudents) {
      yield* _mapDeleteStudentsToState(event);
    } else if (event is SearchStudents) {
      yield* _mapSearchStudentsToState(event);
    }
  }

  Stream<StudentsState> _mapAddStudentsToState(AddNote event) async* {
    yield StudentsOperationInProgress();
    bool response = await notesRepository.addNewStudents(event.note);
    yield StudentsOperationSuccess(response);
  }

  Stream<StudentsState> _mapUpdateStudentsToState(UpdateNote event) async* {
    yield StudentsOperationInProgress();

    bool response = await notesRepository.updateExistingStudents(event.note);
    yield StudentsOperationSuccess(response);
  }

  Stream<StudentsState> _mapDeleteStudentsToState(DeleteStudents event) async* {
    notesRepository.deleteStudents(event.notes);
  }

  Stream<StudentsState> _mapFetchAllStudentsToState() async* {
    print("Hey");
    var notes = await notesRepository.fetchAllStudents();
    yield StudentsLoadSuccess(notes);
  }

  Stream<StudentsState> _mapSearchStudentsToState(SearchStudents event) async* {
    yield StudentsSearch.loading();
    try {
      List<Students?>? notes =
          await _getSearchResults(event.notes, event.query);
      yield StudentsSearch.success(notes);
    } catch (_) {
      yield StudentsSearch.failure();
    }
  }

  @override
  void add(StudentsEvent event) {
    super.add(event);
  }

  Future<List<Students?>?>? _getSearchResults(
      List<Students?>? notes, String query) async {
    var searchedStudents = query != ""
        ? notes?.where((element) {
            return element!.studentName!
                .toLowerCase()
                .startsWith(query.toLowerCase());
          }).toList()
        : notes;
    return searchedStudents;
  }
}
