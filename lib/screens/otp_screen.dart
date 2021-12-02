import 'package:flutter/material.dart';

class otpscreen extends StatefulWidget {
  const otpscreen({Key key}) : super(key: key);

  @override
  _otpscreenState createState() => _otpscreenState();
}

TextEditingController otpController = TextEditingController();
// MQTTClientWrapper m = MQTTClientWrapper();

class _otpscreenState extends State<otpscreen> {
  String emailid;
  bool isLoading;
  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  void reSentOtp() async {
    otpController.clear();
    setState(() {
      isLoading = false;
    });
  }

  void validateOtp(BuildContext context) {
    otpController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    emailid = routeArgs['emailid'];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter your otp "),
      ),
      backgroundColor: Colors.lightBlue[100],
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Enter your otp', style: TextStyle(fontSize: 20)),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 150,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: TextField(
                        maxLength: 6,
                        controller: otpController,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  OutlinedButton(
                      onPressed: () {
                        validateOtp(context);
                      },
                      child: const Text("submit"))
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text('otp has been sent to your email '),
            const SizedBox(
              height: 20,
            ),
            OutlinedButton(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                  });
                  reSentOtp();
                },
                child: isLoading == true
                    ? const CircularProgressIndicator()
                    : const Text("Resend otp"))
          ],
        ),
      ),
    );
  }
}
