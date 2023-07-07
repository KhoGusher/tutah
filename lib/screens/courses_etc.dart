import 'package:flutter/material.dart';
import 'package:tutah/screens/programs.dart';


class Course {
  final String name;
  final String description;

  Course(this.name, this.description);
}

class ProgramDetailsScreen extends StatelessWidget {
  final Program program;

  const ProgramDetailsScreen(this.program, {super.key});

  @override
  Widget build(BuildContext context) {
    print(program.name);
    print(program.totalCourses);
    print(program.industries);
    return Scaffold(
      appBar: AppBar(
        title: Text(program.name),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Center(
            child: Image.asset(
              program.imagePath,
              height: 200,
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            program.description,
            style: TextStyle(fontSize: 18.0),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.0),
          Text(
            'Course Details',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          for (int i = 1; i <= program.totalCourses; i++)
            ListTile(
              leading: CircleAvatar(
                child: Text(i.toString()),
              ),
              title: Text('Course $i'),
              subtitle: Text('Description of Course $i'),
            ),
          SizedBox(height: 24.0),
          Text(
            'Industries',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              for (String industry in program.industries)
                Chip(
                  label: Text(industry),
                ),
            ],
          ),
          SizedBox(height: 24.0),
          Text(
            'Role Models',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              for (String roleModel in program.roleModels)
                Chip(
                  label: Text(roleModel),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

