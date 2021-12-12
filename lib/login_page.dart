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
                      Container(
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
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Container(
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
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            print(_email + ":" + _password);
                            try {
                              UserCredential userCredential = await FirebaseAuth
                                  .instance
                                  .createUserWithEmailAndPassword(
                                email: _email,
                                password: _password,
                              );
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                print('The password provided is too weak.');
                              } else if (e.code == 'email-already-in-use') {
                                print(
                                    'The account already exists for that email.');
                              }
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: const Text("CONFIRM")),
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
