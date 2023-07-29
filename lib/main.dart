import 'package:flutter/material.dart';
import 'package:logbook1_0_0/validateYourself.dart';

void main() => runApp(LogbookApp());

class LogbookApp extends StatefulWidget {
  @override
  State<LogbookApp> createState() => _LogbookAppState();
}

class _LogbookAppState extends State<LogbookApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Login',
        debugShowCheckedModeBanner: true, //mostra il banner debug mode
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        
        home: Homepage());
  }
}
class Homepage extends StatefulWidget{
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String? _username;

  String? _password;  

  @override
  Widget build(BuildContext context) {
     debugPrint('Building $runtimeType');
    return Scaffold(
      appBar: AppBar(
        title: const Text("Diario di bordo"),
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
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text('Datario'),
              
                Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Username: $_username'),
            Text('Password: $_password'),
            ValidateYourself()
            /*ElevatedButton(
              onPressed: ValidateYourself,
              child: Text('Open Popup Window'),
                 )*/,
                ],
              ),
           
                const Text('             '),
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
}

