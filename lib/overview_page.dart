import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'layout.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({Key? key}) : super(key: key);

  @override
  _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome"),
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
                      "Welcome", // todo add name
                      style: TextStyle(fontSize: 24),
                    ),
                    const Text(
                      "What's up next?",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    SizedBox(
                      width: Layout.btnUniWidth,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text("PATIENT LIST"),
                      ),
                    ),
                    const SizedBox(
                      height: 4.0,
                    ),
                    SizedBox(
                      width: Layout.btnUniWidth,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text("ONLY ERST LIST"),
                      ),
                    ),
                    const SizedBox(
                      height: 4.0,
                    ),
                    SizedBox(
                      width: Layout.btnUniWidth,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text("CONFIRM ERST CASES"),
                      ),
                    ),
                    // const SizedBox( // todo
                    //   height: 4.0,
                    // ),
                    // SizedBox(
                    //   width: Layout.btnUniWidth,
                    //   child: ElevatedButton(
                    //     onPressed: () {},
                    //     child: const Text("CONFIRM REGISTRATION"),
                    //   ),
                    // ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _logout();
                        Navigator.of(context).pop();
                      },
                      child: const Text("LOGOUT"),
                    ),
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
