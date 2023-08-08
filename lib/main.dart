import 'package:flutter/material.dart'; //per utilizzare il Material design

import 'package:logbook1_0_0/components/DatePickerExemple.dart';
//import 'package:login_flutter_app/pages/login.dart';

void main()=>
    runApp(RestorationScope(restorationId: 'main', child: LogbookApp()  ));
 // enabled state restoration for the entire widget tree.
void _handleDateSelected(DateTime selectedDate) {
    // Handle the selected date here
    print('Selected date: $selectedDate');
    }  
//MyApp is  LogbookApp
class LogbookApp extends StatefulWidget {
 
  @override
  State<LogbookApp> createState() => _LogbookAppState();
}


 

class _LogbookAppState extends State<LogbookApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        /*For a Material app, you can use a Scaffold widget;
     it provides a default banner, background color, and has API for adding drawers, snack bars, and bottom sheets. 
    Then you can add the Center widget directly to the body property for the home page.*/
        title: 'Logbook HomePage',
        debugShowCheckedModeBanner: true, //mostra il banner debug mode
        theme: ThemeData(primarySwatch: Colors.cyan),
        home: Homepage()); //Chiamata a HomePage home della navigazione
  }
}

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String? _username;
  String? _password;
  
  var restorableDatePickerRouteFuture;
  //List per gestire la navigazione nel drawer
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

 

  @override
  Widget build(BuildContext context) {
    debugPrint('Building $runtimeType');
    return Scaffold(
      //Creo un visual scaffold con appbar e floatingActionButton e drawer

      drawer: Drawer(
         // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.https://flutter.github.io/samples/add_a_drawer_to_a_screen.html
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
             DrawerHeader(
              decoration: BoxDecoration(
                shape:BoxShape.rectangle,
                
                
                
                color: Colors.cyan
                ,
              ),
              child:Center(
                child: Image.asset('lib/assets/B1logo.png')), //Text('Compiti assegnati'),
            ),
            ListTile(
              title: const Text('Home'),
              selected: _selectedIndex == 0,
              onTap: () {
                // Update the state of the app
                _onItemTapped(0);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Business'),
              selected: _selectedIndex == 1,
              onTap: () {
                // Update the state of the app
                _onItemTapped(1);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('School'),
              selected: _selectedIndex == 2,
              onTap: () {
                // Update the state of the app
                _onItemTapped(2);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            _widgetOptions[_selectedIndex],
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text(
          "Diario di bordo",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontFamily: 'Roboto',
            letterSpacing: 0.5,
            fontSize: 14,
          ),
        ),
        /*actions: [
          IconButton(
              onPressed: () {
                context
                    .findAncestorStateOfType<_LogbookAppState>()
                    
              },
              icon: const Icon(Icons.change_circle_outlined)),
        ],*/
      ),
      /* body: Consumer(
        builder: (context, ref, child) {
          ref.listen(colorProvider, ((previous, next) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Nuove colore: $next!"),
            ));
          }));

          return child!;
        },*/
      body: Center(
        child: Container(
          padding: EdgeInsets.all(1.0),
          child: Column(
            verticalDirection: VerticalDirection.down,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [ 
              _widgetOptions[_selectedIndex], 
              
          /* OutlinedButton(
          onPressed: () {
            restorableDatePickerRouteFuture.present();
          },
          child: const Text('Open Date Picker'),
        
          ),*/
          SizedBox(
            width: 300.0,
            height:300.0,

            child: DatePickerExample(
              onDateSelected: _handleDateSelected,
            ),
          ),
    // Ho utilizzato per il momento sized box (cfr widgedoftheweek per garantire la resa dei contenuti sulla Homepage
  
              
              
              /*const Text(
                'Datario',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Roboto',
                  letterSpacing: 0.5,
                  fontSize: 14,
                ),
              ),*/

              //inserire qui il widget per il la autenticazione
              ElevatedButton(
                onPressed: _openPopupWindow,
                child: Text('Open Popup Window'),
              ),
              Text('Username: $_username'),
              Text('Password: $_password'),

              const Text(' White Space            '),
              const Text('indicatore di progresso'),
              const Text('lista scadenze'),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Clic sul floating button: andiamo ad incrementare il contatore facendo
          // riferimento a InheritedCounter, l'InheritedWidget che propaga il contatore
          // InheritedCounter.increase(context);

          //ref.read(todoProvider.notifier).addTodo(
          //    "${_todoTitles[_rnd.nextInt(_todoTitles.length)]} ${++_todoProgressiveCounter}",
          //    _todoDescriptions[_rnd.nextInt(_todoDescriptions.length)]);
        },
        tooltip: 'Ok,puoi iniziare',
        child: const Icon(Icons.start_sharp),
      ),
      //drawer: const MyDrawer(),
    );
  }
   void _openPopupWindow() {
    showDialog(    //documenta showDialog di Dialog
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
  final _textField1Controller = TextEditingController(); //creo due TextEditingController
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
      title: Text('Ma tu chi sei?'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _textField1Controller,
              validator: (value) {
                if (value!.trim().isEmpty) { /*copiata riga 64*/
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
            !_passwordVisibility ? Icons.visibility : Icons.visibility_off,
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

  }
  /*copio _passwordValisdationCriteria()*/
  bool _passwordValidationCriteria(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }
  
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }



