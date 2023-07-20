import 'package:flutter/material.dart';
import 'package:tutah/screens/home/schools.dart';

import '../search_results.dart';
import 'header_with_searchbox.dart';


class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String searchQuery = '';
  bool isSearching = false;

  void onSearchQueryChanged(String query) {
    print('is searching --------');
    setState(() {
      searchQuery = query;
      isSearching = query.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    // It will prove us total height  and width of our screen
    Size size = MediaQuery.of(context).size;
    // it enable scrolling on small device
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          HeaderWithSearchBox(
            size: size,
            onSearchQueryChanged: onSearchQueryChanged,
          ),
          isSearching
              ? SizedBox(
              height: isSearching ? MediaQuery.of(context).size.height - 200 : 0,
              child: SearchResults(query: searchQuery))
              : const Schools(),
        ],
      ),
    );
  }
}
