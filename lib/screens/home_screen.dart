import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_teacher/data/students.dart';
import 'package:tech_teacher/logic/bloc/cubit/internet_cubit.dart';
import 'package:tech_teacher/logic/bloc/students_bloc.dart';
import 'package:tech_teacher/screens/addUpdate_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = new TextEditingController();
  List<Students?>? notes = [];
  @override
  void initState() {
    context.read<StudentsBloc>().add(FetchAllStudents());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 15),
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, istrue) {
            return [
              SliverAppBar(
                stretch: true,
                floating: true,
                snap: true,
                title: _topActions(
                  context,
                ),
                automaticallyImplyLeading: false,
                centerTitle: true,
                titleSpacing: 0,
                backgroundColor: Colors.transparent,
                elevation: 10,
                expandedHeight: 10,
              )
            ];
          },
          body: RefreshIndicator(
            onRefresh: () async {
              // if the internet connection is available or not etc..
              await Future.delayed(
                Duration(seconds: 2),
              );
              context.read<InternetCubit>();
              context.read<StudentsBloc>().add(FetchAllStudents());
            },
            child: BlocBuilder<StudentsBloc, StudentsState>(
              builder: (context, state) {
                final internetState = context.watch<InternetCubit>().state;

                if (internetState is InternetConnected) {
                  if (state is StudentsInitial) {
                    context.read<StudentsBloc>().add(FetchAllStudents());
                    return Center(child: CircularProgressIndicator());
                  } else if (state is StudentsLoadSuccess) {
                    notes = state.notes;
                    return state.notes!.length != 0
                        ? buildGridView(notes)
                        : Center(
                            child: Text(
                              "No Items Present",
                              style: TextStyle(fontSize: 15),
                            ),
                          );
                  } else if (state is StudentsSearch) {
                    notes = state.notes;
                    return state.notes!.length != 0
                        ? buildGridView(notes)
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
                } else {
                  return Center(
                      child: Text(
                    "No Internet",
                    style: TextStyle(fontSize: 30),
                  ));
                }
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddUpdateScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _topActions(BuildContext context) => Container(
        width: double.infinity,
        height: 60,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: <Widget>[
                const SizedBox(width: 20),
                const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: searchController,
                    onChanged: (val) {
                      context
                          .read<StudentsBloc>()
                          .add(SearchStudents(val, notes));
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: 'Search your notes',
                        hintStyle: TextStyle(fontSize: 20)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget buildGridView(List<Students?>? notes) {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.all(10),
      scrollDirection: Axis.vertical,
      itemCount: notes?.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 1.2,
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
                  notes: notes?[index],
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
        buildRichText("Date: ", "${notes?[index]?.dateofBirth}"),
        SizedBox(height: 20),
        buildRichText("Company Name: ", "${notes?[index]?.studentName}"),
        SizedBox(height: 20),
        buildRichText("Sales/Purchase: ", "${notes?[index]?.studentGender}"),
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
