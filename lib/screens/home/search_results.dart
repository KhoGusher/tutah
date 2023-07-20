import 'package:flutter/material.dart';
import 'package:tutah/screens/programs.dart';

import '../../components/database.dart';


class SearchResults extends StatefulWidget {

  final String query;

  const SearchResults({Key? key, required this.query}) : super(key: key);

  @override
  _SearchResults createState() => _SearchResults();
}

class _SearchResults extends State<SearchResults> {

  List searchResults = [];

  Future<void> getSearchFromDB(String query) async {
    final db = await DatabaseHelper.getDatabase();

    //
    final result = await db.query('tutah_program', where: 'name LIKE ?', whereArgs: ['%$query%']);

    print('print the results here--------------');
    print(result);

    if (result.isNotEmpty) {
      // Use the retrieved data as needed
      setState(() {
        searchResults = result;
      });
      print('view searches----------------');
      print(searchResults);

    } else {
      // Handle the case when no data is found for the provided id
    }
  }

  @override
  void initState() {
    print('init in action-------------');
    print(widget.query);

    super.initState();
    if (widget.query.isNotEmpty) {
      // Perform the database query only if the query is not empty
      print('init in action-------------');
      getSearchFromDB(widget.query);
    }
  }

  @override
  void didUpdateWidget(covariant SearchResults oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.query != oldWidget.query && widget.query.isNotEmpty) {
      // Perform the database query only if the query has changed and is not empty
      print('update in action-------------');

      getSearchFromDB(widget.query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return
      searchResults.isEmpty ?
      const Center(child: CircularProgressIndicator(),):
      ListView.builder(
        shrinkWrap: true,
        itemCount: searchResults.length,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return ProgramCard(
            program: searchResults[index],
            onTap: () {
              Map program = searchResults[index];

              Navigator.pushNamed(
                context,
                'courses',
                arguments: program,
              );
            },
          );
        },
      );
  }
}
