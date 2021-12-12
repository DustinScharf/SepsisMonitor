import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var txt = "";

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
            elevation: 128,
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
                        height: 32.0,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 50.0, right: 50.0),
                        child: TextField(
                          onChanged: (text) {
                            txt = text;
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Username",
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
                            txt = text;
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Password",
                          ),
                        ),
                      ),
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
