
import 'package:flutter/material.dart';

class subPagePrimoSoccorso extends StatelessWidget {
  const subPagePrimoSoccorso({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Info Pacchetto Medicazione',maxLines: 2,),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined),
            onPressed: () {
                Navigator.pop(context);
              }  
          ),   
               ],
        
      ),
      body:
         Padding(
           padding: const EdgeInsets.fromLTRB(16.0,4.0,16.0,4.0),
           child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment:CrossAxisAlignment.center,
         
            children: [Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(12)),
                      child: Text('Il pacchetto di medicazione deve essere conforme al dm 388 allegato 2.Ispezionare il materiale periodicamente, sostituire materiale mancante o scaduto o deteriorato ',maxLines: 10, )),
              Center(
                child: Image.asset('lib/assets/Scheda_Ispezione_Periodica_Pacchetto_Di_Medicazione.PNG',
                ),
              ),
            ],
                 ),
         ),
      
    );
  }
}