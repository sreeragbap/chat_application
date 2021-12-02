import 'package:flutter/material.dart';
import 'package:messageapp/handlers/datas_tore.dart';
import 'package:messageapp/mqtt_connection.dart';
import 'package:provider/provider.dart';

class GroupsTabScreen extends StatefulWidget {
  const GroupsTabScreen({Key key}) : super(key: key);

  @override
  _GroupsTabScreenState createState() => _GroupsTabScreenState();
}

MQTTClientWrapper m = MQTTClientWrapper();

class _GroupsTabScreenState extends State<GroupsTabScreen> {
  @override
  Widget build(BuildContext context) {
    m = Provider.of<MQTTClientWrapper>(context);
    List users = m.users;
    List members = users.map((user) {
      return Employee(
          dept: user.dept,
          name: user.name,
          empNo: user.empNo,
          isSelected: false);
    }).toList();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.create),
        onPressed: () {
          Navigator.of(context)
              .pushNamed('newgroupscreen', arguments: {'members': members});
        },
      ),
      body: Center(
        child: Text(
          'Create your group.',
          style: TextStyle(
              letterSpacing: 5,
              wordSpacing: 5,
              color: Colors.grey[300],
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
