import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  LoginForm({Key? key}) : super(key: key);

  @override
  LoginFormState createState() => new LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  String? _username;
  String? _password;
  late bool _passwordVisibility;

  @override
  void initState() {
    super.initState();
    _passwordVisibility = false;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.always,
      key: _formKey,
      child: Column(
        children: <Widget>[
          _usernameTextFormField(),
          _passwordTextFormField(),
        ],
      ),
    );
  }

  Widget _usernameTextFormField() {
    return TextFormField(
      validator: (value) {
        if (value!.trim().isEmpty) {
          return "Please fill username field";
        }
      },
      onSaved: (value) {
        setState(() {
          _username = value!.trim();
        });
      },
      decoration: InputDecoration(
        labelText: "Username",
        hintText: "Please enter your username",
        icon: new Icon(
          Icons.email,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _passwordTextFormField() {
    return TextFormField(
      obscureText: !_passwordVisibility,
      validator: (value) {
        if (value!.trim().isEmpty) {
          return "Please fill password field";
        }

        if (!_passwordValidationCriteria(value)) {
          return "The password you entered doesn't meet one or more of the following criteria: 1 upper case character, 1 lower case character, 1 numeric character, 1 special character (\!, \@, \#, \$, \&, \*, \~)";
        }
      },
      onSaved: (value) {
        setState(() {
          _password = value!.trim();
        });
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
    );
  }

  bool _passwordValidationCriteria(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  void validate() {
    _formKey.currentState!.validate()
        ? ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Login completed successfully")))
        : ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Please check your data!")));
  }
}
