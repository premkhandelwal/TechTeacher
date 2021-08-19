import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_teacher/data/dataProviderFirebase.dart';
import 'package:tech_teacher/logic/bloc/cubit/internet_cubit.dart';
import 'package:tech_teacher/logic/bloc/firebaseauth_bloc.dart';
import 'package:tech_teacher/logic/bloc/students_bloc.dart';
import 'package:tech_teacher/repositories/firebaseAuth_repo.dart';
import 'package:tech_teacher/repositories/students_repo.dart';
import 'package:tech_teacher/screens/home_screen.dart';
import 'package:tech_teacher/screens/loggingInScreen.dart';
import 'package:tech_teacher/screens/login_screen.dart';
import 'package:tech_teacher/screens/noInternetScreen.dart';
import 'package:tech_teacher/screens/verifyingEmail.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp(
    notesRepository:
        StudentsRepository(dataProviderFirebase: DataProviderFirebase()),
    connectivity: Connectivity(),
    firebaseAuthRepo: FirebaseAuthRepo(firebaseAuth: FirebaseAuth.instance),
  ));
}

class MyApp extends StatelessWidget {
  final StudentsRepository notesRepository;
  final Connectivity connectivity;
  final FirebaseAuthRepo firebaseAuthRepo;
  const MyApp(
      {Key? key,
      required this.notesRepository,
      required this.connectivity,
      required this.firebaseAuthRepo})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<StudentsBloc>(
              create: (context) =>
                  StudentsBloc(notesRepository: notesRepository)),
          BlocProvider<FirebaseauthBloc>(
              create: (context) =>
                  FirebaseauthBloc(firebaseAuthRepo: firebaseAuthRepo)),
          BlocProvider<InternetCubit>(
              create: (context) => InternetCubit(connectivity: connectivity)),
        ],
        child: MaterialApp(
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
          home: BlocBuilder<FirebaseauthBloc, FirebaseauthState>(
              builder: (context, state) {
            final internetState = context.watch<InternetCubit>().state;
            print(state);
            if (internetState is InternetDisconnected) {
              return NoInternet();
            } else {
              if (state is FirebaseauthInitial) {
                context.read<FirebaseauthBloc>().add(UserStateRequested());
              } else if (state is UserLoggedIn) {
                return HomeScreen(user: state.currentUser!);
              } else if (state is UserLoggingIn) {
                return LoggingIn();
              } else if (state is UserSignedUp) {
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            title: Text("Successfully Signed Up"),
                            content: Text("Signed Up Successfully"),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (ctx1) => AlertDialog(
                                              title: Text("Verify Your Email"),
                                              content: Text(
                                                  "Email verification link has been sent to your registered email. Please verify your email"),
                                              actions: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(ctx);
                                                      Navigator.pop(ctx1);
                                                    },
                                                    child: Text("Ok"))
                                              ],
                                            ));
                                  },
                                  child: Text("Ok"))
                            ],
                          ));
                });
              }
              return LoginScreen();
            }
          }),
        ));
  }
}
