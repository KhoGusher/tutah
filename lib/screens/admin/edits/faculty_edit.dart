import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

import '../../../components/database.dart';
import '../../../components/dialogs.dart';
import '../../../constants.dart';


class EditFacultyScreen extends StatefulWidget {
  final int initialFacultyId;
  final String initialName;
  final String initialDesc;

  const EditFacultyScreen({
    Key? key,
    required this.initialName,
    required this.initialDesc,
    required this.initialFacultyId,
  }) : super(key: key);

  @override
  _EditFacultyScreenState createState() => _EditFacultyScreenState();
}

class _EditFacultyScreenState extends State<EditFacultyScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descController;

  bool _hasChanges = false;
  bool _hasStartedEditing = false;
  bool dataUpdated = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _descController = TextEditingController(text: widget.initialDesc);
  }

  void _handleTextChange() {
    if (!_hasStartedEditing) {
      setState(() {
        _hasStartedEditing = true;
      });
    }

    // Set the _hasChanges flag to true when any text field value changes
    setState(() {
      _hasChanges = true;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submitChanges() async {
    // Retrieve the updated values from the text fields
    final newName = _nameController.text;
    final newDesc = _descController.text;

    print('object');

    // /admin/update-school-data
    // Submit the updated values to the backend for updating the school information
    // You can implement the API call or database update logic here

    http.Response? response; // Declare the response variable with a default value

    try {
      response = await http.post(
        Uri.parse('$baseUrl/api/tutah/admin/update-faculty-data'),
        headers: {
          "Accept": "application/json",
        },
        body: {
          'id': jsonEncode(widget.initialFacultyId),
          'name': newName,
          'description': newDesc
        },
      );

      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);

        // update local DB
        Database tutahDB = await DatabaseHelper.getDatabase();

        // update local DB
        print(res);
        await tutahDB.rawUpdate(
            'UPDATE tutah_faculty SET name = ?, description = ? WHERE id = ?',
            [newName, newDesc, widget.initialFacultyId]);

        await tutahDB.close();

        // Optionally, you can display a success message or navigate back to the previous screen

        // here
        Fluttertoast.showToast(
            msg: "Record updated",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
        );

        Navigator.pop(context);
        Navigator.pop(context);

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit School'),
      ),
      body:
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              onChanged: (value) {
                if (!_hasStartedEditing) {
                  setState(() {
                    _hasStartedEditing = true;
                  });
                }
                _handleTextChange();
              },
            ),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Code'),
              onChanged: (value) {
                if (!_hasStartedEditing) {
                  setState(() {
                    _hasStartedEditing = true;
                  });
                }
                _handleTextChange();
              },
            ),
            TextField(
              onChanged: (value) {
                if (!_hasStartedEditing) {
                  setState(() {
                    _hasStartedEditing = true;
                  });
                }
                _handleTextChange();
              },
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Mission'),
            ),
            ElevatedButton(
              onPressed: _hasChanges ? _submitChanges : null,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
