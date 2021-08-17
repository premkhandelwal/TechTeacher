import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tech_teacher/data/currentUser.dart';
import 'package:tech_teacher/data/dataProviderFirebase.dart';
import 'package:tech_teacher/logic/bloc/cubit/internet_cubit.dart';
import 'package:tech_teacher/logic/bloc/students_bloc.dart';
import 'package:tech_teacher/repositories/students_repo.dart';
import 'package:tech_teacher/screens/home_screen.dart';
import 'package:tech_teacher/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp(
    notesRepository:
        StudentsRepository(dataProviderFirebase: DataProviderFirebase()),
    connectivity: Connectivity(),
  ));
}

class MyApp extends StatelessWidget {
  final StudentsRepository notesRepository;
  final Connectivity connectivity;
  const MyApp(
      {Key? key, required this.notesRepository, required this.connectivity})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<StudentsBloc>(
            create: (context) =>
                StudentsBloc(notesRepository: notesRepository)),
        BlocProvider<InternetCubit>(
            create: (context) => InternetCubit(connectivity: connectivity)),
      ],
      child: StreamProvider.value(
        initialData: CurrentUser.initial,
        value: FirebaseAuth.instance
            .authStateChanges()
            .map((user) => CurrentUser.create(user!)),
        child: Consumer<CurrentUser>(
      builder: (context, user, _) {
            return MaterialApp(
                  title: 'Flutter Demo',
                  theme: ThemeData(
                    primarySwatch: Colors.blue,
                    accentColor: Colors.black,
                    textTheme: TextTheme(
                      bodyText1: TextStyle(),
                      bodyText2: TextStyle(),
                    ).apply(
                      bodyColor: Colors.black,
                    ),
                  ),
                  home: /* user.data != null ? HomeScreen() : */ LoginScreen(),
                );
          },
        ),
      ),
    );
  }
}
