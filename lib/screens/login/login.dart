import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tutah/screens/home/home_screen.dart';

import '../../api/api.dart';
import '../../utils.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _storage = const FlutterSecureStorage();

  bool loader = false;

  bool hidePassword = true;

  void hideMyPass() {
    if (hidePassword) {
      setState(() {
        hidePassword = false;
      });
    } else {
      setState(() {
        hidePassword = true;
      });
    }
  }

  @override
  final _formkey = GlobalKey<FormState>();

  void _fetchData(BuildContext context) async {
    // login
    //
    var userData = {
      'email': _emailController.text,
      'password': _passwordController.text
      // 'phone': '+265999355983',
      // 'token':
      //     'gvSTFaGuS4Wrwv9iZ9pKLq:APA91bFhWXyJ1Tv2ljEc1PDwoeyxuTlzzdcl0tbUjDrOZQ1tBtjQmKcn4gQDDzFmm3vUecyDqvIpgmH9fUGgH5RIqx2ieK2_4gqdlIqqwY-BMQmIbAjccua1KW-IwCnuxs154-SzfUPE'
    };

    var response = await CallApi().prePostData(userData, 'login');

    if (!mounted) return;

    print('----------resp--------------');
    print(response.statusCode);
    // Failed host lookup: 'iot.mw'
    //Server response into variable

    if (response.statusCode == 201) {
      var msg = jsonDecode(response.body);

      //   {status: 1, data: {access_token: 3|lmYFEFU59rOBelggczWBSUaQn3MuqlDeScgMO3RL,
      // token_type: Bearer, next_page: home_page}, msg: Login Successful}
      print(msg);
      // const token = FlutterSecureStorage();
      // const tok = '12|w4acJ2LHbEjszIj13W3x7jFFhj543ZIxsctoj1d5';

      await _storage.write(key: 'token', value: msg['data']['access_token']);

        Navigator.pushNamed(
        context,
        'login'
      );

    } else {
      var msg = jsonDecode(response.body);
      print(msg);
      print('dim--------------------------');
      //Show Error Message Dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(msg['msg']),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();

                  setState(() {
                    loader = false;
                  });
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil._instance.init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Positioned(
            left: 240,
            bottom: 520,
            child: SizedBox(
              height: 250,
              child: Container(
                decoration:  BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: <Color>[
                        UIHelper.APPLE_GRADIENT_COLOR_ONE,
                        UIHelper.APPLE_GRADIENT_COLOR_TWO,
                      ],
                    )),
              ),
            ),
          ),
          LinearGradientMask(
            child: CustomPaint(
              painter: CurvePainter(),
              child: Container(
                height: double.infinity,
              ),
            ),
          ),
          ListView(
            children: <Widget>[
              Form(
                key: _formkey,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 230, 30, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        UIHelper.login.toUpperCase(),
                        style: const TextStyle(
                          color: UIHelper.WHITE,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        child: TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(0, 14, 20, 10),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                )),
                            focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                )),
                            //labelText: 'Password',
                            hintText: "Email",
                            hintStyle: TextStyle(
                                fontSize: 15, color: Color(0xFF5F5B54)),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Field can not be blank";
                            } else if (!RegExp(
                                r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                .hasMatch(val)) {
                              return "Enter a valid email address";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        child: TextFormField(
                          style: const TextStyle(color: Color(0xFF5F5B54)),
                          controller: _passwordController,
                          decoration: InputDecoration(
                            contentPadding:
                            const EdgeInsets.fromLTRB(0, 14, 20, 10),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            errorBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                )),
                            focusedErrorBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                )),
                            //+labelText: 'Password',
                            hintText: "Password",
                            suffixIcon: IconButton(
                                padding:
                                const EdgeInsets.fromLTRB(0, 14, 20, 10),
                                icon: hidePassword
                                    ? const Icon(
                                  Icons.visibility,
                                  color: Colors.white,
                                )
                                    : const Icon(Icons.visibility_off,
                                    color: Color(0xFF2A3C90)),
                                onPressed: hideMyPass),
                            hintStyle: const TextStyle(
                                fontSize: 15, color: Color(0xFF5F5B54)),
                          ),
                          obscureText: hidePassword ? true : false,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Field can not be blank";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                      loader
                          ? Center(child: CircularProgressIndicator())
                          : Container(
                        // decoration: ThemeHelper().buttonBoxDecoration(context),
                        child: ElevatedButton(
                          // style: ThemeHelper().buttonStyle(),
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(65, 10, 65, 10),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onPressed: () {
                            // print('fgg');
                            if (_formkey.currentState!.validate()) {
                              setState(() {
                                loader = true;
                              });
                              _fetchData(context);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}


class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = UIHelper.APPLE_GRADIENT_COLOR_TWO;
    // create a path
    var path = Path();
    path.moveTo(0, size.height * 0.30);
    path.quadraticBezierTo(size.width * 0.23, size.height * 0.14,
        size.width * 0.45, size.height * 0.25);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.39, size.width, size.height * 0.53);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class DrawPoligon extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.8);
    path.lineTo(size.width * 0.8, size.height);
    path.lineTo(size.width * 0.2, size.height);
    path.lineTo(0, size.height * 0.8);
    path.lineTo(0, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class LinearGradientMask extends StatelessWidget {
  LinearGradientMask({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) {
        return const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: <Color>[
            UIHelper.APPLE_GRADIENT_COLOR_ONE,
            UIHelper.APPLE_GRADIENT_COLOR_TWO,
          ],
          tileMode: TileMode.mirror,
        ).createShader(bounds);
      },
      child: child,
    );
  }
}
