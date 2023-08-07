
import 'package:flutter/material.dart';

//DatePickerController

class DatePickerController {
  final RestorableTextEditingController _controller = RestorableTextEditingController();

  RestorableTextEditingController get controller => _controller;

  void dispose() {
    _controller.dispose();
  }
}





class DatePickerExample extends StatefulWidget {
  final void Function(DateTime selectedDate) onDateSelected;

  DatePickerExample({required this.onDateSelected});

  @override
  _DatePickerExampleState createState() => _DatePickerExampleState();
}

class _DatePickerExampleState extends State<DatePickerExample> with RestorationMixin {
  RestorableDateTime _selectedDate = RestorableDateTime(DateTime.now());
  final DatePickerController _datePickerController = DatePickerController();

  @override
  String get restorationId => 'date_picker_example';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    
  }
  @override
  void dispose() {
    _datePickerController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text('Date Picker Example'),
      ),*/
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () => _selectDate(context),
              child: Text('Seleziona la data'),
            ),
            Text(
              'Selected Date: ${_selectedDate.value}',
              style: TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedDate.value) {
      setState(() {
        _selectedDate.value = pickedDate;
        widget.onDateSelected(pickedDate); // Call the callback function to handle the selected date
      });
    }
  }
}
