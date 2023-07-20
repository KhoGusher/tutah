import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

import '../../../components/database.dart';
import '../../../components/dialogs.dart';
import '../../../constants.dart';


class EditProgramScreen extends StatefulWidget {
  final int initialPgId;
  final String name;
  final String code;
  final String description;
  final String requirements;
  final String years;

  const EditProgramScreen({
    Key? key,
    required this.name,
    required this.code,
    required this.description,
    required this.initialPgId,
    required this.requirements,
    required this.years,
  }) : super(key: key);

  @override
  _EditProgramScreenState createState() => _EditProgramScreenState();
}

class _EditProgramScreenState extends State<EditProgramScreen> {
  late TextEditingController _nameController;
  late TextEditingController _codeController;
  late TextEditingController _descController;
  late TextEditingController _reqController;
  late TextEditingController _yearsController;

  bool _hasChanges = false;
  bool _hasStartedEditing = false;
  bool dataUpdated = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _codeController = TextEditingController(text: widget.code);
    _descController = TextEditingController(text: widget.description);
    _reqController = TextEditingController(text: widget.requirements);
    _yearsController = TextEditingController(text: widget.years);
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
    _descController.dispose();
    _reqController.dispose();
    _yearsController.dispose();
    super.dispose();
  }

  /*
  * _codeController = TextEditingController(text: widget.code);
    _descController = TextEditingController(text: widget.description);
    _reqController = TextEditingController(text: widget.requirements);
    _yearsController = TextEditingController(text: widget.years);
  * */

  Future<void> _submitChanges() async {
    // Retrieve the updated values from the text fields
    final newName = _nameController.text;
    final newCode = _codeController.text;
    final newDesc = _descController.text;
    final newReq = _reqController.text;
    final newYrs = _yearsController.text;

    print('object');

    // /admin/update-school-data
    // Submit the updated values to the backend for updating the school information
    // You can implement the API call or database update logic here

    http.Response? response; // Declare the response variable with a default value

    try {
      response = await http.post(
        Uri.parse('$baseUrl/api/tutah/admin/update-program-data'),
        headers: {
          "Accept": "application/json",
        },
        body: {
          'id': jsonEncode(widget.initialPgId),
          'name': newName,
          'code': newCode,
          'description': newDesc,
          'requirement': newReq,
          'years': newYrs,
        },
      );

      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);

        // update local DB
        Database tutahDB = await DatabaseHelper.getDatabase();

        // update local DB
        print(res);
        await tutahDB.rawUpdate(
            'UPDATE tutah_program SET name = ?, code = ?, description=?, requirements=?, years=?  WHERE id = ?',
            [newName, newCode, newDesc, newReq, newYrs, widget.initialPgId]);

        await tutahDB.close();

        // Optionally, you can display a success message or navigate back to the previous screen

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

      } else {
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
      Dialogs().okPopDialog(context, 'Program records updated successfully'):
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
              controller: _reqController,
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
              controller: _yearsController,
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
