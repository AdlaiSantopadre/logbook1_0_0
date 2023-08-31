import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('TextField Example'),
        ),
        body: MyTextField(),
      ),
    );
  }
}

class MyTextField extends StatefulWidget {
  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  DateTime fixDate = DateTime.now();
  TextEditingController dataController = TextEditingController();
  FocusNode nextFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: Colors.blue,
        width: 8.0,
      ),
    );

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          style: TextStyle(fontSize: 16),
          controller: dataController,
          focusNode: nextFocus,
          decoration: InputDecoration(
            hintText: 'Data',
            border: inputBorder,
          ),
          onTap: () async {
            // Show date picker
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: fixDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );

            if (pickedDate != null) {
              setState(() {
                fixDate = DateTime(
                  pickedDate.year,
                  pickedDate.month,
                  pickedDate.day,
                );
                String formattedDate = DateFormat('dd-MM-yyyy ').format(fixDate);
                dataController.text = formattedDate;
                FocusScope.of(context).requestFocus(nextFocus);
              });
            }
          },
        ),
      ),
    );
  }
}
