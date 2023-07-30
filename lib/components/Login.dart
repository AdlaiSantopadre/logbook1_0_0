// ignore: file_names
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  //Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() =>new  _LoginState();
}

class _LoginState extends State<Login> {
  
  String? _username;
  String? _password;
  
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

  @override
  Widget build(BuildContext context) {
    return 
         Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Username: $_username'),
            Text('Password: $_password'),
            ElevatedButton(
              onPressed: _openPopupWindow,
              child: Text('Open Popup Window'),
            ),
          ],
        
     
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



