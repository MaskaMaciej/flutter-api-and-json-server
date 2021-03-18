import 'package:api_and_json_server/core/service_locator.dart';
import 'package:api_and_json_server/data/database/moor_database.dart';
import 'package:api_and_json_server/screens/home/bloc/home_bloc.dart';
import 'package:api_and_json_server/screens/home/widgets/error_screen.dart';
import 'package:api_and_json_server/screens/home/widgets/loading_screen.dart';
import 'package:api_and_json_server/services/database_service/database_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        BlocProvider.of<HomeBloc>(context)
            .add(HomeRefreshDataEvent(filter: RefreshEnum.all));
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    close(context, null);
    return LoadingScreen();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: locator.get<DatabaseInterface>().getAllUsers(),
      // ignore: missing_return
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<User> users = snapshot.data;
          List<String> usersNames =
              users.map((user) => user.name.toUpperCase()).toList();
          List<String> suggestionList = query.isEmpty
              ? usersNames
              : usersNames
                  .where((q) => q.startsWith(query.toUpperCase()))
                  .toList();
          return ListView.separated(
            itemCount: suggestionList == null ? 0 : suggestionList.length,
            separatorBuilder: (context, i) => Divider(),
            itemBuilder: (context, i) => ListTile(
              onTap: () {
                BlocProvider.of<HomeBloc>(context)
                    .add(HomeGetSingleUserEvent(id: users[i].id));
                close(context, null);
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
        } else if (snapshot.hasError) {
          return ErrorScreen(
            error: snapshot.error.toString(),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingScreen();
        }
      },
    );
  }
}
