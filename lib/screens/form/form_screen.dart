import 'package:api_and_json_server/core/service_locator.dart';
import 'package:api_and_json_server/screens/form/widgets/form_view.dart';
import 'package:api_and_json_server/services/api_service/api_interface.dart';
import 'package:api_and_json_server/services/database_service/database_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:api_and_json_server/screens/form/bloc/form_bloc.dart';

class FormScreen extends StatelessWidget {
  final apiService = locator.get<ApiInterface>();
  final databaseService = locator.get<DatabaseInterface>();
  final int id;
  final String name;

  FormScreen({this.id, this.name});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FormBloc>(
      lazy: true,
      create: (context) =>
          FormBloc(apiService: apiService, databaseService: databaseService),
      child: FormView(id: id, name: name),
    );
  }
}
