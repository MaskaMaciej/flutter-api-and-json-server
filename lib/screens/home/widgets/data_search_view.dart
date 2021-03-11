import 'package:api_and_json_server/data/database/moor_database.dart';
import 'package:flutter/material.dart';

class DataSearch extends SearchDelegate {
  final List<User> users;

  DataSearch({@required this.users});

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
  Widget buildResults(BuildContext context) {}

  @override
  Widget buildSuggestions(BuildContext context) {
    // in following searches list contains only last found user
    // TODO: bug
    final List<String> usersNames =
        users.map((user) => user.name.toUpperCase()).toList();
    List<String> suggestionList = query.isEmpty
        ? usersNames
        : usersNames.where((q) => q.startsWith(query.toUpperCase())).toList();

    return ListView.separated(
      itemCount: suggestionList == null ? 0 : suggestionList.length,
      separatorBuilder: (context, i) => Divider(),
      itemBuilder: (context, i) => ListTile(
        onTap: () {
          close(context, users[i].id);
        },
        leading: Icon(Icons.person),
        title: RichText(
          text: TextSpan(
            text: suggestionList[i].substring(0, query.length),
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: suggestionList[i].substring(query.length),
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
