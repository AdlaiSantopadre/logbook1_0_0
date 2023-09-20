import 'package:flutter/material.dart';
//serve x ScreenSizeService
import 'package:logbook1_0_0/models/modelTableDynamic.dart'; 

class subPagePrimoSoccorso extends StatelessWidget {
  const subPagePrimoSoccorso({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = ScreenSizeService(context).width;
    final screenHeight = ScreenSizeService(context).height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          style:TextStyle(fontSize: 18),
          'Pacchetto Medicazione',
          maxLines: 1,
        ),
        actions: [
          /*IconButton(
              icon: const Icon(Icons.home_outlined),
              onPressed: () {
                Navigator.pop(context);
              }),*/
        ],
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
                   /*Text(
                      'Il pacchetto di medicazione deve essere conforme al dm 388 allegato 2.Ispezionare il materiale periodicamente, sostituire materiale mancante o scaduto o deteriorato ',
                      maxLines: 10,
                    )** */ child:RichText(
                            text: TextSpan(
                                  children: 'Il pacchetto di medicazione deve essere conforme al dm 388 allegato 2.Ispezionare il materiale periodicamente, sostituire materiale mancante o scaduto o deteriorato '.split('.').map((textSegment) {
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
                    'lib/assets/Scheda_Ispezione_Periodica_Pacchetto_Di_Medicazione.PNG',
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
