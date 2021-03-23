import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../screens/home/bloc/home_bloc.dart';
import '../../screens/home/widgets/home_view.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) => HomeBloc()..add(HomeFetchDataEvent()),
      child: HomeView(),
    );
  }
}
