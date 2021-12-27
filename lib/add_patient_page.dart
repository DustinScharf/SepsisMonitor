import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
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
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Last Name",
        ),
      ),
    );
  }

  // todo add second button for instant assign
  // todo (on me for mmp; go to assign staff page for lmmp)
  ElevatedButton _addPatientButton() {
    return ElevatedButton(
      onPressed: () async {
        if (_firstName.isEmpty || _lastName.isEmpty) {
          const snackBar = SnackBar(
            content: Text('Enter all fields.'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return;
        }
        DatabaseReference newPatientRef =
            FirebaseDatabase.instance.ref("hospital/patients").push();
        await newPatientRef.set({
          "firstName": _firstName,
          "lastName": _lastName,
          "lastUpdated": (DateTime.now().millisecondsSinceEpoch / 1000).ceil(),
          "phase": 0,
        });
        String? staffId = FirebaseAuth.instance.currentUser?.uid;
        await FirebaseDatabase.instance
            .ref("hospital/log/patients")
            .child(newPatientRef.key.toString())
            .child("0")
            .set({
          "staff": staffId ??= "Anonymous",
          "time": (DateTime.now().millisecondsSinceEpoch / 1000).ceil(),
          "toPhase": 0,
        });

        Navigator.of(context).pop();
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
