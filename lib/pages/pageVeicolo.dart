
import 'package:flutter/material.dart';

class PageVeicolo extends StatelessWidget {
  const PageVeicolo({super.key});

//Registro Annotazioni e Percorrenze Veicolo

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Annotazioni e Percorrenze Veicolo',
                          textAlign: TextAlign.right,),
        bottom: PreferredSize(preferredSize: Size(8.0,20.0),
                              child:Text( 'Rapporto percorrenze '),),  
          ),
      body: Center(
        child:Row(children: [
              Text("uscita"),
              Text("rientro")
            ]),
            
              
            ),
          
        );
  }
}