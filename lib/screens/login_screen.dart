import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:messageapp/mqtt_connection.dart';
import 'package:messageapp/responsive.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

TextEditingController nameController = TextEditingController();
TextEditingController nicknameController = TextEditingController();
TextEditingController empIdController = TextEditingController();
TextEditingController deptController = TextEditingController();
TextEditingController emailController = TextEditingController();

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading;
  MQTTClientWrapper m = MQTTClientWrapper();
  void mailConfig() async {
    const username = 'macompr.mgmt';
    const password = "Nh7J&\$s9A)s";
    const sender = "projectmanagement@macomsolutions.com";

    final smtpServer = SmtpServer('mail.mactech.net.in',
        port: 25,
        username: username,
        ssl: null,
        password: password,
        allowInsecure: true);
    final message = Message()
      ..from = const Address(username, username)
      ..recipients.add(emailController.text)
      ..subject = 'OTP'
      ..text = "12345";

    try {
      final sendReport = await send(message, smtpServer);
      var connection = PersistentConnection(smtpServer);
      await connection.send(message);
      await connection.close();
      print(sendReport);
      print("otp has been sent");
    } on MailerException catch (e) {
      print(e);
      print("otp failed");
    }
  }

  @override
  void initState() {
    super.initState();
    m.userDetails;
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    m = Provider.of<MQTTClientWrapper>(context);

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 70, right: 70),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topRight,
                colors: [Color(0xff2E86C1), Color(0xffFDFEFE)])),
        child: ListView(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 6),
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.transparent.withOpacity(0.3),
                      Colors.transparent.withOpacity(0.07)
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    border: Border.all(color: Colors.white.withOpacity(0.5)),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                height: MediaQuery.of(context).size.height * 0.8,
                padding: const EdgeInsets.only(
                    left: 30, right: 30, bottom: 20, top: 20),
                child: Column(
                  children: [
                    const Expanded(
                      child: Text(
                        'Register',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    InputField(
                      hintText: 'enter your name',
                      controller: nameController,
                      labeltext: 'name',
                    ),
                    InputField(
                      hintText: 'enter your nick name',
                      controller: nicknameController,
                      labeltext: 'nick name',
                    ),
                    InputField(
                        hintText: 'enter your employe code',
                        controller: empIdController,
                        labeltext: 'employe code'),
                    InputField(
                        hintText: 'department',
                        controller: deptController,
                        labeltext: 'department'),
                    InputField(
                        hintText: 'enter your emailid',
                        controller: emailController,
                        labeltext: 'emailid'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: Responsive.isMobile(context)
                  ? const EdgeInsets.symmetric(horizontal: 60)
                  : EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 3),
              child: FloatingActionButton.extended(
                  onPressed: () {
                    mailConfig();
                    if (emailController.text.isNotEmpty &&
                        nameController.text.isNotEmpty &&
                        empIdController.text.isNotEmpty) {
                      Navigator.pushReplacementNamed(
                        context,
                        'homepage',
                      );
                    }
                    if (m.userDetails.isEmpty) {
                      m.storeUserDetails(SetupUserdetails(
                          myname: nameController.text,
                          mynickname: nicknameController.text,
                          mydept: deptController.text,
                          myemailid: emailController.text,
                          myId: empIdController.text));
                      m.setUser(empIdController.text);
                    }
                  },
                  label: const Text("Register"),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50))),
            ),
          ],
        ),
      ),
    );
  }
}

class SetupUserdetails {
  String myname;
  String mynickname;
  String myId;
  String mydept;
  String myemailid;
  SetupUserdetails(
      {this.myname, this.mynickname, this.mydept, this.myemailid, this.myId});
}

class InputField extends StatelessWidget {
  String hintText;
  TextEditingController controller;
  String labeltext;

  InputField({
    Key key,
    this.hintText,
    this.controller,
    this.labeltext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        cursorColor: Colors.black,
        controller: controller,
        decoration: InputDecoration(
          focusedBorder: InputBorder.none,
          labelStyle: const TextStyle(
            color: Colors.black,
            letterSpacing: 2,
          ),
          hintText: hintText,
          labelText: labeltext,
        ),
      ),
    );
  }
}
