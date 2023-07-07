import 'package:flutter/material.dart';
import 'package:tutah/screens/home/schools.dart';

import '../../../constants.dart';
import 'header_with_searchbox.dart';


class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    // It will prove us total height  and width of our screen
    Size size = MediaQuery.of(context).size;
    // it enable scrolling on small device
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          HeaderWithSearchBox(size: size),
          const Schools(),
        ],
      ),
    );
  }
}
