import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:tutah/screens/admin/edits/program_edit.dart';

import '../components/database.dart';
import '../components/dialogs.dart';
import '../components/token_manager.dart';
import '../constants.dart';

class Program {
  final String name;
  final String description;
  final String requirements;
  final String imagePath;
  final int durationInYears;
  final int totalCourses;
  final List<String> industries;
  final List<String> roleModels;

  Program(this.name, this.description, this.requirements, this.imagePath, this.durationInYears, this.totalCourses, this.industries, this.roleModels);
}


class ProgramListScreen extends StatefulWidget {
  const ProgramListScreen({super.key});

  @override
  _ProgramListScreen createState() => _ProgramListScreen();
}

class _ProgramListScreen extends State<ProgramListScreen> {

  List programs = [];
  bool stopFnFlag = false;
  bool dataDeleted = false;

  Future<void> getProgramForDepartmentFromDatabase(int id) async {
    final db = await DatabaseHelper.getDatabase();
    final result = await db.query('tutah_program', where: 'faculty_dept_id = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      // Use the retrieved data as needed
      setState(() {
        programs = result;
        stopFnFlag = true;
      });
    } else {
      // Handle the case when no data is found for the provided id
    }
  }

  @override
  Widget build(BuildContext context) {
    final department = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final id = department['id'];

    if(!stopFnFlag){
      // Call the method to retrieve data from the local database
      getProgramForDepartmentFromDatabase(id);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Program List'),
      ),
      body:
      programs.isEmpty ?
          const Center(child: CircularProgressIndicator(),):
      dataDeleted ?
      Dialogs().okPopDialog(context, 'Record deleted successfully'):
      ListView.builder(
        itemCount: programs.length,
        itemBuilder: (BuildContext context, int index) {
          return ProgramCard(
            program: programs[index],
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => ProgramDetailsScreen(programs[index]),
              //   ),
              // );

              print('hello');

              Map program = programs[index];

              Navigator.pushNamed(
                  context,
                  'courses',
                  arguments: program
              );
            },
          );
        },
      ),
    );
  }
}

class ProgramCard extends StatefulWidget {
  final Map program;
  final VoidCallback onTap;

  ProgramCard({required this.program, required this.onTap});

  @override
  _ProgramCardState createState() => _ProgramCardState();
}

class _ProgramCardState extends State<ProgramCard> {
  bool isExpanded = false;
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
        body:{
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
            msg: "Program deleted",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );

        Navigator.pushNamed(
            context,
            'home'
        );

      } else {

        print('Data inserted successfully.');

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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ListTile(
            onTap: widget.onTap,
            title: Text(widget.program['name'], style: const TextStyle(fontWeight: FontWeight.bold),),
            trailing: IconButton(
              icon: Icon(
                isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              ),
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),
          ),
          if (isExpanded)
            Column(
              children: [
                widget.program['description'].isEmpty ? Container():
                const Text('Description', style: TextStyle(color: Colors.blue, fontSize: 17, fontWeight: FontWeight.bold),),
                widget.program['description'].isEmpty ? Container():
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.program['description'], style: const TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 10,),
                widget.program['requirements'].isEmpty ? Container():
                const Text('Requirements', style: TextStyle(color: Colors.blue, fontSize: 17, fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.all(8.0),

                  child: Text(widget.program['requirements'], style: const TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 10,),
                !isTokenAvailable
                    ?
                Container():
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(onPressed: () async {

                      Dialogs().choiceDialog(context, 'Edit program?',
                          'This action cannot be undone.',
                              () async {

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProgramScreen(
                                  name: widget.program['name'],
                                  code: widget.program['code'],
                                  description: widget.program['description'],
                                  initialPgId: widget.program['id'],
                                  requirements: widget.program['requirements'],
                                  years: widget.program['years'].toString(),
                                ),
                              ),
                            );
                          //
                          });

                    }, icon: const Icon(Icons.edit)),
                    IconButton(onPressed: () async {

                      Dialogs().choiceDialog(context, 'Delete program?',
                          'Courses depending on this program will be deleted.',
                              () async {

                            await deleteEntity('program', widget.program['id']);

                          });

                    }, icon: const Icon(Icons.delete)),
                  ],
                )
              ],
            ),
        ],
      ),
    );
  }
}

