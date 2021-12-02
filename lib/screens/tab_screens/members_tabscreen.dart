import 'package:flutter/material.dart';
import 'package:messageapp/mqtt_connection.dart';
import 'package:provider/provider.dart';

class MembersTabScreen extends StatefulWidget {
  const MembersTabScreen({Key key}) : super(key: key);

  @override
  _MembersTabScreenState createState() => _MembersTabScreenState();
}

MQTTClientWrapper m = MQTTClientWrapper();

class _MembersTabScreenState extends State<MembersTabScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      m.prepareMqttClient();
    });
  }

  @override
  Widget build(BuildContext context) {
    m = Provider.of<MQTTClientWrapper>(context);
    List users = m.users;
    List filteredMessages = [];

    bool isSentToYou(List messages, dynamic user) {
      bool isTrue = false;
      for (final message in messages) {
        if (message.sendTo == m.userDetails[0].myId &&
            message.user == user.empNo) {
          isTrue = true;
        }
      }
      return isTrue;
    }

    int messageCount(List messages, dynamic user) {
      List allRecievedMessages = [];
      for (final message in messages) {
        if (message.sendTo == m.userDetails[0].myId &&
            message.user == user.empNo) {
          allRecievedMessages.add(message);
        }
        filteredMessages = allRecievedMessages
            .where((message) => message.user == user.empNo)
            .toList();
      }
      return filteredMessages.length;
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: users.map((user) {
            return ListTile(
              trailing: isSentToYou(m.messages, user)
                  ? CircleAvatar(
                      backgroundColor: Colors.green,
                      child: isSentToYou(m.messages, user)
                          ? Text(messageCount(m.messages, user).toString())
                          : const SizedBox(),
                      radius: 10,
                    )
                  : const SizedBox(),
              leading: const CircleAvatar(
                  child: Icon(Icons.person_outline_outlined)),
              title: Text(user.name) ?? const Text('null'),
              onTap: () {
                filteredMessages.clear();
                Navigator.of(context).pushNamed(
                  'chatscreen',
                  arguments: {'empno': user.empNo, 'username': user.name},
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
