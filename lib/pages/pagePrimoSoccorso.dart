// ignore_for_file: file_names

import 'package:logbook1_0_0/pages/homePage.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logbook1_0_0/pages/subPagePrimoSoccorso.dart';
import 'package:logbook1_0_0/providers.dart';
/*void main() {
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
} */

//provider to manage the total progress in app
//final totalProgressProvider = StateProvider<int>((ref) => 0);
bool _incremented = false;

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

////////////////////////////////////////////////////////////////////

class PagePrimoSoccorso extends HookConsumerWidget {
  const PagePrimoSoccorso({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('Building $runtimeType');
    /*moved to a new Provider 
    final checks = ref.watch(checkProvider);
     bool allDone = checks.every((check) => check.checked);
*/
    final allDone = ref.watch(allDoneProvider);

    void incrementa(bool allDone) {
      if (allDone && (!_incremented)) {
        ref.read(totalProgressProvider.notifier).state += 10;
        debugPrint('Building $runtimeType');
        _incremented = !_incremented;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Check list Primo Soccorso"),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined),
            onPressed: () {
              if (allDone) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              }
            },
          ),
          IconButton(
            tooltip: "disposizioni di riferimento",
            icon: const Icon(Icons.info),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const subPagePrimoSoccorso()),
              );
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
        backgroundColor: (allDone && (!_incremented))
            ? Colors.blue.shade200
            : Colors.grey.shade400,
        onPressed: () {
          if (!_incremented) {
            incrementa(allDone);

            debugPrint('$_incremented');
          }
        },
        child: const Icon(Icons.done_all_outlined),
      ),

//floatingActionButton//floatingActionButton
    );
  }
}
