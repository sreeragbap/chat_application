import 'dart:async';

import 'package:flutter/material.dart';

import 'package:messageapp/mqtt_connection.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  MQTTClientWrapper m = MQTTClientWrapper();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushNamedAndRemoveUntil(
        context,
        'loginscreen',
        (root) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Card(
              color: Colors.transparent,
              elevation: 30,
              child: Text(
                "Nouncio",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topRight,
            colors: [Color(0xff2E86C1), Color(0xffFDFEFE)],
          ),
        ),
      ),
    );
  }
}
