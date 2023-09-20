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
            ref.read(usernameProvider.notifier).state = textField2Data;
            // Handle other authentication logic as needed
          },
        );
      },
    );
  }
}

class PopupWindow extends ConsumerWidget {
  PopupWindow({super.key, required this.onDone});
  final Function(String?, String?) onDone;

  final _formKey = GlobalKey<FormState>();
  final _textField1Controller = TextEditingController();
  final _textField2Controller = TextEditingController();
  // ignore: prefer_final_fields
  bool _passwordVisibility = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final database = ref.read(databaseProvider); // Access the database provider
    //final password = ref.read(passwordProvider); // Access the password state
    //final username = ref.read(usernameProvider);
    final isValidPassword = ref.watch(
        passwordValidationProvider); // Access password validation result _done,
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
                // set password = value username = textfiel etc
                final passwordProvider = StateProvider<String?>((ref) => value);
                final usernameProvider =
                    StateProvider<String?>((ref) => _textField1Controller.text);
                final isValidPassword = ref.read(passwordValidationProvider);
                /*if (passwordError != null) {
          return passwordError;
        }*/
                if (!isValidPassword) {
                  // Password validation failed, show an error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "The password you entered doesn't meet the criteria.",
                      ),
                    ),
                  );
                } else {
                  /*  // Password validation passed, use it for authentication
        final isAuthenticated = await ref.read(authenticationProvider);

        if (isAuthenticated) {
          // Authentication succeeded, update the passwordProvider
          //ref.read(passwordProvider) = password;
      final passwordProvider = StateProvider<String?>((ref) => currentpassword);*/
//holds the current user's password.
                  return null;
                }
              },
              decoration: InputDecoration(
                labelText: "Password",
                hintText: "Please enter your password",
                icon: const Icon(
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
                    
                   //  ref.read(passwordVisibilityProvider.notifier).toggleVisibility();
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

  void _done(BuildContext context, WidgetRef ref) async {
    if (_formKey.currentState!.validate()) {
      final currentusername = _textField1Controller.text;
      final currentpassword = _textField2Controller.text;

      // Validate the password
      final isValidPassword = ref.read(passwordValidationProvider);

      if (!isValidPassword) {
        // Password validation failed, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "The password you entered doesn't meet the criteria.",
            ),
          ),
        );
      } else {
        // Password validation passed, use it for authentication
        final isAuthenticated = await ref.read(authenticationProvider);

        if (isAuthenticated) {
          // Authentication succeeded, update the passwordProvider
          //ref.read(passwordProvider) = password;
          final passwordProvider =
              StateProvider<String?>((ref) => currentpassword);
//holds the current user's password.
          // Proceed with any other logic or operations here
          // For example, insert the new password into the database
          // and call the onDone callback.
          onDone(currentusername, currentpassword);
          Navigator.pop(context);
        } else {
          // Authentication failed, show an error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Authentication failed. Please try again."),
            ),
          );
        }
      }
    }
  } //_done
}

//copio _passwordValisdationCriteria()
bool _passwordValidationCriteria(String value) {
  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regExp = new RegExp(pattern);
  return regExp.hasMatch(value);
}
