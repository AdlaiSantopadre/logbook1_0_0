import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logbook1_0_0/pages/subPageVeicolo.dart';
import 'package:logbook1_0_0/providers.dart';
import 'package:logbook1_0_0/widgets/screenSizeService.dart';
import 'dart:io'; //for non web applications only!!!
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';

//devo modificare la logica affinchè dopo aver scelto
// il mese  carico la tabella e aggiungo una riga vuota .
//Poi con il riempimento della riga salvo la tabella con il floating action, esco dalla pagina
// invrementando il valore di progressIndicator con DONE

GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();
//Registro Annotazioni e Percorrenze Veicolo

// ignore: must_be_immutable
class PageVeicolo extends ConsumerWidget {
  PageVeicolo({super.key, required String title});
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
  bool isNewRowFilled = false;
  bool shouldIncreaseTotal = false;
  bool isTotalProgressIncreased = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> initializeAppDocumentsDirectory() async {
      appDocumentsDirectory = await getApplicationDocumentsDirectory();
    }

    initializeAppDocumentsDirectory();

    void updateCanAddRow() {
      canAddRow = controllers.isNotEmpty &&
          controllers.last.every((controller) => controller.text.isNotEmpty);
    }

    void addNewRow() {
      controllers.add([
        TextEditingController(),
        TextEditingController(),
        TextEditingController(),
        TextEditingController(),
        TextEditingController(),
        TextEditingController(),
      ]);
      updateCanAddRow();
    }

    addNewRow();
    updateCanAddRow();

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
      shouldIncreaseTotal = false;
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
            shouldIncreaseTotal = true;
            addNewRow();
          }
          for (int j = 0; j < decodedData[i].length; j++) {
            controllers[i][j].text = decodedData[i][j];
          }
        }

        updateCanAddRow();
        if (shouldIncreaseTotal) {}
      } catch (e) {
        // Handle file loading errors
        print('Error loading data from file: $e');
      }
    }

    /*@override
  void dispose() {
    for (var controllerList in controllers) {
      for (var controller in controllerList) {
        controller.dispose();
      }
    }
    super.dispose();
  }*/

    void addRow() {
      if (canAddRow) {
        addNewRow();
        isNewRowFilled = true;
      }
      debugPrint('$canAddRow');
    }

    void handleOnEditingComplete() {
      if ((isNewRowFilled || shouldIncreaseTotal) &&
          !isTotalProgressIncreased) {
        ref.watch(totalProgressProvider.notifier).state += 30;
        isNewRowFilled = false;
        shouldIncreaseTotal = false;
        isTotalProgressIncreased = true;
      }
    }

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
          IconButton(
            tooltip: "disposizioni di riferimento",
            icon: const Icon(Icons.info),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const subPageVeicolo()),
              );
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
                Text("=>>         AUTOSTRADE// per l'Italia       =>>"),
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
                        //DATA DI INIZIO DATA DI INIZIO
                        //KM INIZIALI KM INIZIALI
                        SizedBox(
                          width: 75,
                          height: 80,
                          child: TextField(
                            style: const TextStyle(fontSize: 14),
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
                                const InputDecoration(labelText: 'Km iniziali'),
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
                                  controllers[index][2].text = formattedDate;
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
                            decoration: const InputDecoration(hintText: '...'),
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
                            textAlignVertical: TextAlignVertical.top,
                            //focusNode: nextFocus,
                            decoration: const InputDecoration(
                              hintText: 'Autista',
                            ),

                            onChanged: (value) {
                              updateCanAddRow();
                            },
                            /** */ onEditingComplete: () {
                              handleOnEditingComplete();
                              //updateCanAddRow();
                              addNewRow();

                              controllers[index + 1][1] = controllers[index][3];
                              //quando aggiunge una riga pone inizializza km nella successiva

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
          if ((isNewRowFilled || shouldIncreaseTotal) &&
              !isTotalProgressIncreased) {
            ref.watch(totalProgressProvider.notifier).state += 30;
            isNewRowFilled = false;
            shouldIncreaseTotal = false;
            isTotalProgressIncreased = true;
          }
        },
        backgroundColor: isTotalProgressIncreased
            ? Colors.blue.shade100
            : Colors.grey.shade300,
        child: const Icon(Icons.add),

        // Disable the button when the last row is not fully filled
        // with data in all columns),
      ),
    );
  }
}
