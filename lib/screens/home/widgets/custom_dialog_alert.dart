import 'package:api_and_json_server/screens/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomDialogAlert extends StatelessWidget {
  final int userId;

  const CustomDialogAlert({@required this.userId});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Are you sure you want to delete this user?'),
      actions: [
        ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            ),
            child: Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
            ),
            child: Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop();
              BlocProvider.of<HomeBloc>(context).add(HomeDeleteUserEvent(id: userId));
            }),
      ],
    );
  }
}
