import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_teacher/data/currentUser.dart';
import 'package:tech_teacher/data/students.dart';
import 'package:tech_teacher/logic/bloc/cubit/internet_cubit.dart';
import 'package:tech_teacher/logic/bloc/firebaseauth_bloc.dart';
import 'package:tech_teacher/logic/bloc/students_bloc.dart';
import 'package:tech_teacher/screens/addUpdate_screen.dart';

class ViewScreen extends StatefulWidget {
  final CurrentUser user;
  const ViewScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ViewScreenState createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  List<Students?>? notes = [];
  TextEditingController searchController = new TextEditingController();

  @override
  void initState() {
    context.read<StudentsBloc>().add(FetchAllStudents(widget.user));

    super.initState();
  }

  void signOut() async {
    final _auth = FirebaseAuth.instance;
    try {
      _auth.signOut();
      _auth.authStateChanges();
      context.read<FirebaseauthBloc>().add(SignOutRequested());
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: Text(
                  "All Students",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Colors.black,
                ),
                onPressed: signOut,
              ),
            )
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: EdgeInsets.only(top: 15),
            child: RefreshIndicator(
              onRefresh: () async {
                // if the internet connection is available or not etc..
                await Future.delayed(
                  Duration(seconds: 2),
                );
                context.read<InternetCubit>();
                context.read<StudentsBloc>().add(FetchAllStudents(widget.user));
              },
              child: BlocBuilder<StudentsBloc, StudentsState>(
                builder: (context, state) {
                  if (state is StudentsInitial) {
                    context
                        .read<StudentsBloc>()
                        .add(FetchAllStudents(widget.user));
                    return Center(child: CircularProgressIndicator());
                  } else if (state is StudentsLoadSuccess) {
                    notes = state.notes;
                    return state.notes!.length != 0
                        ? buildGridView(notes, widget.user)
                        : Center(
                            child: Text(
                              "No Items Present",
                              style: TextStyle(fontSize: 15),
                            ),
                          );
                  } else if (state is StudentsSearch) {
                    notes = state.notes;
                    return state.notes!.length != 0
                        ? buildGridView(notes, widget.user)
                        : Center(
                            child: Text(
                              "No Items Present",
                              style: TextStyle(fontSize: 15),
                            ),
                          );
                  } else {
                    return Center(
                      child: Text(
                        "No Items Present",
                        style: TextStyle(fontSize: 30),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildGridView(List<Students?>? notes, CurrentUser user) {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.all(10),
      scrollDirection: Axis.vertical,
      itemCount: notes?.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 2.5,
        mainAxisSpacing: 20,
      ),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddUpdateScreen(
                  isUpdate: true,
                  students: notes?[index],
                  user: user,
                ),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 5.0,
                  spreadRadius: 3.0,
                )
              ],
            ),
            child: buildContent(notes, index),
          ),
        );
      },
    );
  }

  Widget buildContent(List<Students?>? notes, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildRichText("Student Name: ", "${notes?[index]?.studentName}"),
        SizedBox(height: 20),
        buildRichText("Date of Birth: ", "${notes?[index]?.dateofBirth}"),
        SizedBox(height: 20),
        buildRichText("Gender: ", "${notes?[index]?.studentGender}"),
        SizedBox(height: 20),
      ],
    );
  }

  RichText buildRichText(String? key, String? value) {
    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(
        text: "$key",
        style: TextStyle(
          color: Colors.black,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: "$value",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.normal),
          )
        ],
      ),
    );
  }
}
