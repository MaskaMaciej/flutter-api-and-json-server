import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../screens/home/bloc/home_bloc.dart';

class CustomPopupMenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          child: ElevatedButton(
            child: const Text('Show all'),
            onPressed: () {
              BlocProvider.of<HomeBloc>(context)
                  .add(HomeRefreshDataEvent(filter: RefreshEnum.all));
            },
          ),
        ),
        PopupMenuItem(
          child: ElevatedButton(
            child: const Text('Show alphabetical'),
            onPressed: () {
              BlocProvider.of<HomeBloc>(context)
                  .add(HomeRefreshDataEvent(filter: RefreshEnum.alphabetical));
            },
          ),
        ),
        PopupMenuItem(
          child: ElevatedButton(
            child: const Text('Show favorites'),
            onPressed: () {
              BlocProvider.of<HomeBloc>(context)
                  .add(HomeRefreshDataEvent(filter: RefreshEnum.favorites));
            },
          ),
        ),
        PopupMenuItem(
          child: ElevatedButton(
            child: const Text('Show not favorites'),
            onPressed: () {
              BlocProvider.of<HomeBloc>(context)
                  .add(HomeRefreshDataEvent(filter: RefreshEnum.notFavorites));
            },
          ),
        ),
      ],
    );
  }
}
