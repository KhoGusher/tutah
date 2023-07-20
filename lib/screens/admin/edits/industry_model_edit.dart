import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

import '../../../components/database.dart';
import '../../../components/dialogs.dart';
import '../../../constants.dart';


class EditIndustryModelScreen extends StatefulWidget {
  final int initialId;
  final String industry;
  final String roleModel;

  const EditIndustryModelScreen({
    Key? key,
    required this.industry,
    required this.roleModel,
    required this.initialId,
  }) : super(key: key);

  @override
  _EditIndustryModelScreenState createState() => _EditIndustryModelScreenState();
}

class _EditIndustryModelScreenState extends State<EditIndustryModelScreen> {
  late TextEditingController _industryController;
  late TextEditingController _roleModelController;

  bool _hasChanges = false;
  bool _hasStartedEditing = false;
  bool dataUpdated = false;

  @override
  void initState() {
    super.initState();
    _industryController = TextEditingController(text: widget.industry);
    _roleModelController = TextEditingController(text: widget.roleModel);
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
    _industryController.dispose();
    _roleModelController.dispose();
    super.dispose();
  }

  Future<void> _submitChanges() async {
    // Retrieve the updated values from the text fields
    final newIndustry = _industryController.text;
    final newModel = _roleModelController.text;

    print('object');

    // /admin/update-school-data
    // Submit the updated values to the backend for updating the school information
    // You can implement the API call or database update logic here

    http.Response? response; // Declare the response variable with a default value

    try {
      response = await http.post(
        Uri.parse('$baseUrl/api/tutah/admin/update-industry-model-data'),
        headers: {
          "Accept": "application/json",
        },
        body: jsonEncode({
          'id': widget.initialId,
          'industry': newIndustry,
          'roleModel': newModel,
        }),
      );

      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);

        // update local DB
        // update local DB
        Database tutahDB = await DatabaseHelper.getDatabase();

        // update local DB
        print(res);
        await tutahDB.rawUpdate(
            'UPDATE tutah_program_other SET industry = ?, role_model = ? WHERE id = ?',
            [newIndustry, newModel, widget.initialId]);

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
        title: const Text('Edit Record'),
      ),
      body:
      dataUpdated ?
      Dialogs().okPopDialog(context, 'Records updated successfully'):
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _industryController,
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
              controller: _roleModelController,
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
