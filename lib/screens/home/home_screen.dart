import 'package:api_and_json_server/core/service_locator.dart';
import 'package:api_and_json_server/screens/home/bloc/home_bloc.dart';
import 'package:api_and_json_server/screens/home/widgets/home_view.dart';
import 'package:api_and_json_server/services/api_service/api_interface.dart';
import 'package:api_and_json_server/services/database_service/database_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  final apiService = locator.get<ApiInterface>();
  final databaseService = locator.get<DatabaseInterface>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      //TODO: Do you know what lazy does? Remove it or tell me why this is required.
      lazy: false,
      create: (context) =>
          HomeBloc(apiService: apiService, databaseService: databaseService)
            ..add(HomeFetchDataEvent()),
      child: HomeView(),
    );
  }
}
