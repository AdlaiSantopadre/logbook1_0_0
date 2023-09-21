import 'package:flutter/material.dart';
import '../widgets/screenSizeService.dart'; 

class subPageVeicolo extends StatelessWidget {
const subPageVeicolo({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = ScreenSizeService(context).width;
    final screenHeight = ScreenSizeService(context).height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          style:TextStyle(fontSize: 18),
          'Rapporto Percorrenze',
          maxLines: 1,
        ),
        /*actions: [
          IconButton(
              icon: const Icon(Icons.home_outlined),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],*/
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: screenWidth,
            minHeight: screenHeight,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(12)),
                   
                     child:RichText(
                            text: TextSpan(
                                  children: 'Il Rapporto Percorrenze va compilato in ogni sua voce avendo cura di selezionare il mese di riferimento che è la chiave di accesso per consultare anche le righe già compilate. Ad ogni utilizzo distinto compilare in particolare una riga con i dati di partenza e di rientro, aggiungendo eventuali note riguardanti lo stato di della carrozzeria, luci e fanaleria, spie del cruscotto accese o messaggi dalla centralina, ed eventuali anomalie nei livelli dei liquidi di consumo quali olio motore, liquido dei freni etc. Controllare anche pneumatici e usura del battistrada. '.split('.').map((textSegment) {
                                  return TextSpan(
                                  style:const TextStyle(color:Colors.cyan,fontSize:20),
                                  text: textSegment + '.', // Re-add the dot that was removed by split
        
                                  );
                                  }).toList(),
  ),
)
 ),

                Center(
                  child: Image.asset(
                    fit:BoxFit.fitWidth,
                    'lib/assets/RapportoPercorrenze.png',
                    
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


 