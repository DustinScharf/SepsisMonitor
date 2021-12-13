import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = "";
  String _password = "";

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print("Logout");
      } else {
        print("Login of " + user.email.toString());
      }
      super.initState();
    });
  }

  Container _emailTextField() {
    return Container(
      margin: const EdgeInsets.only(left: 50.0, right: 50.0),
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

  ElevatedButton _loginButton() {
    return ElevatedButton(
      onPressed: () async {
        try {
          UserCredential userCredential =
              await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _email,
            password: _password,
          );
          print("INNNN!!");
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            print('No user found for that email.');
          } else if (e.code == 'wrong-password') {
            print('Wrong password provided for that user.');
          }
        }
      },
      child: const Text("CONFIRM"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        child: Center(
          child: Card(
            elevation: 8,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const SizedBox(
                        height: 16.0,
                      ),
                      const Text(
                        "Login",
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
                      _loginButton(),
                      const SizedBox(
                        height: 16.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
