import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sepsis_monitor/layout.dart';
import 'package:web_browser_detect/web_browser_detect.dart';

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

  _browserInfo() {
    if (kIsWeb) {
      // todo detected if on web,
      // todo if so print supported browsers and if also on mobile,
      // todo print also app download links
      return Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
        child: const Text(
          "Use newest Chrome, Safari or Edge if you encounter bugs.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.redAccent,
          ),
        ),
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    // todo detected not chrome webbrowser and notify about possible errors
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
                    _browserInfo(),
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
