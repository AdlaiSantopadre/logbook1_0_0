// ignore_for_file: file_names

import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logbook1_0_0/providers.dart' ;

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MaterialColor themeColor = Colors.blue;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Check List demo',
      theme: ThemeData(
        primarySwatch: themeColor,
      ),
      home: const PagePrimoSoccorso(),
    );
  }
}

const _uuid = Uuid(); //ref pub.dev\uuid-3.0.7\lib\uuid.dart

//provider to manage the total progress in app
//final totalProgressProvider = StateProvider<int>((ref) => 0);
bool _incremented = false;

final checkProvider = StateNotifierProvider<Checklist, List<Check>>(
  (ref) => Checklist([
    Check(_uuid.v4(), "Guanti sterili monouso in nitrile (2 paia).", false),
    Check(_uuid.v4(), "Flacone di soluzione cutanea di iodopovidone al 10% di iodio da 125 ml.", false),
    Check(_uuid.v4(), "Flacone di soluzione fisiologica (sodio cloruro 0,9%) da 250 ml (1).", false ),
    Check(_uuid.v4(), "Compresse di garza sterile 18 x 40 in buste singole (1).", false),
    Check(_uuid.v4(), "Compresse di garza sterile 10 x 10 in buste singole (3)", false),
    /*Check(_uuid.v4(), "Item 6", false),
    Check(_uuid.v4(), "Item 7", false),
    Check(_uuid.v4(), "Item 8", false),
    Check(_uuid.v4(), "Item 9", false),
    Check(_uuid.v4(), "Item 10", false),*/
  ]),
);

class CheckListView extends ConsumerWidget {
  const CheckListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint("Building $runtimeType");

    final checks = ref.watch(checkProvider);

    return ListView.builder(
      itemCount: checks.length,
      itemBuilder: (context, index) {
        debugPrint("Building  item $index");

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          //margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.blueGrey.shade50,
              boxShadow: [
                BoxShadow(
                    blurRadius: 10,
                    offset: Offset.fromDirection(120, 8),
                    color: Colors.black12)
              ]),
          child: Column(
            children: [
              Row(
                //  [checkbox] -----Title
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: checks[index].checked,
                    onChanged: (checked) {
                      ref
                          .watch(checkProvider.notifier)
                          .toggle(checks[index].id, checked!);
                    },
                  ),
                  Expanded(
                    child: Text(checks[index].title,
                      overflow: TextOverflow.visible,
                      maxLines: 2,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

/// ****************************************************** */
//provider e classe x accertare il completamento dei controlli
//final allDoneProvider = StateNotifierProvider<AllDoneNotifier, bool>(
//   (ref) => AllDoneNotifier(false));

/*class AllDoneNotifier extends StateNotifier<bool> {
  AllDoneNotifier(bool state) : super(state);
  void setAllDone(bool value) {
    state = value;
    print('$AllDoneNotifier');
  }
}*/

class PagePrimoSoccorso extends HookConsumerWidget {
  const PagePrimoSoccorso({super.key});
  

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('Building $runtimeType');

    final checks = ref.watch(checkProvider);
    final bool allDone = checks.every((check) => check.checked);
    

    void escape(bool allDone) {
      if (allDone && (!_incremented)) {
        ref.watch(totalProgressProvider.notifier).state += 10;
        _incremented = !_incremented;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Check list Primo Soccorso"),
        actions: [
          IconButton(
            icon: Icon(Icons.home_outlined),
            onPressed: () {
              if (allDone) {
                Navigator.pop(context);
              }
            },
          ),
          IconButton(
            tooltip: "disposizioni di riferimento",
            icon: Icon(Icons.info),
            onPressed: () {
              /*  Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const subPagePrimoSoccorso()),
                                );
       */
            },
          ),
        ],
      ),

      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(child: CheckListView()),
            ],
          ),
        ),
      ),

      //floatingActionButton//floatingActionButton
      floatingActionButton: FloatingActionButton(
        tooltip: 'Blue se completato',
        backgroundColor: (allDone && (!_incremented)) ? Colors.blue : Colors.grey,
        onPressed: () {
          escape(allDone);
        },
        child: const Icon(Icons.done_all_outlined),
      ),

//floatingActionButton//floatingActionButton
    );
  }
}

// classe dei controlli
class Check {
  final String id;
  final String title;
  final bool checked;
  final String? description;

  const Check(this.id, this.title, this.checked, [this.description]);
}

class Checklist extends StateNotifier<List<Check>> {
  /*Checklist(): super([]); Checklist(super.state);*/
  Checklist(List<Check> initialChecks) : super(initialChecks);

  void addCheck(String title, String? description) {
    state = [
      ...state,
      Check(_uuid.v4(), title, false, description),
    ];
  }

  void toggle(String id, bool checked) {
    state = [
      for (final check in state)
        if (check.id == id)
          Check(
            check.id,
            check.title,
            checked,
            check.description,
          )
        else
          check
    ];
  }
}
