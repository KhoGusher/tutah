import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dialogs {
  okPopDialog(BuildContext context, String message) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return AlertDialog(
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);

              }, child: const Text("OK")),
            ],
            // The background color
            backgroundColor: Colors.white,
            content: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(message),
            ),
          );
        });
  }

  okPopRefreshDialog(BuildContext context, String message) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return AlertDialog(
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);

                Navigator.pushNamed(
                    context,
                    'home'
                );

              }, child: const Text("OK")),
            ],
            // The background color
            backgroundColor: Colors.white,
            content: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(message),
            ),
          );
        });
  }

  choiceDialog(BuildContext context, String title, String message, callback) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return AlertDialog(
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);

                callback();

              }, child: const Text("OK")),

              TextButton(onPressed: (){
                Navigator.pop(context);

              }, child: const Text("Cancel")),
            ],
            // The background color
            backgroundColor: Colors.white,
            title: Text(title),
            content: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(message),
            ),
          );
        });
  }
}