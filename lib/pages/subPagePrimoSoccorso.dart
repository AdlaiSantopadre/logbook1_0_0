
import 'package:flutter/material.dart';

class subPagePrimoSoccorso extends StatelessWidget {
  const subPagePrimoSoccorso({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informazioni dotazioni Primo Soccorso'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined),
            onPressed: () {
                Navigator.pop(context);
              }  
          ),
       /*   IconButton(
            tooltip: "disposizioni di riferimento",
            icon: const Icon(Icons.info),
            onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const subPagePrimoSoccorso()),
                                );
            },
          ),*/
               ],
        
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate back to first route when tapped.
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}