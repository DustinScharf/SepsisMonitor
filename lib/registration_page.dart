import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sepsis_monitor/layout.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  String _email = "";
  String _password = "";

  Container _emailTextField() {
    return Container(
      margin: const EdgeInsets.only(left: 50.0, right: 50.0),
      width: Layout.maxWidth,
      child: TextField(
        onChanged: (text) {
          _email = text;
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Email",
        ),
      ),
    );
  }

  Container _passwordTextField() {
    return Container(
      margin: const EdgeInsets.only(left: 50.0, right: 50.0),
      width: Layout.maxWidth,
      child: TextField(
        onChanged: (text) {
          _password = text;
        },
        obscureText: true,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Password",
        ),
      ),
    );
  }

  ElevatedButton _registrationButton() {
    return ElevatedButton(
      onPressed: () async {
        try {
          UserCredential userCredential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _email,
            password: _password,
          );
          Navigator.of(context).popAndPushNamed(
            "/login",
            arguments: null,
          );
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            print('The password provided is too weak.');
          } else if (e.code == 'email-already-in-use') {
            print('The account already exists for that email.');
          }
        } catch (e) {
          print(e);
        }
      },
      child: const Text("CONFIRM"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registration"),
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        child: Center(
          child: Card(
            elevation: 8,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(
                      height: 16.0,
                    ),
                    const Text(
                      "Registration",
                      style: TextStyle(fontSize: 24),
                    ),
                    const Text(
                      "Enter your credentials",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    _emailTextField(),
                    const SizedBox(
                      height: 16.0,
                    ),
                    _passwordTextField(),
                    const SizedBox(
                      height: 8.0,
                    ),
                    _registrationButton(),
                    const SizedBox(
                      height: 16.0,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
