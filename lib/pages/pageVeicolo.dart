
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PageVeicolo extends StatefulWidget {
  const PageVeicolo({super.key});

  @override
  State<PageVeicolo> createState() => _PageVeicoloState();
}

class _PageVeicoloState extends State<PageVeicolo> {
//Registro Annotazioni e Percorrenze Veicolo

  
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
    addNewRow( );
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
      appBar: AppBar(title: Text('Table Example')),
      body: Column(
        children: [
          const Row(
            children: [
              Expanded(child: Text('DataOra')),
              Expanded(child: Text('Km iniziali')),
              Expanded(child: Text('DataOra')),
              Expanded(child: Text('Km finali')),
              Expanded(child: Text('Note')),
              Expanded(child: Text('Autista')),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: controllers.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                      children: [
              Expanded(
                      child: TextField(
                        
                        style:TextStyle(fontSize:10 ),
                        controller: controllers[index][0],
                        decoration: InputDecoration(hintText: 'DataOra'),
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
                      String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(selectedInitDate);
                      controllers[index][0].text = formattedDate;
                    });
                  }
                }
                },
                          onChanged: (value) {
                            updateCanAddRow();},
                          onEditingComplete: () {
                          FocusScope.of(context).requestFocus(nextFocus);
                        },                     
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: controllers[index][1],
                        //focusNode: nextFocus,
                        decoration: InputDecoration(hintText: 'Enter data'),
                        onChanged: (value) {
                          updateCanAddRow();},
                        onEditingComplete: () {
                         FocusScope.of(context).requestFocus(nextFocus);
                        },
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        style:TextStyle(fontSize:10 ),
                        controller: controllers[index][2],
                        //focusNode: nextFocus,
                        decoration: InputDecoration(hintText: 'Enter data'),
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
                      String formattedDate = DateFormat('DD-MM-yy HH:mm').format(selectedEndDate);
                      controllers[index][2].text = formattedDate;
                    });
                  }
                }
              }, onChanged: (value) {
                          updateCanAddRow();},
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(nextFocus);
                        },
                        
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        //style:TextStyle(fontSize:10 ),
                        controller: controllers[index][3],
                        //focusNode: nextFocus,
                        decoration: InputDecoration(hintText: 'Enter data'),
                        onChanged: (value) {
                          updateCanAddRow();},
                        onEditingComplete: () {
                         FocusScope.of(context).requestFocus(nextFocus);
                        },
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        style:TextStyle(fontSize:10 ),
                        maxLines: 2,//2 scrollabale linesrr
                        controller: controllers[index][4],
                        //focusNode: nextFocus,
                        decoration: InputDecoration(hintText: '...'),
                        onChanged: (value) {
                          updateCanAddRow();},
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(nextFocus);
                        },
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: controllers[index][5],
                        //focusNode: nextFocus,
                        decoration: InputDecoration(hintText: 'Enter data'),
                        
                        onChanged: (value) {
                          updateCanAddRow();},
                        onEditingComplete: () {
                        addRow();
                         //FocusScope.of(context).requestFocus(nextFocus);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addRow();
          
        },
        child: Icon(Icons.add),
        backgroundColor: canAddRow ? Colors.blue : Colors.grey,

        // Disable the button when the last row is not fully filled
        // with data in all columns),
      ),
    );
  }
}