import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

import '../../../components/database.dart';
import '../../../components/dialogs.dart';
import '../../../constants.dart';


class EditFacultyDeptScreen extends StatefulWidget {
  final int initialId;
  final String initialName;
  final String initialDescription;

  const EditFacultyDeptScreen({
    Key? key,
    required this.initialId,
    required this.initialName,
    required this.initialDescription,
  }) : super(key: key);

  @override
  _EditFacultyDeptScreenState createState() => _EditFacultyDeptScreenState();
}

class _EditFacultyDeptScreenState extends State<EditFacultyDeptScreen> {
  late TextEditingController _nameController;
  late TextEditingController _codeController;

  bool _hasChanges = false;
  bool _hasStartedEditing = false;
  bool dataUpdated = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _codeController = TextEditingController(text: widget.initialDescription);
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
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _submitChanges() async {
    // Retrieve the updated values from the text fields
    final newName = _nameController.text;
    final newDesc = _codeController.text;

    print('object');

    // /admin/update-school-data
    // Submit the updated values to the backend for updating the school information
    // You can implement the API call or database update logic here

    http.Response? response; // Declare the response variable with a default value

    try {
      response = await http.post(
        Uri.parse('$baseUrl/api/tutah/admin/update-faculty-department-data'),
        headers: {
          "Accept": "application/json",
        },
        body: {
          'id': jsonEncode(widget.initialId),
          'name': newName,
          'description': newDesc
        },
      );

      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);

        // update local DB
        Database tutahDB = await DatabaseHelper.getDatabase();

        // update local DB
        await tutahDB.rawUpdate(
            'UPDATE tutah_faculty_department SET name = ?, description = ? WHERE id = ?',
            [newName, newDesc, widget.initialId]);

        await tutahDB.close();

        // Optionally, you can display a success message or navigate back to the previous screen

        Fluttertoast.showToast(
            msg: "Department records updated",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
        );

        Navigator.pop(context);



      } else {

        print('Data not inserted successfully.');

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
      dataUpdated ?
      Dialogs().okPopDialog(context, 'Department updated successfully'):
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
              controller: _codeController,
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
