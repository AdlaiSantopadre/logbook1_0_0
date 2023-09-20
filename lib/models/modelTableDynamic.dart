import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:logbook1_0_0/widgets/screenSizeService.dart';
import 'dart:io'; //for non web applications only!!!
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const appTitle = 'Tabella Modello';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        useMaterial3: true,
        //primarySwatch: Colors.blue,
        // primarySwatch: Colors.cyan,
        canvasColor: Colors.cyan[600],
        colorScheme: ColorScheme(
            brightness: Brightness.light,
            primary: Colors.blue.shade600,
            onPrimary: Colors.blue.shade200,
            secondary: Colors.cyan.shade100,
            onSecondary: Colors.cyan.shade200,
            error: Colors.red.shade300,
            onError: Colors.red.shade200,
            background: Colors.cyan.shade50,
            onBackground: Colors.blueGrey.shade100,
            surface: Colors.cyan.shade100,
            onSurface: Colors.blue.shade900),

        textTheme: TextTheme(
          bodyMedium: TextStyle(
              color: Colors.blue.shade900), // Adjust this color as needed
        ),
        // Other theme properties
      ),
      home: PageVeicolo(title: appTitle),
    );
  }
}

/**cancella tutto  sopra */
GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();

class PageVeicolo extends StatefulWidget {
  const PageVeicolo({super.key, required String title});

  @override
  State<PageVeicolo> createState() => _PageVeicoloState();
}

//Registro Annotazioni e Percorrenze Veicolo
class _PageVeicoloState extends State<PageVeicolo> {
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

      // Clear existing data before loading new data
      for (var controllerList in controllers) {
      for (var controller in controllerList) {
        controller.clear();
      }
    }
   controllers.clear(); // Clear the list of controllers
     // Populate controllers with loaded data
    for (int i = 0; i < decodedData.length; i++) {
      if (i >= controllers.length) {
        // If the number of rows in data exceeds the number of rows in controllers, add a new row
        canAddRow = true;
        addNewRow();
      }
      for (int j = 0; j < decodedData[i].length; j++) {
        controllers[i][j].text = decodedData[i][j];
      }
    }
        
      updateCanAddRow();  
     
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

//devo modificare la logica affinchè dopo aver scelto
// il mese  carico la tabella e aggiungo una riga vuota .
//Poi con il riempimento della riga salvo la tabella con il floating action, esco dalla pagina
// invrementando il valore di progressIndicator con DONE
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
        // <<-SCAFFOLD
        //resizeToAvoidBottomInset: false,
//APPBARAPPBAR////APPBARAPPBAR////APPBARAPPBAR//
        appBar: AppBar(
          title: const Text(
            "Rapporto Percorrenze",
            textScaleFactor: 1,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                String fileName = fileMese.text;
                if (fileName.isNotEmpty) {
                  saveDataToFile(fileName);
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                String fileName = fileMese.text;
                if (fileName.isNotEmpty) {
                  loadDataFromFile(fileName);
                }
              },
            ),
          ],
        ),
        //APPBARAPPBAR//

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
                const Row(children: [
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
                        decoration: const InputDecoration(
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
                          fileMese.text =
                              ''; // Request focus to keep the cursor in the TextField
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

//Intestazioni
                  SizedBox(
                    height: 80,
                    width: 200,
                    child: TextField(
                      //style: TextStyle(fontSize: 14),
                      controller: targa,
                      //focusNode: nextFocus,
                      decoration: const InputDecoration(
                        hintText: 'Targa',
                        labelText: 'Targa',
                      ),
                    ),
                  ),
                ]),

                Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue.shade900,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(5)),
                  child: const Row(
                    children: [
                      SizedBox(
                          width: 150,
                          child: Text(
                            '  DataOra',
                            textAlign: TextAlign.center,
                          )),
                      SizedBox(
                          width: 75,
                          child: Text(
                            'Km iniziali',
                            textAlign: TextAlign.center,
                          )),
                      SizedBox(
                          width: 150,
                          child: Text(
                            'DataOra',
                            textAlign: TextAlign.center,
                          )),
                      SizedBox(
                          width: 75,
                          child: Text(
                            'Km finali',
                            textAlign: TextAlign.center,
                          )),
                      SizedBox(
                          width: 150,
                          child: Text(
                            'Note',
                            textAlign: TextAlign.center,
                          )),
                      SizedBox(
                          width: 75,
                          child: Text(
                            'Autista',
                            textAlign: TextAlign.center,
                          )),
                    ],
                  ),
                ),
                //Expanded(child:

                /*    child:*/ Column(
                  children: List.generate(controllers.length, (index) {
                    return Container(
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blue.shade900,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        textBaseline: TextBaseline.alphabetic,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //DATA DI INIZIO DATA DI INIZIO
                          SizedBox(
                            width: 150,
                            height: 80,
                            child: Container(
                              child: TextField(
                                expands: true,
                                maxLines: null,

                                style: const TextStyle(fontSize: 12),
                                controller: controllers[index][0],
                                readOnly: true, // Prevent manual editing
                                decoration: const InputDecoration(
                                    labelText: 'Uscita',
                                    icon: Icon(Icons.calendar_today)),
                                //textAlignVertical: TextAlignVertical.top,
                                onTap: () async {
                                  // Show date picker
                                  final pickedDate = await showRoundedDatePicker(
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
                            width: 75,
                            height: 80,
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
                              decoration: const InputDecoration(
                                  labelText: 'Km iniziali'),
                              onChanged: (value) {
                                updateCanAddRow();
                              },
                              onEditingComplete: () {
                                FocusScope.of(context).requestFocus(nextFocus);
                              },
                            ),
                          ),
                          //KM INIZIALI KM INIZIALI
                          //DATA DI RITORNO DATA DI RITORNO
                          SizedBox(
                            width: 150,
                            height: 80,
                            child: TextField(
                              expands: true,
                              maxLines: null,

                              style: const TextStyle(fontSize: 12),
                              controller: controllers[index][2],
                              readOnly: true, // Prevent manual editing
                              decoration: const InputDecoration(
                                  labelText: 'Rientro',
                                  icon: Icon(Icons.calendar_today)),
                              //textAlignVertical: TextAlignVertical.top
                              onTap: () async {
                                // Show date picker
                                final pickedDate = await showRoundedDatePicker(
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
                                          DateFormat('dd-MM-yyyy HH:mm')
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
                            width: 75,
                            height: 80,
                            child: TextField(
                              //style: TextStyle(fontSize: 14),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(7)
                              ],
                              maxLength: 7,
                              textAlign: TextAlign.center,
                              textAlignVertical: TextAlignVertical.top,
                              controller: controllers[index][3],
                              //focusNode: nextFocus,
                              decoration:
                                  const InputDecoration(labelText: 'Km finali'),
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
                              textAlign: TextAlign.center,
                              //style: TextStyle(fontSize: 13),
                              maxLines: 2, //2 scrollabale linesrr
                              controller: controllers[index][4],
                              //focusNode: nextFocus,
                              decoration:
                                  const InputDecoration(hintText: '...'),
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
                            width: 75,
                            height: 50,
                            child: TextField(
                              textAlign: TextAlign.center,
                              controller: controllers[index][5],
                              //focusNode: nextFocus,
                              decoration:
                                  const InputDecoration(hintText: 'Autista'),

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
        //floatingActionButton//floatingActionButton
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            addRow();
          },
          backgroundColor: canAddRow ? Colors.blue : Colors.grey,
          child: const Icon(Icons.add),

          // Disable the button when the last row is not fully filled
          // with data in all columns),
        ));
  }
}
