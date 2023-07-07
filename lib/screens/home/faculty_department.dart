import 'package:flutter/material.dart';

class Faculty {
  final String name;
  final List<String> departments;

  Faculty(this.name, this.departments);
}

class FacultyList extends StatelessWidget {
  final List<Faculty> faculties = [
    Faculty('Faculty of Engineering', ['Electrical', 'Civil', 'Mechanical']),
    Faculty('Faculty of Commerce', ['Accounting', 'Finance', 'Marketing']),
    Faculty('Faculty of Engineering', ['Electrical', 'Civil', 'Mechanical']),
    Faculty('Faculty of Commerce', ['Accounting', 'Finance', 'Marketing']),    Faculty('Faculty of Engineering', ['Electrical', 'Civil', 'Mechanical']),
    Faculty('Faculty of Commerce', ['Accounting', 'Finance', 'Marketing']),    Faculty('Faculty of Engineering', ['Electrical', 'Civil', 'Mechanical']),
    Faculty('Faculty of Commerce', ['Accounting', 'Finance', 'Marketing']),    Faculty('Faculty of Engineering', ['Electrical', 'Civil', 'Mechanical']),
    Faculty('Faculty of Commerce', ['Accounting', 'Finance', 'Marketing']),    Faculty('Faculty of Engineering', ['Electrical', 'Civil', 'Mechanical']),
    Faculty('Faculty of Commerce', ['Accounting', 'Finance', 'Marketing']),
    Faculty('Faculty of Engineering', ['Electrical', 'Civil', 'Mechanical']),
    Faculty('Faculty of Commerce', ['Accounting', 'Finance', 'Marketing']),    Faculty('Faculty of Engineering', ['Electrical', 'Civil', 'Mechanical']),
    Faculty('Faculty of Commerce', ['Accounting', 'Finance', 'Marketing']),    Faculty('Faculty of Engineering', ['Electrical', 'Civil', 'Mechanical']),
    Faculty('Faculty of Commerce', ['Accounting', 'Finance', 'Marketing']),    Faculty('Faculty of Engineering', ['Electrical', 'Civil', 'Mechanical']),
    Faculty('Faculty of Commerce', ['Accounting', 'Finance', 'Marketing']),    Faculty('Faculty of Engineering', ['Electrical', 'Civil', 'Mechanical']),
    Faculty('Faculty of Commerce', ['Accounting', 'Finance', 'Marketing']),
    // Add more faculties and departments as needed
  ];

   FacultyList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Faculties'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: faculties.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(faculties[index].name),
            trailing: IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {
                _showDepartmentPopup(context, faculties[index]);
              },
            ),
          );
        },
      ),
    );
  }

  void _showDepartmentPopup(BuildContext context, Faculty faculty) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(faculty.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: faculty.departments
                .map((department) => ListTile(
              title: Text(department),
              onTap: () {
                Navigator.pushNamed(
                    context,
                    'programList'
                );
              },
            ))
                .toList(),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Cancel'),
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

