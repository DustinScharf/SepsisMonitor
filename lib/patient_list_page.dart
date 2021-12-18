import 'dart:async';
import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
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

  final DatabaseReference _staffDbRef =
      FirebaseDatabase.instance.ref("hospital/staff");
  final DatabaseReference _patientsDbRef =
      FirebaseDatabase.instance.ref("hospital/patients");

  Widget _buildPatientList() {
    if (_patients.isEmpty) {
      return const Center(
        child: Text("Loading..."),
      );
    }

    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _patients.length * 2 - 1,
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

  Widget _buildRow(LinkedHashMap patient) {
    return ListTile(
      title: Text(
        _buildPatientInfo(patient),
        style: _biggerFont,
      ),
    );
  }

  String _buildPatientInfo(LinkedHashMap patient) {
    String patientInfo = patient["firstName"] +
        " " +
        patient["lastName"] +
        " in Phase " +
        patient["phase"].toString();
    if (patient.containsKey("staff")) {
      LinkedHashMap staff = patient["staff"] as LinkedHashMap;
      patientInfo += " @ " + staff["firstName"] + staff["lastName"];
    }

    return patientInfo;
  }

  _putPatientsForStaff(String staffId) {
    Query staff = _staffDbRef.child(staffId);
    staff.onValue.listen((DatabaseEvent event) {
      LinkedHashMap staffMap = event.snapshot.value as LinkedHashMap;

      Query patientsSorted = _patientsDbRef.orderByChild("phase");
      // Subscribe to the query TODO: get only patients of a certain staff
      patientsSorted.onValue.listen((DatabaseEvent event) {
        setState(() {
          _patients.clear();
          for (var element in event.snapshot.children) {
            if (staffMap["patients"] == null ||
                (staffMap["patients"] as LinkedHashMap)
                    .containsKey(element.key)) {
              LinkedHashMap patient =
                  element.value as LinkedHashMap<Object?, Object?>;
              _putStaffToPatient(element.key.toString(), patient);
              _patients.add(patient);
            }
          }
        });
      });
    });
  }

  _putStaffToPatient(String patientId, LinkedHashMap patient) {
    Query staffSorted = _staffDbRef.orderByChild("lastName");
    staffSorted.onValue.listen((event) {
      var staffList = event.snapshot.children.where((staffData) =>
          ((staffData.value as LinkedHashMap).containsKey("patients") &&
              ((staffData.value as LinkedHashMap)["patients"] as LinkedHashMap)
                  .containsKey(patientId)));
      for (var staff in staffList) {
        setState(() {
          patient.putIfAbsent("staff", () => staff.value);
        });
      }
    });
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

  @override
  void initState() {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    uid ??= "LOADING ERROR!"; // todo better handle
    _putPatientsForStaff(uid);

    super.initState();
  }
}
