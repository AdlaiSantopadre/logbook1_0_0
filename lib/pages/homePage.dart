import 'package:flutter/material.dart'; //per utilizzare il Material design
import 'package:intl/intl.dart'; //per utilizare DateTime
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart'; //https://medium.com/@CavinMac/mastering-hooks-in-flutter-dca896d97d47#id_token=eyJhbGciOiJSUzI1NiIsImtpZCI6IjdjMGI2OTEzZmUxMzgyMGEzMzMzOTlhY2U0MjZlNzA1MzVhOWEwYmYiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIyMTYyOTYwMzU4MzQtazFrNnFlMDYwczJ0cDJhMmphbTRsamRjbXMwMHN0dGcuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiIyMTYyOTYwMzU4MzQtazFrNnFlMDYwczJ0cDJhMmphbTRsamRjbXMwMHN0dGcuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMDA4NjEzNTM1ODEyNTQzNzQ5ODAiLCJlbWFpbCI6ImFkaWVnaXVsaUBnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwibmJmIjoxNjk0NTE2MTkzLCJuYW1lIjoiQWRsYWkgUyIsInBpY3R1cmUiOiJodHRwczovL2xoMy5nb29nbGV1c2VyY29udGVudC5jb20vYS9BQ2c4b2NKWlRZN3pRWXBscmJNMkVaTlFDaWNiTm4xLWhjZVdtdUVwR1NTUVV5d2syYURQPXM5Ni1jIiwiZ2l2ZW5fbmFtZSI6IkFkbGFpIiwiZmFtaWx5X25hbWUiOiJTIiwibG9jYWxlIjoiaXQiLCJpYXQiOjE2OTQ1MTY0OTMsImV4cCI6MTY5NDUyMDA5MywianRpIjoiMTRlYzljMjU1ZmNlM2UxYjgwMDMyMjAwNDkxZGM5YWYxNzhlOTM4YyJ9.T64Qpd3eqsBFwGjYGGE8aeMXb-De-2U5vcQ2TEDoe0BLLGvCrRkm57KiPZ4wgPJFJjBzjvrguDz0x6lBFmUmFdRSWcXkM2t81FPCEsc1IXbeUDwoO-TjVar1AdFDx2kLpeLNfLVjY-DqalHZM3EJD21GDyeqlq473i00HFoQTW1CTfS1C-FQ_NeMV_pgzkzj0sLBB52Evdl7iXPleuy2hfCrVeimn1BEiZsD_yhHosrUyOXZtTmQ_zi9X3nnNMT1i5QG2dRFI-Amthkj466g00vxK9PPnE-DFV45lyrDTzFCWrmpn0uW1QUTmPa4jO7odCwoRl6YPYV6oesjinvNSg
import 'package:logbook1_0_0/pages/pageDotazioniAntincendio.dart';
import 'package:logbook1_0_0/pages/pageEquipaggiamento.dart';
import 'package:logbook1_0_0/pages/pagePrimoSoccorso.dart';
import 'package:logbook1_0_0/pages/pageVeicolo.dart';
import 'package:logbook1_0_0/pages/pageDPI.dart';
import 'package:logbook1_0_0/widgets/progressIndicator.dart';
import 'package:logbook1_0_0/widgets/authentication.dart';
import 'package:logbook1_0_0/providers.dart';
import 'package:logbook1_0_0/widgets/screenSizeService.dart';
import  'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';


/*class HomePage extends StatefulWidget { 
  @override
  State <HomePage> createState() =>  HomePageState();
}*/
/*see reiverpod.dev
ConsumerWidget is identical in use to StatelessWidget, with the only difference 
being that it has an extra parameter on its build method: the "ref" object.*/
class HomePage extends HookConsumerWidget {
  HomePage({Key? key}) : super(key: key);

  //String? _username = '.....';
  // String? _password;
  DateTime fixDate = DateTime.now();
  FocusNode nextFocus = FocusNode();
  String formattedDate = DateFormat('dd-MM-yyyy ').format(DateTime.now());

// (show ListTile index number , name)  _widgetOptions[_selectedIndex],
  void _onItemTapped(int index, WidgetRef ref) {
    ref.read(selectedIndexProvider.notifier).state = index;
  }

//see reiverpod.dev
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('Building $runtimeType');

    final totalProgress = ref.watch(totalProgressProvider);

    final selectedIndex = ref
        .watch(selectedIndexProvider); // Riverpod provider for selected index
    final username =
        ref.watch(usernameProvider); // Riverpod provider for username
    final password = ref.watch(passwordProvider);

    final dateController =
        useTextEditingController(); // Use hooks for TextEditingController

    // final passwordVisibility = useState<bool>(false); // Use hooks for password visibility

    // final authentication = ref.watch(authenticationProvider);
      final screenWidth = ScreenSizeService(context).width;
      final screenHeight = ScreenSizeService(context).height;
      return Scaffold(
      ///DRAWER ///DRAWER //
      drawer: Drawer(
        backgroundColor: Colors.blue.shade50,
        // Add a ListView to the drawer...this ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.https://flutter.github.io/samples/add_a_drawer_to_a_screen.html
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.cyan[200],
              ),
              child: Center(
                  child: Image.asset(
                      'lib/assets/B1logo.png')), //Text('Compiti assegnati'),
            ),
            ListTile(
              title: const Text('Home'),
              selected: selectedIndex == 0,
              onTap: () {
                // Update the state of the app
                _onItemTapped(0, ref);
                // Then close the drawer
                MaterialPageRoute(
                    builder: (context) =>  HomePage( ));
                          
                       
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.drive_eta_rounded,
                color: Colors.blueGrey,
              ),
              title: const Text(
                'Rapporto Percorrenze',
                textAlign: TextAlign.center,
              ),
              selected: selectedIndex == 1,
              onTap: () {
                // Update the state
                _onItemTapped(1, ref);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PageVeicolo(
                            title: 'Rapporto Percorrenze',
                          )),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.car_crash,
                color: Colors.blueGrey,
              ),
              title: const Text(
                'Equipaggiamento',
                textAlign: TextAlign.center,
              ),
              selected: selectedIndex == 2,
              onTap: () {
                // Update the state
                _onItemTapped(2, ref);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PageEquipaggiamento()),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.health_and_safety_outlined,
                color: Colors.redAccent,
              ),
              title: const Text(
                'PrimoSoccorso',
                textAlign: TextAlign.center,
              ),
              selected: selectedIndex == 3,
              onTap: () {
                // Update the state
                _onItemTapped(3, ref);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PagePrimoSoccorso()),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.shield_sharp,
                color: Colors.green,
              ),
              title: const Text(
                'DPI',
                textAlign: TextAlign.center,
              ),
              selected: selectedIndex == 4,
              onTap: () {
                // Update the state of the app
                _onItemTapped(4, ref);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PageDPI()),
                );
              },
            ),
   /*    ListTile(
              title: const Text('Dotazioni Antincendio'),
              selected: selectedIndex == 5,
              onTap: () {
                // Update the state of the app
                _onItemTapped(5, ref);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PageDotazioniAntincendio()),
                );
              },
            ), * */   
          ],
        ),
      ),
//////////*DRAWER DRAWER*///////////////
////////////*APPBARAPPBAR*//////////////
      appBar: AppBar(
        backgroundColor: Colors.cyan[200],
        flexibleSpace: Image.asset('lib/assets/B1logo.png',
            alignment: Alignment.centerRight),
        titleSpacing: 0.0,
        title: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            "√ Diario di bordo",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontFamily: 'Roboto',
              letterSpacing: 0.5,
              //fontSize: 18,
            ),
          ),
        ),

        //////////*APPBARAPPBAR*//////////////
      ),

///////BODYBODY/////////BODYBODY//
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: screenWidth,
            minHeight: screenHeight,
          ),
          child:Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              verticalDirection: VerticalDirection.down,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(12)),
                  child: TextField(
                      //autofocus: true,
                      style: const TextStyle(fontSize: 15),
                      textAlign: TextAlign.center,
                      controller: dateController,
                      //[index][0],

                      decoration: InputDecoration(
                          //hintText: 'percorrenze di',
                          border: InputBorder.none,
                          suffixIcon: const Icon(
                              Icons.calendar_today), //spostare onTap sulla Icona
                          // Use of hooks to set the controller text
                          labelText: 'Data di oggi $formattedDate'),
                      onTap: () async {
                        // Show date picker
                        final pickedDate = await showRoundedDatePicker(
                          context: context,
                          initialDate: fixDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );

                        if (pickedDate != null) {
                          // Use hooks to update the controller text

                          fixDate = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            //pickedTime.hour,
                            //pickedTime.minute,
                          );
                          String formattedDate =
                              DateFormat('dd-MM-yyyy ').format(fixDate);
                          dateController.text = formattedDate;
                          //  FocusScope.of(context).requestFocus(
                          //      nextFocus); //mi permette di uscire senza avere lo scope e fcendo sparire la tastiera
                        }
                      }), //onTap
                ),

                //inserire qui il widget per il la autenticazione
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Authentication().openPopupWindow(context, ref);
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.manage_accounts),
                            Text('Autenticazione richiesta'),
                          ],
                        ), //,
                      ),
                      /*ElevatedButton(
                        onPressed: () {
                          _username = ref.watch(usernameProvider.notifier).state;
                        },
                        child: Text('Autenticazione richiesta'),
                      ),*/
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 4, color: Colors.blue),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Username: $username',
                                style: const TextStyle(fontSize: 14)),
                            Text('Password: $password',
                                style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),

                      /* Container(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Password: $_password',
                        style: TextStyle(fontSize: 14)),
                    decoration: BoxDecoration(
                      
                      border: Border.all(width: 4,color: Colors.blue),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),*/
                    ],
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 4, color: Colors.blue),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                          "Stato avanzamento: ${ref.watch(totalProgressProvider.notifier).state} %"),
                      //ProgressIndicatorWidget(_totalProgress),
                      Consumer(
                        builder: (context, ref, child) {
                          //final totalProgress = ref.watch(totalProgressProvider);
                          return ProgressIndicatorWidget(totalProgress);
                        },
                      ),
                    ],
                  ),
                ),

               //TO DO  const Text('lista scadenze'),
              ],
            ),
          ),
        ),
      ),
      
      /* child: Consumer(
        builder: (context, ref, child) {
          ref.listen(colorProvider, ((previous, next) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Nuove colore: $next!"),
            ));
          }));

          return child!;
        },*/
////////BODYBODY/////////BODYBODY//
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.blue.shade900,
        backgroundColor:
            ((ref.watch(totalProgressProvider.notifier).state >= 80))
                ? Colors.blue.shade200
                : Colors.grey.shade400,
        onPressed: () {
          if (ref.watch(totalProgressProvider.notifier).state >= 80) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Exit App'),
                    content:
                        const Text('Buon lavoro, hai completato tutto.OK?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('No'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Yes'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          // Close the app when "Yes" is pressed
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                });
          }
        },
        tooltip: 'Ok,puoi iniziare',
        child: const Icon(Icons.start_sharp),
      ),
    );
  }
}

/////////////////////////////////////////////////////////////////////////
/* void _openPopupWindow() {
    showDialog(
      //documenta showDialog di Dialog
      context: context,
      builder: (BuildContext context) {
        return PopupWindow(
          onDone: (String textField1Data, String textField2Data) {
            setState(() {
              _username = textField1Data;
              _password = textField2Data;
            });
          },
        );
      },
    );
  }*/
/*///////////////////////////////////////////////////////////
class Authentication {
  void openPopupWindow(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopupWindow(
          onDone: (String textField1Data, String textField2Data) {
            // Use ref to access
            ref.watch(usernameProvider.notifier).state = textField1Data;
            // Handle other authentication logic as needed
          },
        );
      },
    );
  }
}

class PopupWindow extends StatefulWidget {
  final Function onDone; //definizione di onDone
  PopupWindow({required this.onDone});
  @override
  _PopupWindowState createState() => _PopupWindowState();
}

class _PopupWindowState extends State<PopupWindow> {
  final _formKey = GlobalKey<FormState>();
  final _textField1Controller =
      TextEditingController(); //creo due TextEditingController
  final _textField2Controller = TextEditingController();
  late bool _passwordVisibility;

  @override
  void initState() {
    super.initState();
    _passwordVisibility = false;
  }

  void _done() {
    if (_formKey.currentState!.validate()) {
      widget.onDone(
        _textField1Controller.text,
        _textField2Controller.text,
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(''),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _textField1Controller,
              validator: (value) {
                if (value!.trim().isEmpty) {
                  
                  return 'Please enter some text';
                }

                return null;
              },
              decoration: InputDecoration(
                labelText: "Username",
                hintText: "Please enter your username",
                icon: new Icon(
                  Icons.engineering,
                  color: Colors.grey,
                ),
              ),
            ),
            TextFormField(
              controller: _textField2Controller,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                if (!_passwordValidationCriteria(value)) {
                  return "The password you entered doesn't meet one or more of the following criteria: 1 upper case character, 1 lower case character, 1 numeric character, 1 special character (\!, \@, \#, \$, \&, \*, \~)";
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: "Password",
                hintText: "Please enter your password",
                icon: new Icon(
                  Icons.lock,
                  color: Colors.grey,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    !_passwordVisibility
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisibility = !_passwordVisibility;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _done,
          child: Text('Done'),
        ),
      ],
    );
  }
}*/

/*copio _passwordValisdationCriteria()
bool _passwordValidationCriteria(String value) {
  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regExp = new RegExp(pattern);
  return regExp.hasMatch(value);
}*/
