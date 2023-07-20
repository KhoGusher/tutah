import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:tutah/screens/admin/edits/course_edit.dart';

import '../components/database.dart';
import '../components/dialogs.dart';
import '../components/token_manager.dart';
import '../constants.dart';


class Course {
  final String name;
  final String description;

  Course(this.name, this.description);
}

class ProgramDetailsScreen extends StatefulWidget {

  const ProgramDetailsScreen({super.key});

  @override
  _ProgramDetailsScreen createState() => _ProgramDetailsScreen();
}

class _ProgramDetailsScreen extends State<ProgramDetailsScreen> {

  List courses = [];
  List industryAndModel = [];
  bool stopFnFlag = false;
  bool dataDeleted = false;

  bool isTokenAvailable = false;

  @override
  void initState() {
    super.initState();

    _getToken().then((token) {
      print('how many----------------');
      print(token != null);
      setState(() {
        isTokenAvailable = token != null;
      });
    });

  }

  Future<String?> _getToken() async {
    return await TokenManager().getToken();
  }

  Future deleteEntity(entity, id) async {
    // api to delete entity
      // Retrieve the updated values from the text fields
      http.Response? response; // Declare the response variable with a default value

      try {
        response = await http.post(
          Uri.parse('$baseUrl/api/tutah/admin/delete-entity'),
          headers: {
            "Accept": "application/json",
          },
          body: {
            'entity': entity,
            'id': jsonEncode(id),
          },
        );

        if (response.statusCode == 200) {
          var res = jsonDecode(response.body);

          // update local DB
          Database tutahDB = await DatabaseHelper.getDatabase();

          // update local DB

            await tutahDB.rawUpdate(
                'DELETE FROM tutah_$entity WHERE id = ?',
                [id]);

          await tutahDB.close();

          // Optionally, you can display a success message or navigate back to the previous screen

          Fluttertoast.showToast(
              msg: "Record deleted",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );

          Navigator.pop(context);


        } else {

          // handle error
          print('Data  not inserted.');

        }

        // Close the database connection
        // await tutahDB.close();
      } catch (e) {
        Fluttertoast.showToast(
          msg: "File upload failed. Exception: $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
  }

  Future<void> getCoursesForProgramFromDatabase(int id) async {
    final db = await DatabaseHelper.getDatabase();
    final result = await db.query('tutah_course', where: 'program_id = ?', whereArgs: [id]);
    final temp = await db.query('tutah_program_other', where: 'program_id = ?', whereArgs: [id]);

    print(result);
    print(temp);

    if (result.isNotEmpty || temp.isNotEmpty) {
      // Use the retrieved data as needed
      setState(() {
        courses = result;
        industryAndModel = temp;
        stopFnFlag = true;
      });
      print('view courses----------------');
      print(industryAndModel);
    } else {
      // Handle the case when no data is found for the provided id
    }
  }


  @override
  Widget build(BuildContext context) {
    final program = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final id = program['id'];

    if(!stopFnFlag){
      // Call the method to retrieve data from the local database
      getCoursesForProgramFromDatabase(id);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(program['name']),
      ),
      body:
      courses.isEmpty && industryAndModel.isEmpty ?
          const Center(child: CircularProgressIndicator()):
       ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 16.0),
          Text(
            program['description'],
            style: const TextStyle(fontSize: 18.0),
            textAlign: TextAlign.center,
          ),
          const Text(
            'Course Details',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          const SizedBox(height: 16.0),
          for (var course in courses)
            Dismissible(
              key: UniqueKey(),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 16.0),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              secondaryBackground: Container(
                color: Colors.blue,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 16.0),
                child: const Icon(Icons.edit, color: Colors.white),
              ),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.endToStart) {

                  if(isTokenAvailable ){

                    Dialogs().choiceDialog(context, 'Edit the record?',
                        'This action cannot be undone.',
                            () async {

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditCourseScreen(
                                initialCourseId: course['id'],
                                initialName: course['name'],
                                initialCode: course['code'],
                                initialDesc: course['description'],
                              ),
                            ),
                          );

                        });

                  }

                } else if (direction == DismissDirection.startToEnd) {

                    if(isTokenAvailable) {
                      Dialogs().choiceDialog(context, 'Do you want to delete record?',
                          'This action cannot be undone.',
                              () async {
                            await deleteEntity('course', course['id']);
                          });
                    }
                  return false; // Do not dismiss
                }
                return false; // Do not dismiss by default
              },
              onDismissed: (direction) {
                if (direction == DismissDirection.endToStart) {
                  // Delete course
                  // deleteCourse(i);
                }
              },
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(course['code'].toString().substring(0,1)),
                ),
                title: Text(course['name'], style: TextStyle(fontSize: 16),),
                subtitle: Text(course['code'], style: TextStyle(fontSize: 16),),
              ),
            ),

          const SizedBox(height: 24.0),
          const Text(
            'Industries',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          const SizedBox(height: 16.0),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              for (var industry in industryAndModel)
                GestureDetector(
                  onTap: (){

    if(isTokenAvailable) {
      Dialogs().choiceDialog(context, 'Do you want to delete the record?',
          'This action cannot be undone.',
              () async {
            await deleteEntity('program_other', industry['id']);
          });
    }
                  },
                  child: Chip(
                    label: Text(industry['industry'], style: TextStyle(fontSize: 16),),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24.0),
          const Text(
            'Role Models',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          const SizedBox(height: 16.0),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              for (var roleModel in industryAndModel)
                GestureDetector(
                  onTap: (){

    if(isTokenAvailable ) {
      Dialogs().choiceDialog(context, 'Do you want to delete the record?',
          'This action cannot be undone.',
              () async {
            await deleteEntity('program_other', roleModel['id']);
          });
    }

                  },
                  child: Chip(
                    label: Text(roleModel['role_model'], style: const TextStyle(fontSize: 16),),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

