import 'package:api_and_json_server/screens/home/bloc/home_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomPopupMenuButton extends StatelessWidget {
  final HomeBloc bloc;

  const CustomPopupMenuButton({@required this.bloc});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          child: ElevatedButton(
            child: const Text('Show all'),
            onPressed: () {
              bloc.add(HomeRefreshDataEvent(filter: RefreshEnum.all));
            },
          ),
        ),
        PopupMenuItem(
          child: ElevatedButton(
            child: const Text('Show alphabetical'),
            onPressed: () {
              bloc.add(HomeRefreshDataEvent(filter: RefreshEnum.alphabetical));
            },
          ),
        ),
        PopupMenuItem(
          child: ElevatedButton(
            child: const Text('Show favorites'),
            onPressed: () {
              bloc.add(HomeRefreshDataEvent(filter: RefreshEnum.favorites));
            },
          ),
        ),
        PopupMenuItem(
          child: ElevatedButton(
            child: const Text('Show not favorites'),
            onPressed: () {
              bloc.add(HomeRefreshDataEvent(filter: RefreshEnum.notFavorites));
            },
          ),
        ),
      ],
    );
  }
}
