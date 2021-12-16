import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class PatientListPage extends StatefulWidget {
  const PatientListPage({Key? key}) : super(key: key);

  @override
  _PatientListPageState createState() => _PatientListPageState();
}

class _PatientListPageState extends State<PatientListPage> {
  final _patients = [];
  final _biggerFont = const TextStyle(fontSize: 18);
  bool _listening = false;

  final dbRef = FirebaseDatabase.instance.ref("hospital/patients");

  Widget _buildPatientList() {
    if (!_listening) {
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("hospital/patients");
      Query patientsSorted = ref.orderByChild("phase");

      // Subscribe to the query
      patientsSorted.onValue.listen((DatabaseEvent event) {
        print('Event Type: ${event.type}'); // DatabaseEventType.value;
        print('Snapshot: ${event.snapshot.value}'); // DataSnapshot
        setState(() {
          _patients.clear();
          event.snapshot.children.forEach((element) {
            LinkedHashMap patient = element.value as LinkedHashMap<Object?, Object?>;
            _patients.add(patient["firstName"] + " " + patient["lastName"]);
          });
          // (event.snapshot.value as LinkedHashMap<Object?, Object?>)
          //     .forEach((key, value) {
          //   _patients.add(
          //       (value as LinkedHashMap<Object?, Object?>)["phase"]); // todo
          // });
        });
      });

      _listening = true;
    }

    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _patients.length * 2,
        itemBuilder: (BuildContext _context, int i) {
          if (i.isOdd) {
            return const Divider();
          }

          final int index = i ~/ 2;
          // if (index >= _patients.length) {
          //   _patients.add(Random().nextInt(999).toString());
          // }
          return _buildRow(_patients.toList()[index]);
        });
  }

  Widget _buildRow(Object linkedHashMap) {
    return ListTile(
      title: Text(
        linkedHashMap.toString(),
        style: _biggerFont,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient List'),
      ),
      body: _buildPatientList(),
    );
  }
}
