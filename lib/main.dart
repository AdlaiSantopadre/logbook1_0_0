import 'package:flutter/material.dart'; //per utilizzare il Material design
//import 'package:intl/intl.dart'; //per utilizare DateTime
import 'package:hooks_riverpod/hooks_riverpod.dart';
//import 'package:flutter_hooks/flutter_hooks.dart';

import  'package:logbook1_0_0/pages/homePage.dart';
//import 'package:logbook1_0_0/pages/pageEquipaggiamento.dart';
//import 'package:logbook1_0_0/pages/pagePrimoSoccorso.dart';
//import 'package:logbook1_0_0/pages/pageVeicolo.dart';
//import 'package:logbook1_0_0/pages/pageDPI.dart';
//import 'package:logbook1_0_0/models/progressIndicator.dart';



//All Flutter applications using Riverpod must contain a [ProviderScope] at the root of their widget tree
/*void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}*/
void main() =>
    runApp( const ProviderScope(child:LogbookApp()));
//**MyApp is  LogbookApp**//
class LogbookApp extends StatelessWidget {
  const LogbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       
     /* it provides a default banner, background color, and has API for adding drawers, snack bars, and bottom sheets. 
    Then you can add the Center widget directly to the body property for the home page.*/
        title: 'Logbook HomePage',
        debugShowCheckedModeBanner: true, //mostra il banner debug mode
        theme: ThemeData(
          useMaterial3: true,
          //primarySwatch: Colors.blue,
           // primarySwatch: Colors.cyan,
          canvasColor: Colors.cyan[50],
          colorScheme: ColorScheme(brightness:Brightness.light, primary:Colors.blue.shade600, onPrimary:Colors.blue, secondary: Colors.cyan.shade100, onSecondary: Colors.cyan.shade200, error: Colors.red.shade100, onError: Colors.red.shade300, background: Colors.cyan.shade50, onBackground: Colors.blueGrey.shade100, surface: Colors.blue.shade100, onSurface: Colors.blue.shade900)
          //colorSchemeSeed: Colors.blue[600],
          ),
        home: HomePage()); // widget for the default route of the app
  }
}

