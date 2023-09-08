import 'package:flutter/material.dart';



/// Flutter code sample for [showDatePicker].

void main() {
  runApp(MaterialApp(
    home: DatePickerApp(),
  ));}
class DatePickerApp extends StatefulWidget {
  @override
  _DatePickerAppState createState() => _DatePickerAppState();
}

class _DatePickerAppState extends State<DatePickerApp> {
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Date Picker App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            selectedDate != null
                ? Text(
                    'Selected Date: ${selectedDate!.toLocal()}'.split(' ')[0],
                    style: TextStyle(fontSize: 55, fontWeight: FontWeight.bold),
                  )
                : Text(
                    'Select a Date',
                    style: TextStyle(fontSize: 55, fontWeight: FontWeight.bold),
                  ),
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text('Select date'),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextField(
              controller: TextEditingController(
                text: selectedDate != null
                    ? '${selectedDate!.toLocal()}'.split(' ')[0]
                    : '',
              ),
              readOnly: true, // Prevent manual editing
              decoration: InputDecoration(
                labelText: 'Selected Date',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/*
void main() {
  runApp(MaterialApp(
    home: DatePickerApp(),
  ));
}


class DatePickerApp extends StatelessWidget {
  const DatePickerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      restorationScopeId: 'app',
      home: const DatePickerApp(restorationId: 'main'),
    );
  }
}

class DatePickerApp extends StatefulWidget {
  const DatePickerApp({super.key, this.restorationId});

  final String? restorationId;

  @override
  State<DatePickerApp> createState() => _DatePickerAppState();
}

/// RestorationProperty objects can be used because of RestorationMixin.
class _DatePickerAppState extends State<DatePickerApp>
    with RestorationMixin {
  // In this App, the restoration ID for the mixin is passed in through
  // the [StatefulWidget]'s constructor.
  @override
  String? get restorationId => widget.restorationId;

  final RestorableDateTime _selectedDate =
      RestorableDateTime(DateTime(2021, 7, 25));
  late final RestorableRouteFuture<DateTime?> restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  @pragma('vm:entry-point')
  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime(2021),
          lastDate: DateTime(2022),
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Selected: ${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: OutlinedButton(
          onPressed: () {
            restorableDatePickerRouteFuture.present();
          },
          child: const Text('Open Date Picker'),
        ),
      ),
    );
  }
}*/
