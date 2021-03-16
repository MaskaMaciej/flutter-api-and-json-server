import 'package:api_and_json_server/screens/form/widgets/form_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:api_and_json_server/screens/form/bloc/form_bloc.dart';

class FormScreen extends StatelessWidget {
  final int id;
  final String name;

  FormScreen({this.id, this.name});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FormBloc>(
      create: (context) => FormBloc(),
      child: FormView(id: id, name: name),
    );
  }
}
