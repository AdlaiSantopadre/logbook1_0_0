import 'package:flutter/material.dart';
import 'package:logbook1_0_0/validateYourself.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Login',
        debugShowCheckedModeBanner: true,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: ValidateYourself());
  }
}
