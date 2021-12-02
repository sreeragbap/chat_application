import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messageapp/mqtt_connection.dart';
import 'package:messageapp/screens/chat/chat_screen.dart';
import 'package:messageapp/screens/chat/widgets/attatch_responsetypes.dart';
import 'package:messageapp/screens/file_sendingscreen.dart';
import 'package:messageapp/screens/login_screen.dart';
import 'package:messageapp/screens/newgroup_screen.dart';
import 'package:messageapp/screens/newgroupname_screen.dart';
import 'package:messageapp/screens/otp_screen.dart';
import 'package:messageapp/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MQTTClientWrapper()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(primarySwatch: Colors.red),
      title: "Nouncio",
      home: const SplashScreen(),
      routes: {
        'loginscreen': (ctx) => const LoginScreen(),
        'chatscreen': (ctx) => const ChatScreen(),
        'newgroupscreen': (ctx) => const NewGroupScreen(),
        'newgroupnamescreen': (ctx) => const NewGroupNameScreen(),
        'homepage': (ctx) => const MyHomePage(),
        'otpscreen': (ctx) => const otpscreen(),
        'filesendingscreeen': (ctx) => const FileSendingScreen(),
        'attatchresponsetypes': (ctx) => const AttatchRespondeTypes()
      },
    );
  }
}
