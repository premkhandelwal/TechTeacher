import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_teacher/logic/bloc/students_bloc.dart';
import 'package:tech_teacher/screens/addUpdate_screen.dart';
import 'package:tech_teacher/screens/view_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = new TextEditingController();

  int _selectedIndex = 0;
  int _pageIndex = 0;
  late PageController _pageController;

  List<Widget> tabPages = [
    ViewScreen(),
    
    AddUpdateScreen(),

  ];
  @override
  void initState() {
    context.read<StudentsBloc>().add(FetchAllStudents());
    _pageController = PageController(initialPage: _pageIndex);
    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
     Widget child = Container();
  switch (_pageIndex) {
    
    case 1:
      child = AddUpdateScreen();
      break;
    case 0:
      child = ViewScreen();
      break;
  }

  return Scaffold(
    body: SizedBox.expand(child: child),
    bottomNavigationBar: BottomNavigationBar(
      onTap: (newIndex) => setState(() => _pageIndex = newIndex),
      currentIndex: _pageIndex,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.view_carousel), label: "View"),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add"),

      ],
    ),
  );
  }
}
