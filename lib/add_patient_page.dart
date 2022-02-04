import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sepsis_monitor/layout.dart';

class AddPatientPage extends StatefulWidget {
  final String data;

  const AddPatientPage({
    Key? key,
    required this.data,
  }) : super(key: key);

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
          labelText: 'First Name',
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
          labelText: 'Last Name',
        ),
      ),
    );
  }

  SizedBox _onlyAddButton() {
    return SizedBox(
      width: Layout.smallButtonUniWidth,
      child: ElevatedButton(
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
            'firstName': _firstName,
            'lastName': _lastName,
            'lastUpdated':
                (DateTime.now().millisecondsSinceEpoch / 1000).ceil(),
            'phase': 0,
          });
          String? staffId = FirebaseAuth.instance.currentUser?.uid;
          if (widget.data.isNotEmpty) {
            await FirebaseDatabase.instance
                .ref("hospital/staff")
                .child(widget.data)
                .child("patients")
                .update({
              newPatientRef.key.toString(): true,
            });
          }
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
        child: Text(widget.data.isNotEmpty ? "ADD & ASSIGN ME" : "ONLY ADD"),
      ),
    );
  }

  Widget _instantAssignButton() {
    if (widget.data.isNotEmpty) {
      return Container();
    }

    return SizedBox(
      width: Layout.smallButtonUniWidth,
      child: ElevatedButton(
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
            "lastUpdated":
                (DateTime.now().millisecondsSinceEpoch / 1000).ceil(),
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

          Navigator.of(context).popAndPushNamed(
            "/assignpatient",
            arguments: newPatientRef.key.toString(),
          );
        },
        child: const Text("INSTANT ASSIGN"),
      ),
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
                      const SizedBox(height: 16.0),
                      _onlyAddButton(),
                      const SizedBox(height: 4.0),
                      _instantAssignButton(),
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
