import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen();

  @override
  Widget build(BuildContext context) {
    //TODO: You were supposed to remove this scaffolds.
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          CircularProgressIndicator(),
          SizedBox(
            height: 20,
          ),
          const Text('Loading data...'),
        ]),
      ),
    );
  }
}
