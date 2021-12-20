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
  final DatabaseReference _patientsLogDbRef =
      FirebaseDatabase.instance.ref("hospital/log/patients");

  bool _loaded = false;

  String _dropdownValue = "More Info";

  Widget _buildPatientList() {
    if (_patients.isEmpty) {
      return Center(
        child: Text(
          (_loaded ? "You don't have any patients..." : "Loading..."),
          style: _biggerFont,
        ),
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

  String _getPhaseString(LinkedHashMap patient) {
    return _getPhaseStringById(patient["phase"]);
  }

  String _getPhaseStringById(int phaseId) {
    switch (phaseId) {
      case 0:
        return "Registration";
      case 1:
        return "ER Triage";
      case 2:
        return "ER Sepsis Triage";
      case 3:
        return "IV Antibiotics";
      case 4:
        return "Admission";
      case 5:
        return "Release";
      default:
        return "Archive";
    }
  }

  Icon _getPhaseIcon(LinkedHashMap patient) {
    IconData iconData;
    double iconSize = 48;
    Color? iconColor;
    switch (patient["phase"]) {
      case 0:
        iconData = Icons.app_registration;
        break;
      case 1:
        iconData = Icons.assignment;
        break;
      case 2:
        iconData = Icons.add_alarm;
        iconColor = Colors.redAccent;
        break;
      case 3:
        iconData = Icons.wifi_tethering;
        break;
      case 4:
        iconData = Icons.bed;
        break;
      case 5:
        iconData = Icons.time_to_leave;
        break;
      case 6:
        iconData = Icons.archive;
        break;
      default:
        iconData = Icons.error;
        break;
    }
    return Icon(
      iconData,
      size: iconSize,
      color: iconColor,
    );
  }

  Widget _buildRow(LinkedHashMap patient) {
    return ListTile(
      leading: _getPhaseIcon(patient),
      title: Text(
        _buildBasicPatientInfo(patient),
        style: _biggerFont,
      ),
      subtitle: Text(_buildPhasePatientInfo(patient)),
      trailing: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.ltr,
        children: <Widget>[
          Text(
            _buildStaffPatientInfo(patient),
            style: const TextStyle(color: Colors.grey),
          ),
          PopupMenuButton<String>(
            onSelected: (String result) {
              setState(() {
                _dropdownValue = result;
              });
              if (_dropdownValue == "Assign") {
                Navigator.of(context).pushNamed(
                  "/assignpatient",
                  arguments: null, // todo pass staff id
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: "Next Phase",
                child: Text(
                    "Next Phase\n" + _getPhaseStringById(patient["phase"] + 1)),
                onTap: () async {
                  DatabaseEvent event =
                      await _patientsLogDbRef.child(patient["id"]).once();
                  int logItems = (event.snapshot.value as List).length;
                  String? staffId = FirebaseAuth.instance.currentUser?.uid;
                  staffId ??= "Anonymous";
                  _patientsLogDbRef
                      .child(patient["id"])
                      .child(logItems.toString())
                      .update({
                    "staff": staffId,
                    "time":
                        (DateTime.now().millisecondsSinceEpoch / 1000).ceil(),
                    "toPhase": patient["phase"] + 1,
                  });

                  _patientsDbRef.child(patient["id"]).update({
                    "phase": patient["phase"] + 1,
                    "lastUpdated":
                        (DateTime.now().millisecondsSinceEpoch / 1000).ceil(),
                  });
                },
              ),
              const PopupMenuItem<String>(
                value: "Assign",
                child: Text("Assign To Staff"),
              ),
              const PopupMenuItem<String>(
                value: "More Info",
                child: Text("More Info"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _buildBasicPatientInfo(LinkedHashMap patient) {
    String patientInfo = patient["firstName"] + " " + patient["lastName"];
    return patientInfo;
  }

  String _buildPhasePatientInfo(LinkedHashMap patient) {
    String patientInfo = _getPhaseString(patient);
    return patientInfo;
  }

  String _buildStaffPatientInfo(LinkedHashMap patient) {
    String patientInfo = "Unassigned";
    if (patient.containsKey("staff")) {
      LinkedHashMap staff = patient["staff"] as LinkedHashMap;
      patientInfo = staff["firstName"] + " " + staff["lastName"];
    }
    return patientInfo;
  }

  _putPatientsForStaff(String staffId) {
    Query staff = _staffDbRef.child(staffId);
    staff.onValue.listen((DatabaseEvent event) {
      LinkedHashMap staffMap = event.snapshot.value as LinkedHashMap;

      Query patientsSorted = _patientsDbRef.orderByChild("phase");
      // Subscribe to the query
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
              patient.putIfAbsent("id", () => element.key);
              _patients.add(patient);
            }
          }
          _loaded = true;
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
          patient["staff"] = staff.value;
          (patient["staff"] as LinkedHashMap)
              .putIfAbsent("id", () => staff.key);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(
            "/addpatient",
            arguments: null,
          );
        },
        tooltip: 'Add Patient',
        child: const Icon(Icons.add),
      ),
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
