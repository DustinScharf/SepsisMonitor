import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sepsis_monitor/layout.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddPatientPage extends StatefulWidget {
  const AddPatientPage({Key? key}) : super(key: key);

  @override
  _AddPatientPageState createState() => _AddPatientPageState();
}

class _AddPatientPageState extends State<AddPatientPage> {
  String _firstName = "";
  String _lastName = "";

  // @override
  // void initState() {
  //   super.initState();
  // }

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
        obscureText: true,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Last Name",
        ),
      ),
    );
  }

  ElevatedButton _addPatientButton() {
    return ElevatedButton(
      onPressed: () async {
        // try {
        //   UserCredential userCredential =
        //       await FirebaseAuth.instance.signInWithEmailAndPassword(
        //     email: _email,
        //     password: _password,
        //   );
        // } on FirebaseAuthException catch (e) {
        //   if (e.code == 'user-not-found') {
        //     final snackBar = SnackBar(
        //       content: const Text('No user found for that email.'),
        //       action: SnackBarAction(
        //         label: 'Register',
        //         onPressed: () {
        //           Navigator.of(context).pushNamed(
        //             "/registration",
        //             arguments: null, // TODO pass email
        //           );
        //         },
        //       ),
        //     );
        //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
        //   } else if (e.code == 'wrong-password') {
        //     const snackBar = SnackBar(
        //       content: Text('Wrong password provided for that user.'),
        //     );
        //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
        //   }
        // }
      },
      child: const Text("ADD PATIENT"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Patient"),
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
                        "Add Patient",
                        style: TextStyle(fontSize: 24),
                      ),
                      const Text(
                        "Enter Patient Data",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16.0),
                      _firstNameTextField(),
                      const SizedBox(height: 16.0),
                      _lastNameTextField(),
                      const SizedBox(height: 8.0),
                      _addPatientButton(),
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
