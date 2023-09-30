import 'package:flutter/material.dart'; //per utilizzare il Material design
//import 'package:intl/intl.dart'; //per utilizare DateTime
import 'package:hooks_riverpod/hooks_riverpod.dart';
import  'package:logbook1_0_0/pages/homePage.dart';

/*void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}*/
void main() =>
    runApp( const ProviderScope(child:LogbookApp()));
//All Flutter applications using Riverpod must contain a [ProviderScope] at the root of their widget tree
class LogbookApp extends StatelessWidget {//MyApp is  LogbookApp!!!
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
          canvasColor: Colors.cyan[600],
          colorScheme: ColorScheme(brightness:Brightness.light,
            primary:Colors.blue.shade600, onPrimary:Colors.blue.shade400,
            secondary: Colors.cyan.shade400, onSecondary: Colors.cyan.shade200,
            error: Colors.red.shade300, onError: Colors.red.shade200,
            background: Colors.blueGrey.shade50, onBackground: Colors.blueGrey.shade300,
            surface: Colors.cyan.shade200, onSurface: Colors.blue.shade900),
          
            textTheme: TextTheme(bodyMedium:TextStyle (color: Colors.blue.shade900), // Adjust this color as needed
            ),
            // Other theme properties
          ),
     //home: PageVeicolo(title: '',));
        home: HomePage()); // widget for the default route of the app
  }
}

