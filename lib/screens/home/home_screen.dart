import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tutah/components/dialogs.dart';

import 'package:tutah/screens/home/components/body.dart';

import '../../components/token_manager.dart';
import '../../constants.dart';
import 'package:http/http.dart' as http;


class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key,});

  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool error = false;

  bool isTokenAvailable = false;
  String tokenVar = '';

  @override
  void initState() {
    super.initState();

    _getToken().then((token) {
      print('how many----------------');
      print(token != null);
      setState(() {
        isTokenAvailable = token != null;
        tokenVar = token!;
      });
    });

  }

  Future<String?> _getToken() async {
    return await TokenManager().getToken();
  }

  Future adminLogout(BuildContext context) async {

      http.Response? response; // Declare the response variable with a default value\\

      print(_getToken());
      print('indicator----------------------------');
      print(tokenVar);

      try {
        response = await http.post(
            Uri.parse('$baseUrl/api/tutah/admin/logout'),
            headers: {
              "Accept": "application/json",
              'Authorization': 'Bearer $tokenVar'
            });

        print('count----------------------------');
        print(response.statusCode);
        print(response.body);

        if (response.statusCode == 200) {

          TokenManager().remoteToken();

          Dialogs().okPopRefreshDialog(context, 'Logged out successfully');

          }
        else {
           setState(() {
             error = true;
           });
        }

      } catch (e) {
        print(e);

      }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(),
      body: const Body(),
      // bottomNavigationBar: const MyBottomNavBar(),
      drawer: Drawer(
        child: ListView(
          children: [
            // Drawer items
            const SizedBox(height: 250,),
            error ? const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text('Error occurred, please try again', style: TextStyle(fontSize: 17, color: Colors.red),),
            ): Container(),
            isTokenAvailable ?
            ListTile(
              leading: const Icon(Icons.upload, color: kPrimaryColor,),
              title: const Text("Upload csv"),
              onTap: (){

                Navigator.pushNamed(
                    context,
                    'upload'
                );
              },
            ):
            Container(),
            isTokenAvailable ?
            Container():
            ListTile(
              leading: const Icon(Icons.switch_access_shortcut, color: kPrimaryColor,),
              title: const Text("Login"),
              onTap: (){
                Navigator.pushNamed(
                    context,
                    'login'
                );
              },
            ),
        isTokenAvailable
        ?
            ListTile(
              leading: const Icon(Icons.switch_access_shortcut, color: kPrimaryColor,),
              title: const Text("Logout"),
              onTap: (){

                // logout
                adminLogout(context);
              },
            ):
            Container(),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: SvgPicture.asset("assets/icons/menu.svg"),
            onPressed: () {
              // print(_scaffoldKey.currentState);
              _scaffoldKey.currentState?.openDrawer();
            },
          );
        },
      ),
    );
  }
}
