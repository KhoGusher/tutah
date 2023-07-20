import 'package:flutter/material.dart';
import 'package:tutah/screens/admin/file_upload/upload_csv.dart';
import 'package:tutah/screens/courses_etc.dart';
import 'package:tutah/screens/home/faculty_department.dart';
import 'package:tutah/screens/home/home_screen.dart';
import 'package:tutah/screens/login/login.dart';
import 'package:tutah/screens/programs.dart';


import 'constants.dart';

void main() {
  runApp(
      const MyApp()
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: kBackgroundColor,
        primaryColor: kPrimaryColor,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:  const HomeScreen(),
      routes: {
        'home': (context) => const HomeScreen(),
        'login': (context) => const Login(),
        'facultyDept': (context) => const FacultyList(),
        'programList': (context) => const ProgramListScreen(),
        'upload': (context) => const UploadCSV(),
        'courses': (context) => const ProgramDetailsScreen(),


      },
    );
  }
}


