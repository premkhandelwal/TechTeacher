import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_teacher/data/students.dart';
import 'package:tech_teacher/logic/bloc/students_bloc.dart';
import 'package:tech_teacher/screens/home_screen.dart';

class AddUpdateScreen extends StatefulWidget {
  final bool isUpdate;
  final Students? notes;
  const AddUpdateScreen({Key? key, this.isUpdate = false, this.notes})
      : super(key: key);

  @override
  _AddUpdateScreenState createState() => _AddUpdateScreenState();
}

class _AddUpdateScreenState extends State<AddUpdateScreen> {
  TextEditingController studentName = new TextEditingController();
  TextEditingController quantity = new TextEditingController();
  TextEditingController rate = new TextEditingController();
  TextEditingController calculatedAmount = new TextEditingController();
  TextEditingController actualAmount = new TextEditingController();
  TextEditingController dateofBirthController = new TextEditingController();
  DateTime? dateofBirth;
  String? gender = "Select Gender";

  @override
  void initState() {
    if (widget.isUpdate) {
      if (widget.notes != null) {
        if (widget.notes!.studentName != null) {
          studentName.text = widget.notes!.studentName!;
        }
        if (widget.notes!.dateofBirth != null) {
          dateofBirthController.text = widget.notes!.dateofBirth!;
          String year = dateofBirthController.text.toString().split("/")[2];
          String month = dateofBirthController.text.toString().split("/")[1];
          String date = dateofBirthController.text.toString().split("/")[0];
          print(year);
          dateofBirth = DateTime.parse(year + '-' + month + '-' + date);
        }
        if (widget.notes!.studentGender != null) {
          gender = widget.notes!.studentGender!;
        }
      }
    } else {
      dateofBirth = DateTime.now();
    }
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        title: Text(
          widget.isUpdate ? "Update Note" : "Add New Note",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Form(
        key: _formKey,
        child: BlocBuilder<StudentsBloc, StudentsState>(
          builder: (context, state) {
            if (state is StudentsOperationSuccess) {
              SchedulerBinding.instance!.addPostFrameCallback((_) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Message"),
                    content: widget.isUpdate
                        ? Text(
                            "Updated Successfully",
                          )
                        : Text(
                            "Added Successfully",
                          ),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ),
                              (route) => false,
                            );
                          },
                          child: Text("Ok"))
                    ],
                  ),
                );
              });
            } else if (state is StudentsOperationInProgress) {
              return Center(child: CircularProgressIndicator());
            }
            return Container(
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    TextFormField(
                      validator: (val) {
                        print(val);
                        if (val == "") {
                          return "This is a required field";
                        }
                        return null;
                      },
                      style: TextStyle(fontSize: 20, color: Colors.black),
                      controller: studentName,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Name of Student",
                          labelStyle:
                              TextStyle(fontSize: 20, color: Colors.black54)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    DateTimeField(
                      validator: (val) {
                        if (val == null) {
                          return "This is a required field";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Date of Birth",
                        labelStyle: TextStyle(
                          color: Colors.black54,
                          fontSize: 20,
                        ),
                      ),
                      controller: dateofBirthController,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      format: DateFormat(),
                      onChanged: (selectedDate) {
                        dateofBirth = selectedDate;
                        dateofBirthController.text =
                            DateFormat("dd/MM/yyyy").format(selectedDate!);
                      },
                      initialValue: dateofBirth,
                      onShowPicker: (context, currentValue) async {
                        final time = showDatePicker(
                          firstDate: DateTime(1500),
                          lastDate: DateTime(3000),
                          initialDate: DateTime.now(),
                          helpText: "Select Date",
                          fieldLabelText: "Select Date",
                          context: context,
                        );

                        return time;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    DropdownButtonFormField(
                      validator: (val) {
                        print(val);
                        if (val == null) {
                          return "This is a required field";
                        }
                        return null;
                      },
                      decoration: InputDecoration(border: OutlineInputBorder()),
                      hint: gender == null
                          ? Text('Dropdown')
                          : Text(
                              gender!,
                              style: TextStyle(fontSize: 20),
                            ),
                      isExpanded: true,
                      iconSize: 30.0,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      value: gender,
                      items: ['Male', 'Female'].map(
                        (val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(
                              val,
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        },
                      ).toList(),
                      onChanged: (String? val) {
                        setState(
                          () {
                            gender = val;
                          },
                        );
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) callOperation();
                      },
                      child: Text("Submit"),
                    )
                    /* DropdownButton<String>(
                        style: TextStyle(color: Colors.black),
                        
                        items: [
                          DropdownMenuItem(
                            child: Text("Sale"),
                            value: value,
                          ),
                          DropdownMenuItem(
                            child: Text("Purchase"),
                            value: value,
                          ),
                        ],
                        onChanged: (value) {
                          value = value;
                        },
                      ) */
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> callOperation() async {
    context.read<StudentsBloc>().add(
          widget.isUpdate
              ? UpdateNote(
                  Students(
                      id: widget.notes!.id,
                      studentName: studentName.text,
                      dateofBirth: dateofBirthController.text,
                      studentGender: gender),
                )
              : AddNote(
                  Students(
                      studentName: studentName.text,
                      dateofBirth: dateofBirthController.text,
                      studentGender: gender),
                ),
        );
  }
}
