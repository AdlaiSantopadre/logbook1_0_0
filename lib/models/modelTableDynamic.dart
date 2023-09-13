import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const appTitle = 'Tabella Modello';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: appTitle,
      home: PageVeicolo(title: appTitle),
    );
  }
}

GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();

class PageVeicolo extends StatefulWidget {
  const PageVeicolo({super.key, required String title});

  @override
  State<PageVeicolo> createState() => _PageVeicoloState();
}

class _PageVeicoloState extends State<PageVeicolo> {
//Registro Annotazioni e Percorrenze Veicolo

  TextEditingController fileMese = TextEditingController();
  TextEditingController targa = TextEditingController();
  late Directory
      appDocumentsDirectory; // Directory where the file will be saved, declared as late
  List<List<TextEditingController>> controllers = [];
  FocusNode nextFocus = FocusNode();
  FocusNode meseFocusNode = FocusNode();
  bool canAddRow = false;
  DateTime selectedInitDate = DateTime.now();
  TimeOfDay selectedInitTime = TimeOfDay.now();
  DateTime selectedEndDate = DateTime.now();
  TimeOfDay selectedEndTime = TimeOfDay.now();
  List<String> validMonthNames = [
    'Gennaio',
    'Febbraio',
    'Marzo',
    'Aprile',
    'Maggio',
    'Giugno',
    'Luglio',
    'Agosto',
    'Settembre',
    'Ottobre',
    'Novembre',
    'Dicembre',
  ];
  @override
  void initState() {
    super.initState();
    initializeAppDocumentsDirectory();
    addNewRow(); // Add an initial row
  }

  Future<void> initializeAppDocumentsDirectory() async {
    appDocumentsDirectory = await getApplicationDocumentsDirectory();
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

  void saveDataToFile(String fileName) async {
    // Serialize your data (e.g., as JSON)
    List<List<String>> dataToSave = controllers
        .map((row) => row.map((controller) => controller.text).toList())
        .toList();
    String dataJson = jsonEncode(dataToSave);

    // Create and write to the file
    final file = File('${appDocumentsDirectory.path}/$fileName');
    await file.writeAsString(dataJson);

    // Show a confirmation message or perform other actions
    debugPrint('${appDocumentsDirectory.path}/$fileName');
    //canAddRow = true;
  }

  Future<void> loadDataFromFile(String fileName) async {
    try {
      final file = File('${appDocumentsDirectory.path}/$fileName');
      String fileContents = await file.readAsString();
      List<dynamic> decodedData = jsonDecode(fileContents);

      // Populate controllers with loaded data
      for (int i = 0; i < controllers.length && i < decodedData.length; i++) {
        for (int j = 0;
            j < controllers[i].length && j < decodedData[i].length;
            j++) {
          controllers[i][j].text = decodedData[i][j];
        }
        canAddRow = true;
        addNewRow();
      }
    } catch (e) {
      // Handle file loading errors
      print('Error loading data from file: $e');
    }
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
      debugPrint('$canAddRow');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = ScreenSizeService(context).width;
    final screenHeight = ScreenSizeService(context).height;
    return Scaffold(
        //resizeToAvoidBottomInset: false,
//APPBARAPPBAR//
        appBar: AppBar(
          title: Text("Rapporto Percorrenze"),
          actions: [
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                String fileName = fileMese.text;
                if (fileName.isNotEmpty) {
                  saveDataToFile(fileName);
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                String fileName = fileMese.text;
                if (fileName.isNotEmpty) {
                  loadDataFromFile(fileName);
                }
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: screenWidth,
              minHeight: screenHeight,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(children: [
//intestazioni//
                Row(children: [
                  Text("AUTOSTRADE// per l'Italia"),
                  Text("Direzione VII Tronco"),
                ]),
                Row(children: [
                  SizedBox(
                    height: 80,
                    width: 400,
                    child: AutoCompleteTextField<String>(
                        key: key,
                        suggestions: validMonthNames,
                        decoration: InputDecoration(
                          labelText:
                              'Al mese scelto sono associati i dati salvati ',
                        ),
                        itemBuilder: (context, suggestion) => ListTile(
                              title: Text(suggestion),
                            ),
                        itemSorter: (a, b) => a.compareTo(b),
                        itemFilter: (suggestion, input) => suggestion
                            .toLowerCase()
                            .startsWith(input.toLowerCase()),
                        autofocus: true,
                        focusNode: meseFocusNode,
                        controller: fileMese,
                        clearOnSubmit: false,
                        textSubmitted: (data) {
                          fileMese.text = '';// Request focus to keep the cursor in the TextField
                          FocusScope.of(context).requestFocus(meseFocusNode);
                        },
                        // textInputAction: TextInputAction.done,
                        itemSubmitted: (value) {
                          // Clear the TextField
                          fileMese.text = value;
                           
                          

                          // Print an error message
                        } /* else {fileMese.clear();FocusScope.of(context).requestFocus(FocusNode());
                           }*/

                        ),
                  ),
                  // Handle the selected month name here

                  /*  
                       textSubmitted: (input) {
                          if (!validMonthNames.contains(input)) {
                            //fileMese.clear();
                           
                            debugPrint('Building $runtimeType');
                          }
                        },*/

                  // autofocus: true,

                  /*
                    child: TextField(
                      
                     // expands: true,
                     // maxLines: null,         
                      style: TextStyle(fontSize: 14),
                      controller: fileMese,
                      //focusNode: nextFocus,
                      decoration: InputDecoration(
                        labelText: 'Al mese scelto sono associati i dati salvati ',
                        //hintText: 'Mese',
                        prefixText: "Mese di ",
                      ),
                    ),*/

//Intestazioni
                  SizedBox(
                    height: 80,
                    width: 200,
                    child: TextField(
                      style: TextStyle(fontSize: 14),
                      controller: targa,
                      //focusNode: nextFocus,
                      decoration: InputDecoration(
                        hintText: 'Targa',
                        labelText: 'Targa',
                      ),
                    ),
                  ),
                ]),

                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromARGB(255, 23, 110, 182),
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    children: [
                      SizedBox(width: 150, child: Text('DataOra')),
                      SizedBox(width: 100, child: Text('Km iniziali')),
                      SizedBox(width: 150, child: Text('DataOra')),
                      SizedBox(width: 50, child: Text('Km finali')),
                      SizedBox(width: 150, child: Text('Note')),
                      SizedBox(width: 50, child: Text('Autista')),
                    ],
                  ),
                ),
                //Expanded(child:

                /*    child:*/ Column(
                  children: List.generate(controllers.length, (index) {
                    return /*SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        Expanded(
                      child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                      children: List.generate(controllers.length, (index) {
                      return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                              
                        child:*/
                        Container(
                      padding: EdgeInsets.all(1.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blue,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(3)),
                      child: Row(
                        textBaseline: TextBaseline.alphabetic,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //DATA DI INIZIO DATA DI INIZIO
                          SizedBox(
                            width: 150,
                            height: 80,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                              ),
                              child: TextField(
                                expands: true,
                                maxLines: null,

                                style: TextStyle(fontSize: 14),
                                controller: controllers[index][0],
                                readOnly: true, // Prevent manual editing
                                decoration: InputDecoration(
                                    labelText: 'Partenza',
                                    icon: Icon(Icons.calendar_today)),
                                //textAlignVertical: TextAlignVertical.top,
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
                                            DateFormat('yyyy-MM-dd HH:mm')
                                                .format(selectedInitDate);
                                        controllers[index][0].text =
                                            formattedDate;
                                      });
                                    }
                                  }
                                },
                                onChanged: (value) {
                                  updateCanAddRow();
                                },
                                onEditingComplete: () {
                                  FocusScope.of(context)
                                      .requestFocus(nextFocus);
                                },
                              ),
                            ),
                          ),
                          //DATA DI INIZIO DATA DI INIZIO
                          //KM INIZIALI KM INIZIALI
                          SizedBox(
                            width: 120,
                            height: 80,
                            child: Container(
                              decoration: BoxDecoration(
                                //shape: BoxShape.circle,

                                border: Border.all(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                              ),
                              child: TextField(
                                style: TextStyle(fontSize: 14),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(7)
                                ],
                                maxLength: 7,
                                textAlign: TextAlign.center,
                                textAlignVertical: TextAlignVertical.top,

                                controller: controllers[index][1],
                                //focusNode: nextFocus,
                                decoration:
                                    InputDecoration(labelText: 'Km iniziali'),
                                onChanged: (value) {
                                  updateCanAddRow();
                                },
                                onEditingComplete: () {
                                  FocusScope.of(context)
                                      .requestFocus(nextFocus);
                                },
                              ),
                            ),
                          ),
                          //KM INIZIALI KM INIZIALI
                          //DATA DI RITORNO DATA DI RITORNO
                          SizedBox(
                            width: 150,
                            height: 80,
                            child: TextField(
                              style: TextStyle(fontSize: 14),
                              controller: controllers[index][2],
                              //focusNode: nextFocus,
                              decoration:
                                  InputDecoration(hintText: 'Enter data'),
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
                                      controllers[index][2].text =
                                          formattedDate;
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
                          //DATA DI RITORNO DATA DI RITORNO
                          //KM FINALI KM FINALI
                          SizedBox(
                            width: 50,
                            height: 80,
                            child: TextField(
                              style: TextStyle(fontSize: 14),
                              controller: controllers[index][3],
                              //focusNode: nextFocus,
                              decoration:
                                  InputDecoration(hintText: 'KM rientro'),
                              onChanged: (value) {
                                updateCanAddRow();
                              },
                              onEditingComplete: () {
                                FocusScope.of(context).requestFocus(nextFocus);
                              },
                            ),
                          ),
                          //KM FINALI KM FINALI
                          //NOTENOTENOTE
                          SizedBox(
                            width: 150,
                            height: 50,
                            child: TextField(
                              style: TextStyle(fontSize: 13),
                              maxLines: 2, //2 scrollabale linesrr
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
                          ),
                          //NOTENOTENOTE
                          //FIRMAFIRMA
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: TextField(
                              controller: controllers[index][5],
                              //focusNode: nextFocus,
                              decoration:
                                  InputDecoration(hintText: 'Enter data'),

                              onChanged: (value) {
                                updateCanAddRow();
                              },
                              onEditingComplete: () {
                                addRow();

                                controllers[index + 1][1] =
                                    controllers[index][3];
                                //quando aggiunge una riga pone inizializza km

                                debugPrint('Building $runtimeType');
                                FocusScope.of(context).requestFocus(nextFocus);
                              },
                            ),
                          ),
                          //FIRMAFIRMA
                        ],
                      ),
                    );
                  }),
                ),
                //  ),
              ]),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            addRow();
          },
          child: Icon(Icons.add),
          backgroundColor: canAddRow ? Colors.blue : Colors.grey,

          // Disable the button when the last row is not fully filled
          // with data in all columns),
        ));
  }
}

class ScreenSizeService {
  final BuildContext context;

  const ScreenSizeService(
    this.context,
  );

  Size get size => MediaQuery.of(context).size;
  double get height => size.height;
  double get width => size.width;
}
