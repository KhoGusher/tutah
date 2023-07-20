import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

import '../../../constants.dart';

class UploadCSV extends StatefulWidget {
  const UploadCSV({super.key});

  @override
  _UploadCSV createState() => _UploadCSV();
}

class _UploadCSV extends State<UploadCSV> {
  FilePickerResult? _filePickerResult;

  Future<void> uploadFile(FilePickerResult filePickerResult) async {
    if (filePickerResult != null) {
      String? filePath = filePickerResult.files.single.path;
      if (filePath != null) {
        try {
          var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/api/tutah/admin/upload-csv'));
          request.files.add(await http.MultipartFile.fromPath(
            'csvFile',
            filePath,
            contentType: MediaType.parse(lookupMimeType(filePath)!),
          ));

          print('steps 1');

          http.StreamedResponse response = await request.send();
          if (response.statusCode == 200) {
            // File uploaded successfully
            Fluttertoast.showToast(
              msg: "File uploaded successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0,
            );

            Navigator.pop(context);
          } else {
            // Handle the error
            // print('File upload failed with status code: ${response.statusCode}');
            Fluttertoast.showToast(
              msg: "File upload failed. Status code: ${response.statusCode}, please try again",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
        } catch (e) {
          // Handle the exception
          print('File upload failed with exception: $e');
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
    }
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    setState(() {
      _filePickerResult = result;
    });

    // backend
    uploadFile(_filePickerResult!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: pickFile,
              child: const Text('Pick CSV File'),
            ),
            SizedBox(height: 10,),
            if (_filePickerResult != null)
              Text(
                'Selected file: ${_filePickerResult!.files.single.name}',
                style: TextStyle(fontSize: 18),
              ),
          ],
        ),
      ),
    );
  }
}
