import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PageVeicolo extends StatefulWidget {
  const PageVeicolo({super.key});

  @override
  State<PageVeicolo> createState() => _PageVeicoloState();
}

class _PageVeicoloState extends State<PageVeicolo> {
//Registro Annotazioni e Percorrenze Veicolo

  TextEditingController mese = TextEditingController();
  List<List<TextEditingController>> controllers = [];
  FocusNode nextFocus = FocusNode();
  bool canAddRow = false;
  DateTime selectedInitDate = DateTime.now();
  TimeOfDay selectedInitTime = TimeOfDay.now();
  DateTime selectedEndDate = DateTime.now();
  TimeOfDay selectedEndTime = TimeOfDay.now();
  @override
  void initState() {
    super.initState();
    addNewRow();
  }

  void addNewRow() {
    setState(() {
      controllers.add([
        TextEditingController(),
        TextEditingController(),
        TextEditingController(),
        TextEditingController(),
        TextEditingController(),
        TextEditingController(),
      ]);
      updateCanAddRow();
    });
  }

  @override
  void dispose() {
    for (var controllerList in controllers) {
      for (var controller in controllerList) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  void updateCanAddRow() {
    canAddRow = controllers.isNotEmpty &&
        controllers.last.every((controller) => controller.text.isNotEmpty);
  }

  void addRow() {
    if (canAddRow) {
      setState(() {
        addNewRow();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Rapporto Percorrenze")),
      body: SingleChildScrollView(
        scrollDirection:Axis.horizontal,
        child: Column(
          children: [
            Row(children: [
              Text("AUTOSTRADE// per l'Italia"),
              Text("Direzione VII Tronco"),
            ]),
            Row(children: [
              Expanded(
                child: TextField(
                  style: TextStyle(fontSize: 10),
                  controller: mese,
                  //focusNode: nextFocus,
                  decoration: InputDecoration(
                    hintText: 'MESE',
                    prefixText: "Mese di ",
                  ),
                ),
              )
            ]),
           
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              /*child:  Column(children: [
                
                  //riga intestazioni
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(12)),
                    */child: Row(
                      children: [
                        SizedBox(width: 150, child: Text('DataOra')),
                        SizedBox(width: 50, child: Text('Km iniziali')),
                        SizedBox(width: 150, child: Text('DataOra')),
                        SizedBox(width: 50, child: Text('Km finali')),
                        SizedBox(width: 150, child: Text('Note')),
                        SizedBox(width: 50, child: Text('Autista')),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width, // Set a fixed width
                    // Nested SingleChildScrollView
                    child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                             child:/* Container(
                    
                                   
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height -200,
                        minWidth: MediaQuery.of(context).size.width,),
                        //da aggiustare maxHeights
                      
                      child:*/ ListView.builder(
                        itemCount: controllers.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context,int index)  {
                                                
                           return  Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.blue,
                                   width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(12)),
                                  child: Row(
                                  //mainAxisSize: MainAxisSize.min,
                                  children: [
                                SizedBox(width: 150,
                                child: TextField(
                                  style: TextStyle(fontSize: 14),
                                  controller: controllers[index][0],
                                  decoration: InputDecoration(hintText: 'Data/Ora di uscita'),
                                  onTap: () async {
                                    // Show date picker
                                    final pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: selectedInitDate,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2101),
                                    );
                                                    
                                    if (pickedDate != null) {
                                      // Show time picker
                                      final pickedTime = await showTimePicker(
                                        context: context,
                                        initialTime: selectedInitTime,
                                      );
                                                    
                                      if (pickedTime != null) {
                                        setState(() {
                                          selectedInitDate = DateTime(
                                            pickedDate.year,
                                            pickedDate.month,
                                            pickedDate.day,
                                            pickedTime.hour,
                                            pickedTime.minute,
                                          );
                                          //controllers[index][0].text = selectedDate.toString();
                                          String formattedDate =
                                              DateFormat('dd-MM-yyyy HH:mm')
                                                  .format(selectedInitDate);
                                          controllers[index][0].text = formattedDate;
                                        });
                                      }
                                    }
                                  },
                                  onChanged: (value) {
                                    updateCanAddRow();
                                  },
                                  onEditingComplete: () {
                                    FocusScope.of(context).requestFocus(nextFocus);
                                  },
                                ),
                                                    ),
                                                    //KM Iniziali - deve essere un numero intero
                                SizedBox(width: 50,
                                child: TextField(
                                  controller: controllers[index][1],
                                  //focusNode: nextFocus,
                                  decoration: InputDecoration(hintText: ' Km  '),
                                  onChanged: (value) {
                                    updateCanAddRow();
                                  },
                                  onEditingComplete: () {
                                    FocusScope.of(context).requestFocus(nextFocus);
                                  },
                                ),
                                                    ),
                                SizedBox(width: 150,
                                child: TextField(
                                  style: TextStyle(fontSize: 14),
                                  controller: controllers[index][2],
                                  //focusNode: nextFocus,
                                  decoration: InputDecoration(hintText: 'Ora di rientro'),
                                  onTap: () async {
                                    // Show date picker
                                    final pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: selectedEndDate,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2101),
                                    );
                              
                                    if (pickedDate != null) {
                                      // Show time picker
                                      final pickedTime = await showTimePicker(
                                        context: context,
                                        initialTime: selectedEndTime,
                                      );
                              
                                      if (pickedTime != null) {
                                        setState(() {
                                          selectedEndDate = DateTime(
                                            pickedDate.year,
                                            pickedDate.month,
                                            pickedDate.day,
                                            pickedTime.hour,
                                            pickedTime.minute,
                                          );
                                          //controllers[index][0].text = selectedDate.toString();
                                          String formattedDate =
                                              DateFormat('DD-MM-yy HH:mm')
                                                  .format(selectedEndDate);
                                          controllers[index][2].text = formattedDate;
                                        });
                                      }
                                    }
                                  },
                                  onChanged: (value) {
                                    updateCanAddRow();
                                  },
                                  onEditingComplete: () {
                                    FocusScope.of(context).requestFocus(nextFocus);
                                  },
                                ),
                                                    ),
                                SizedBox(width: 50,
                                child: TextField(
                                  style: TextStyle(fontSize: 14),
                                  controller: controllers[index][3],
                                  //focusNode: nextFocus,
                                  decoration: InputDecoration(hintText: 'Rientro'),
                                  onChanged: (value) {
                                    updateCanAddRow();
                                  },
                                  onEditingComplete: () {
                                    FocusScope.of(context).requestFocus(nextFocus);
                                  },
                                ),
                                                    ),
                              
                                SingleChildScrollView(
                                //scrollDirection: Axis.vertical,
                                child:SizedBox(width: 150,          
                                child: TextField(
                                  
                                  style: TextStyle(fontSize: 14),
                                  maxLines: 1,//2 scrollabale linesrr
                                  controller: controllers[index][4],
                                  //focusNode: nextFocus,
                                  decoration: InputDecoration(hintText: '...'),
                                  onChanged: (value) {
                                    updateCanAddRow();
                                  },
                                  onEditingComplete: () {
                                    FocusScope.of(context).requestFocus(nextFocus);
                                  },
                                ),
                                ),),
                                SizedBox(width: 50,
                                child: TextField(
                                              
                                  controller: controllers[index][5],
                                  //focusNode: nextFocus,
                                  decoration: InputDecoration(hintText: 'Enter data'),
                              
                                 onChanged: (value) {
                                    updateCanAddRow();
                                  },
                                  onEditingComplete: () {
                                    addRow();
                                    FocusScope.of(context).requestFocus(nextFocus);
                                  },
                                ),
                               ),
                            ],
                          ),
                             /* ),*/
                           );                       
                     } ),
                                       ),
                              ),
                 ], ),
              ),
            
         
        
     //),
    

      floatingActionButton: FloatingActionButton(
          onPressed: () {
            addRow();
          },
          child: Icon(Icons.add),
          backgroundColor: canAddRow ? Colors.blue : Colors.grey,

          // Disable the button when the last row is not fully filled
          // with data in all columns),
        ),/**/
 );
  }
}
