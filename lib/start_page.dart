import 'package:flutter/material.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SepsisMonitor"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Welcome to SepsisMonitor",
              style: TextStyle(fontSize: 24),
            ),
            const Text(
              "The Sepsis Department Manager App",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 16.0,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    "/login",
                    arguments: null,
                  );
                },
                child: const Text("TO LOGIN")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    "/registration",
                    arguments: null,
                  );
                },
                child: const Text("TO REGISTRATION")),
          ],
        ),
      ),
    );
  }
}
