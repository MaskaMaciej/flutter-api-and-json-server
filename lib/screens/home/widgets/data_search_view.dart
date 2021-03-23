import 'package:flutter/material.dart';

import '../../../core/service_locator.dart';
import '../../../data/database/moor_database.dart';
import '../../../services/database_service/database_interface.dart';
import 'error_screen.dart';
import 'loading_screen.dart';

class DataSearch extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: locator.get<DatabaseInterface>().getAllUsers(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<User> users = snapshot.data as List<User>;
          List<User> suggestionList = query.isEmpty
              ? users
              : users
                  .where((q) =>
                      q.name.toUpperCase().startsWith(query.toUpperCase()))
                  .toList();
          return ListView.separated(
            itemCount: suggestionList.length == 0 ? 0 : suggestionList.length,
            separatorBuilder: (context, i) => Divider(),
            itemBuilder: (context, i) => ListTile(
              onTap: () {
                close(context, suggestionList[i].id);
              },
              leading: Icon(Icons.person),
              title: RichText(
                text: TextSpan(
                  text: suggestionList[i].name.substring(0, query.length),
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: suggestionList[i].name.substring(query.length),
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingScreen();
        } else if (snapshot.hasError) {
          return ErrorScreen(
            error: snapshot.error.toString(),
          );
        } else {
          return ErrorScreen(error: 'Coś poszło nie tak!');
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: locator.get<DatabaseInterface>().getAllUsers(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<User> users = snapshot.data as List<User>;
          List<User> suggestionList = query.isEmpty
              ? users
              : users
                  .where((q) =>
                      q.name.toUpperCase().startsWith(query.toUpperCase()))
                  .toList();
          return ListView.separated(
            itemCount: suggestionList.length == 0 ? 0 : suggestionList.length,
            separatorBuilder: (context, i) => Divider(),
            itemBuilder: (context, i) => ListTile(
              onTap: () {
                close(context, suggestionList[i].id);
              },
              leading: Icon(Icons.person),
              title: RichText(
                text: TextSpan(
                  text: suggestionList[i].name.substring(0, query.length),
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: suggestionList[i].name.substring(query.length),
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingScreen();
        } else if (snapshot.hasError) {
          return ErrorScreen(
            error: snapshot.error.toString(),
          );
        } else {
          return ErrorScreen(error: 'Coś poszło nie tak!');
        }
      },
    );
  }
}
