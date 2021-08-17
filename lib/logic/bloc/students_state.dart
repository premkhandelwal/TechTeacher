part of 'students_bloc.dart';

@immutable
abstract class StudentsState {}

class StudentsInitial extends StudentsState {
  StudentsInitial();
}

class StudentsLoadInProgress extends StudentsState {}

class StudentsLoadSuccess extends StudentsState {
  StudentsLoadSuccess(this.notes);

  final List<Students?>? notes;
}

class StudentsOperationInProgress extends StudentsState {}

class StudentsOperationSuccess extends StudentsState {
  final bool success;

  StudentsOperationSuccess(this.success);
}

class StudentsSearch extends StudentsState {
  final List<Students?>? notes;
  final bool isLoading;
  final bool hasError;

  StudentsSearch({
    required this.notes,
    required this.isLoading,
    required this.hasError,
  });

  factory StudentsSearch.initial() {
    return StudentsSearch(
      notes: [],
      isLoading: false,
      hasError: false,
    );
  }

  factory StudentsSearch.loading() {
    return StudentsSearch(
      notes: [],
      isLoading: true,
      hasError: false,
    );
  }

  factory StudentsSearch.success(List<Students?>? notes) {
    return StudentsSearch(
      notes: notes,
      isLoading: false,
      hasError: false,
    );
  }

  factory StudentsSearch.failure() {
    return StudentsSearch(
      notes: [],
      isLoading: false,
      hasError: true,
    );
  }
}
