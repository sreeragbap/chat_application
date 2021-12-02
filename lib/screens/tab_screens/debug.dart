import 'package:flutter/material.dart';
import 'package:messageapp/mqtt_connection.dart';

class Debug extends StatefulWidget {
  const Debug({Key key}) : super(key: key);

  @override
  State<Debug> createState() => _DebugState();
}

class _DebugState extends State<Debug> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: OutlinedButton(
        child: const Text("clear"),
        onPressed: () {
          setState(() {
            printListElements.clear();
          });
        },
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: printListElements.map((e) => Text("$e\n")).toList(),
          ),
        ),
      ),
    );
  }
}
