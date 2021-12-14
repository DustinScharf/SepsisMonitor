import 'package:flutter/material.dart';
import 'package:sepsis_monitor/layout.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  ElevatedButton _toLoginButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushNamed(
          "/login",
          arguments: null,
        );
      },
      child: const Text("TO LOGIN"),
    );
  }

  ElevatedButton _toRegistrationButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushNamed(
          "/registration",
          arguments: null,
        );
      },
      child: const Text("TO REGISTRATION"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SepsisMonitor"),
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          elevation: 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: Layout.maxWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(
                      height: 16.0,
                    ),
                    const Text(
                      "SepsisMonitor",
                      style: TextStyle(fontSize: 24),
                    ),
                    const Text(
                      "The Sepsis Department Manager App",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    _toLoginButton(),
                    const SizedBox(
                      height: 4.0,
                    ),
                    _toRegistrationButton(),
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
    );
  }
}
