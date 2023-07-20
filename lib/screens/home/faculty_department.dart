import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

import '../../components/database.dart';
import '../../components/dialogs.dart';
import '../../components/token_manager.dart';
import '../../constants.dart';
import '../admin/edits/faculty_dept_edit.dart';
import '../admin/edits/faculty_edit.dart';

class Faculty {
  final String name;
  final List<Map> departments;

  Faculty(this.name, this.departments);
}

class FacultyList extends StatefulWidget {
  const FacultyList({super.key});

  @override
  _FacultyList createState() => _FacultyList();
}

class _FacultyList extends State<FacultyList> {
  List faculties = [];
  bool stopFnFlag = false;
  bool noData = false;
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

  Future<void> getFacultiesFromDatabase(int id) async {
    final db = await DatabaseHelper.getDatabase();
    final result = await db
        .query('tutah_faculty', where: 'school_id = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      // Use the retrieved data as needed
      setState(() {
        faculties = result;
        stopFnFlag = true;
      });
    } else {
      // Handle the case when no data is found for the provided id
      setState(() {
        noData = true;
      });
    }
  }

  Future<void> getFacultyDepartmentsFromDatabase(Map fac) async {
    final db = await DatabaseHelper.getDatabase();
    final result = await db.query('tutah_faculty_department',
        where: 'faculty_id = ?', whereArgs: [fac['id']]);

    if (result.isNotEmpty) {
      print('result---------');
      print(result);
      print(fac['name']);
      // Use the retrieved data as needed

      _showDepartmentPopup(context, fac['name'], result);
    } else {
      // Handle the case when no data is found for the provided id
    }
  }

  Future deleteEntity(entity, id) async {
    // api to delete entity
    // Retrieve the updated values from the text fields
    http.Response?
        response; // Declare the response variable with a default value

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

        await tutahDB.rawUpdate('DELETE FROM tutah_$entity WHERE id = ?', [id]);

        await tutahDB.close();

        // Optionally, you can display a success message or navigate back to the previous screen

        Navigator.pushNamed(context, 'home');
      } else {
        print(response.body);
        print('Data not inserted successfully.');
      }

      // Close the database connection
      // await tutahDB.close();
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final school =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final id = school['id'];

    if (!stopFnFlag) {
      // Call the method to retrieve data from the local database
      getFacultiesFromDatabase(id);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Faculties'),
        centerTitle: true,
      ),
      body: faculties.isEmpty
          ? noData
              ? const Center(
                  child: Text(
                    'Faculties will appear here',
                    style: TextStyle(fontSize: 17),
                  ),
                )
              : const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: faculties.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    ListTile(
                      title: GestureDetector(
                          onTap: () async {
                            await getFacultyDepartmentsFromDatabase(
                                faculties[index]);
                          },
                          child: Center(child: Text(faculties[index]['name'], style: TextStyle(fontWeight: FontWeight.bold),))),
                    ),
                    !isTokenAvailable
                        ?
                    Container():
                    Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () async {
                                  Dialogs().choiceDialog(
                                      context,
                                      'Edit record?',
                                      'This action cannot be undone.',
                                      () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditFacultyScreen(
                                            initialFacultyId: faculties[index]
                                                ['id'],
                                            initialName: faculties[index]
                                                ['name'],
                                            initialDesc: faculties[index]
                                                ['description']),
                                      ),
                                    );
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  Dialogs().choiceDialog(
                                      context,
                                      'Delete record?',
                                      'This action cannot be undone.',
                                      () async {
                                    await deleteEntity(
                                        'faculty', faculties[index]['id']);
                                  });
                                },
                              ),
                            ],
                          ),
                    const Divider()
                  ],
                );
              },
            ),
    );
  }

  void _showDepartmentPopup(BuildContext context, String name, List faculty) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text(name, style: TextStyle(fontSize: 18, color: Colors.blue),)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: faculty
                .map((department) => Column(
                      children: [
                        ListTile(
                          title: Center(child: Text(department['name'], style: TextStyle(fontWeight: FontWeight.bold),)),
                          onTap: () {
                            Navigator.pushNamed(context, 'programList',
                                arguments: department);
                          },
                        ),
                        !isTokenAvailable
                            ?
                        Container():
                        Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        Dialogs().choiceDialog(
                                            context,
                                            'Edit department?',
                                            'This action cannot be undone!',
                                            () async {
                                          Navigator.pop(context);

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditFacultyDeptScreen(
                                                      initialId:
                                                          department['id'],
                                                      initialName:
                                                          department['name'],
                                                      initialDescription:
                                                          department[
                                                              'description']),
                                            ),
                                          );
                                          //
                                        });
                                      },
                                      icon: const Icon(Icons.edit)),
                                  IconButton(
                                      onPressed: () async {
                                        Dialogs().choiceDialog(
                                            context,
                                            'Delete program?',
                                            'Program and Courses depending on this department will be deleted!',
                                            () async {
                                          await deleteEntity(
                                              'program', department['id']);
                                        });
                                      },
                                      icon: const Icon(Icons.delete)),
                                ],
                              ),
                        const Divider()
                      ],
                    ))
                .toList(),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Center(child: const Text('Cancel')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
