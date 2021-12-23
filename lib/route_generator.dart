import 'package:flutter/material.dart';
import 'package:sepsis_monitor/add_patient_page.dart';
import 'package:sepsis_monitor/assign_patient_page.dart';
import 'package:sepsis_monitor/auth_manager.dart';
import 'package:sepsis_monitor/login_page.dart';
import 'package:sepsis_monitor/main.dart';
import 'package:sepsis_monitor/overview_page.dart';
import 'package:sepsis_monitor/patient_list_page.dart';
import 'package:sepsis_monitor/registration_page.dart';
import 'package:sepsis_monitor/start_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => const StartPage());
      case '/login':
        // TODO check if already logged in
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/registration':
        return MaterialPageRoute(builder: (_) => const RegistrationPage());
      case '/overview':
        return MaterialPageRoute(builder: (_) => const OverviewPage());
      case '/patientlist':
        return MaterialPageRoute(
          builder: (_) => PatientListPage(
            data: args is String ? args : "",
          ),
        );
      case '/addpatient':
        return MaterialPageRoute(builder: (_) => const AddPatientPage());
      case '/assignpatient':
        return MaterialPageRoute(builder: (_) => const AssignPatientPage());
      // case '/second':
      //   // Validation of correct data type
      //   if (args is String) {
      //     return MaterialPageRoute(
      //       builder: (_) => SecondPage(
      //         data: args,
      //       ),
      //     );
      //   }
      //   // If args is not of the correct type, return an error page.
      //   // You can also throw an exception while in development.
      //   return _errorRoute();
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Page not found"),
        ),
        body: const Center(
          child: Text("The requested page does not exist."),
        ),
      );
    });
  }
}
