import 'package:firebase_database/firebase_database.dart';
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

  String _firstName = "";
  String _lastName = "";

  String _dropdownValue = 'MMP';

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

  Container _firstNameTextField() {
    return Container(
      margin: const EdgeInsets.only(left: 50.0, right: 50.0),
      child: TextField(
        onChanged: (text) {
          _firstName = text;
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "First Name",
        ),
      ),
    );
  }

  Container _lastNameTextField() {
    return Container(
      margin: const EdgeInsets.only(left: 50.0, right: 50.0),
      child: TextField(
        onChanged: (text) {
          _lastName = text;
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Last Name",
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

  ElevatedButton _registrationButton() {
    return ElevatedButton(
      onPressed: () async {
        try {
          UserCredential userCredential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _email,
            password: _password,
          );
          String? newUId = userCredential.user?.uid;
          newUId ??= "Loading error"; // todo better handling
          FirebaseDatabase.instance.ref("hospital/staff").child(newUId).set({
            "firstName": _firstName,
            "lastName": _lastName,
            "isLMMP": _dropdownValue == "LMMP",
            "confirmed": false,
          });
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
      child: const Text("REGISTER"),
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
                SizedBox(
                  width: Layout.maxWidth,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const SizedBox(height: 16.0),
                      const Text(
                        "Registration",
                        style: TextStyle(fontSize: 24),
                      ),
                      const Text(
                        "Enter your credentials",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16.0),
                      _emailTextField(),
                      const SizedBox(height: 16.0),
                      _passwordTextField(),
                      const SizedBox(height: 16.0),
                      _firstNameTextField(),
                      const SizedBox(height: 16.0),
                      _lastNameTextField(),
                      const SizedBox(height: 16.0),
                      DropdownButton<String>(
                        value: _dropdownValue,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        // underline: Container(
                        //   height: 2,
                        //   color: Colors.deepPurpleAccent,
                        // ),
                        onChanged: (String? newValue) {
                          setState(() {
                            _dropdownValue = newValue!;
                          });
                        },
                        items: <String>['MMP', 'LMMP']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8.0),
                      _registrationButton(),
                      const SizedBox(height: 16.0),
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
