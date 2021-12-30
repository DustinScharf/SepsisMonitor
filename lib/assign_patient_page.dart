import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AssignPatientPage extends StatefulWidget {
  final String data;

  const AssignPatientPage({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  _AssignPatientPageState createState() => _AssignPatientPageState();
}

class _AssignPatientPageState extends State<AssignPatientPage> {
  final _staff = [];
  final _biggerFont = const TextStyle(fontSize: 18);

  final DatabaseReference _staffDbRef =
      FirebaseDatabase.instance.ref("hospital/staff");
  bool _loaded = false;

  String _dropdownValue = "Show Patients";

  String _patientName = "";

  @override
  void initState() {
    FirebaseDatabase.instance
        .ref("hospital/patients")
        .child(widget.data)
        .onValue
        .listen((event) {
      LinkedHashMap patientMap = event.snapshot.value as LinkedHashMap;
      _patientName = patientMap["firstName"] + " " + patientMap["lastName"];
    });

    Query _staffsByIsLMMP = _staffDbRef.orderByChild("isLMMP");
    _staffsByIsLMMP.onValue.listen((DatabaseEvent event) {
      setState(() {
        _staff.clear();
        for (var element in event.snapshot.children) {
          LinkedHashMap staff =
              element.value as LinkedHashMap<Object?, Object?>;
          staff.putIfAbsent("id", () => element.key);
          _staff.add(staff);
        }
        _loaded = true;
      });
    });

    super.initState();
  }

  Widget _buildStaffList() {
    if (_staff.isEmpty) {
      return Center(
        child: Text(
          (_loaded ? "There are no MMPs..." : "Loading..."),
          style: _biggerFont,
        ),
      );
    }

    String _patientCount(LinkedHashMap staff) {
      if (staff.containsKey("patients")) {
        return "Patients: " +
            (staff["patients"] as LinkedHashMap).length.toString();
      } else {
        return "Patients: 0";
      }
    }

    Widget _buildRow(LinkedHashMap staff) {
      return ListTile(
        leading: Icon(
          Icons.person_add,
          // color: staff["isLMMP"] ? Colors.redAccent : Colors.lightGreen,
          color: staff["isLMMP"] ? null : Colors.lightGreen,
          size: 48,
        ),
        title: Text(
          staff["firstName"] + " " + staff["lastName"],
          style: _biggerFont,
        ),
        subtitle: Text(_patientCount(staff)),
        trailing: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          textDirection: TextDirection.ltr,
          children: <Widget>[
            Text(
              staff["isLMMP"] ? "L-MMP" : "MMP",
              style: const TextStyle(color: Colors.grey),
            ),
            PopupMenuButton<String>(
              onSelected: (String result) {
                setState(() {
                  _dropdownValue = result;
                });
                if (_dropdownValue == "Show Patients") {
                  Navigator.of(context).pushNamed(
                    "/patientlist",
                    arguments: staff["id"],
                  );
                } else if (_dropdownValue == "Assign") {
                  _staffDbRef.child(staff["id"]).child("patients").update({
                    widget.data: true,
                  });
                  Navigator.of(context).pop();
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: "Assign",
                  child: Text(
                    "Assign Patient\n" + _patientName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: "Show Patients",
                  child: Text("Show Patients"),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _staff.length * 2 - 1,
        itemBuilder: (BuildContext _context, int i) {
          if (i.isOdd) {
            return const Divider();
          }

          final int index = i ~/ 2;
          return _buildRow(_staff.toList()[index]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assign ' + _patientName + ' To Staff'),
      ),
      body: _buildStaffList(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.of(context).pushNamed(
      //       "/addpatient",
      //       arguments: null,
      //     );
      //   },
      //   tooltip: 'Add Patient',
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
