import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:tutah/components/token_manager.dart';
import 'package:tutah/screens/admin/edits/school_edit.dart';

import '../../../constants.dart';
import '../../components/database.dart';


class Schools extends StatefulWidget {

  const Schools({super.key,});

  @override
  _Schools createState() => _Schools();
}

class _Schools extends State<Schools> {

  List schools = [];
  bool noData = false;
  String searchQuery = '';
  bool isTokenAvailable = false;

  @override
  void initState() {
    super.initState();

    getOnlineData();

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

  void getOnlineData() async {

    http.Response? response; // Declare the response variable with a default value

    try {


      print('b4-----------------');
      print(await TokenManager().getToken());

       response = await http.get(
          Uri.parse('$baseUrl/api/tutah/all/retrieve-online-data'),
          headers: {
            "Accept": "application/json",
          });

      print('count----------------------------');
      print(response.body);

      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        Database tutahDB = await DatabaseHelper.getDatabase();

        if(res['data']['schools'].isEmpty){
          setState(() {
            noData = true;
          });
          return;
        }

        // check if DB has data
        List<Map<String, dynamic>> temp = await tutahDB.query('tutah_school');

        print(temp);

        if(temp.isNotEmpty){

          setState(() {
            schools = temp;
          });

        } else {

          // insert schools into database
          for(var xul in res['data']['schools']){

            setState(() {
              schools = res['data']['schools'];
            });

            // insert into local DB
            await tutahDB.insert('tutah_school', {
              'id': xul['id'],
              'name': xul['name'],
              'code': xul['code'],
              'mission': xul['mission']
            });
          }
          for(var facu in res['data']['faculties']){
            // insert into local DB
            await tutahDB.insert('tutah_faculty', {
              'id': facu['id'],
              'school_id': facu['school_id'],
              'name': facu['name'],
              'description': facu['description']
            });
          }
          // insert into faculty departments
          for(var facDept in res['data']['facultyDept']){
            // insert into local DB
            await tutahDB.insert('tutah_faculty_department', {
              'id': facDept['id'],
              'faculty_id': facDept['faculty_id'],
              'name': facDept['name'],
              'description': facDept['description']
            });
          }
          for(var pg in res['data']['programs']){
            // insert into local DB
            await tutahDB.insert('tutah_program', {
              'id': pg['id'],
              'faculty_id': pg['faculty_id'],
              'faculty_dept_id': pg['faculty_dept_id'],
              'name': pg['name'],
              'code': pg['code'],
              'description': pg['description'],
              'requirements': pg['requirements'],
              'years': pg['years']
            });
          }
          // pgFaculty
          for(var pgFa in res['data']['pgFaculty']){
            // insert into local DB
            await tutahDB.insert('tutah_program_faculty', {
              'id': pgFa['id'],
              'faculty_id': pgFa['faculty_id'],
              'program_id': pgFa['program_id']
            });
          }
          // insert program other into database
          for(var pgOther in res['data']['programsOther']){
            // insert into local DB
            await tutahDB.insert('tutah_program_other', {
              'id': pgOther['id'],
              'program_id': pgOther['program_id'],
              'industry': pgOther['industry'],
              'role_model': pgOther['role_model'],
              'description': pgOther['description']
            });
          }
          // insert into course table
          for(var cos in res['data']['courses']){
            // insert into local DB
            await tutahDB.insert('tutah_course', {
              'id': cos['id'],
              'program_id': cos['program_id'],
              'name': cos['name'],
              'code': cos['code'],
              'description': cos['description']
            });
          }
          print('Data inserted successfully.');

        }

        // Close the database connection
        await tutahDB.close();

      }
      else {
        print(response.body);

      }
    } catch (e) {
      print(e);

      Database tutahDB = await DatabaseHelper.getDatabase();

      List<Map<String, dynamic>> temp = await tutahDB.query('tutah_school');

      if (temp.isNotEmpty) {
        setState(() {
          schools = temp;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return
      schools.isEmpty ?
      noData ? Center(child: GestureDetector(
          onTap: (){
            getOnlineData();
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('No data available', style: TextStyle(fontSize: 17),),
              Icon(Icons.refresh)
            ],
          )),):
      const Center(child: CircularProgressIndicator()):
      SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[

              Expanded(
                child: Column(
                  children: schools.map<Widget>((school) {
                    return RecomendPlantCard(
                      image: "assets/images/mubas-logo.png", // Replace with the actual image URL or path
                      name: school['name'],
                      code: school['code'], // Replace with the actual country
                      mission: school['mission'], // Replace with the actual price
                      press: () {
                        // Handle the card press event
                      },
                      school: school,
                        isTokenAvailable: isTokenAvailable
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }



}



class RecomendPlantCard extends StatelessWidget {

  final String image, name, code;
  final String mission;
  final Map school;
  final Function press;
  final bool isTokenAvailable;

  const RecomendPlantCard({super.key, required this.image, required this.name, required this.code,
    required this.mission, required this.press, required this.school, required this.isTokenAvailable,});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding),
      // only(
      //   left: kDefaultPadding,
      //   top: kDefaultPadding / 5,
      //   bottom: kDefaultPadding * 2.5,
      // ),
      width: size.width,
      child: GestureDetector(
        onTap: (){
          // go to faculties
          Navigator.pushNamed(
              context,
              'facultyDept',
              arguments: school
          );
        },
        child: Column(
          children: <Widget>[
            if(school['code'].toString().contains('MUBAS'))...[
              Image.asset('assets/images/mubas-logo.png'),
            ],
            if(school['code'].toString().contains('MUST'))...[
              Image.asset('assets/images/must-logo.png'),
            ],
            if(school['code'].toString().contains('CHANCO'))...[
              Image.asset('assets/images/chanco-logo.jpg'),
            ],

            Container(
              padding: const EdgeInsets.all(kDefaultPadding / 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 10),
                    blurRadius: 50,
                    color: kPrimaryColor.withOpacity(0.23),
                  ),
                ],
              ),
              child: Column(
                children: <Widget>[
                  Text(
                    code,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10,),
                  Text(
                             "$name\n", style: TextStyle(fontSize: 17),),
                  const SizedBox(height: 10,),
                  const Text('MISSION', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                  const SizedBox(height: 10,),
                  Text(
                      "$mission\n", style: TextStyle(fontSize: 17),),

                !isTokenAvailable ?
                      Container():
                  IconButton(onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditSchoolScreen(
                          initialName: school['name'],
                          initialCode: school['code'],
                          initialMission: school['mission'],
                          initialId: school['id']
                        ),
                      ),
                    );
                  }, icon: const Icon(Icons.edit))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
