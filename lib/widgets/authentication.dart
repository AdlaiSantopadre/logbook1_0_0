
import 'package:flutter/material.dart'; //per utilizzare il Material design
//import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logbook1_0_0/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

class Authentication {
  void openPopupWindow(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopupWindow(
          onDone: (String? textField1Data, String? textField2Data) {
            // Use ref to access
            ref.read(usernameProvider.notifier).state = textField1Data;
            // Handle other authentication logic as needed
          },
        );
      },
    );
  }
}

// ignore: must_be_immutable
class PopupWindow extends ConsumerWidget {
  
  PopupWindow({super.key, required this.onDone});
  final Function(String?, String?) onDone;

  final _formKey = GlobalKey<FormState>();
  final _textField1Controller = TextEditingController(); //creo due TextEditingController
  final _textField2Controller = TextEditingController();
  late bool _passwordVisibility = true;

 /* @override
  void initState() {
    super.initState();
    _passwordVisibility 
  }*/

  void _done(BuildContext context, WidgetRef ref) {
    if (_formKey.currentState!.validate()) {
      onDone(
        _textField1Controller.text,
        _textField2Controller.text,
      );
    Navigator.pop(context);  
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final database = ref.read(databaseProvider); // Access the database provider
    final password = ref.read(passwordProvider); // Access the password state
    final username = ref.read(usernameProvider);
    final isValidPassword = ref.watch(passwordValidationProvider); // Access password validation result _done,
    final isAuthenticationLoading = ref.watch(authenticationProvider);
    
    return AlertDialog(
      title: const Text(''),
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
              obscureText: !_passwordVisibility,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                if (/*!isValidPassword!*/!_passwordValidationCriteria(value))  {
                  return "The password you entered doesn't meet one or more of the following criteria: 1 upper case character, 1 lower case character, 1 numeric character, 1 special character (\!, \@, \#, \$, \&, \*, \~)";
                }
                return null;
              },
              decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "Please enter your password",
                  icon:  const Icon(Icons.lock,      
                                color: Colors.grey,
                        ) ,
                  suffixIcon: IconButton(
                              icon: Icon(
                              !_passwordVisibility
                                ? Icons.visibility
                                : Icons.visibility_off,
                                color: Colors.grey,
                                ),
                  onPressed: () {
                    /*setState(() {
                      _passwordVisibility = !_passwordVisibility;
                    });*/
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => _done(context, ref),
          
                 
          child: Text('Done'),
        ),
      ],
    );
  }
}

//copio _passwordValisdationCriteria()
bool _passwordValidationCriteria(String value) {
  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regExp = new RegExp(pattern);
  return regExp.hasMatch(value);
}