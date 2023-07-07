import 'package:flutter/material.dart';
import 'package:tutah/screens/courses_etc.dart';

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

class ProgramListScreen extends StatelessWidget {
  final List<Program> programs = [
    Program(
      'Bachelors in Electronics and Computer Engineering',
      'BECE is a field that takes into account Computer Science as well as Electronics ...',
      'One needs to pass excellent to come for this',
      'assets/images/image_1.png',
      5,
      60,
      ['Microsoft Corp', 'Intel'],
      ['Role Model 1', 'Role Model 2', 'Role Model 3'],
    ),
    Program(
      'Bachelors in Electronics and Telecommunications Engineering',
      'Description of Program 2',
      'One needs to pass excellent to come for this',
      'assets/images/image_2.png',
      5,
      60,
      ['Microsoft Corp', 'Intel'],
      ['Role Model 1', 'Role Model 2', 'Role Model 3'],
    ),
    Program(
      'Bachelors in Electronics and Electrical Engineering',
      'Description of Program 3',
      'One needs to pass excellent to come for this',
      'assets/images/image_3.png',
      5,
      60,
      ['Microsoft Corp', 'Intel'],
      ['Role Model 1', 'Role Model 2', 'Role Model 3'],
    ),
    // Add more programs as needed
  ];

   ProgramListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Program List'),
      ),
      body: ListView.builder(
        itemCount: programs.length,
        itemBuilder: (BuildContext context, int index) {
          return ProgramCard(
            program: programs[index],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProgramDetailsScreen(programs[index]),
                ),
              );

              print('hello');

              // Navigator.pushNamed(
              //     context,
              //     'courses'
              // );
            },
          );
        },
      ),
    );
  }
}

class ProgramCard extends StatefulWidget {
  final Program program;
  final VoidCallback onTap;

  ProgramCard({required this.program, required this.onTap});

  @override
  _ProgramCardState createState() => _ProgramCardState();
}

class _ProgramCardState extends State<ProgramCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ListTile(
            onTap: widget.onTap,
            title: Text(widget.program.name, style: const TextStyle(fontWeight: FontWeight.bold),),
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
                const Text('Description', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.program.description, style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 10,),
                const Text('Requirements', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.program.requirements, style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

