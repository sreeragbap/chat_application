import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:messageapp/mqtt_connection.dart';
import 'package:provider/provider.dart';

class FileSendingScreen extends StatefulWidget {
  const FileSendingScreen({Key key}) : super(key: key);

  @override
  _FileSendingScreenState createState() => _FileSendingScreenState();
}

MQTTClientWrapper m = MQTTClientWrapper();

class _FileSendingScreenState extends State<FileSendingScreen> {
  @override
  Widget build(BuildContext context) {
    m = Provider.of<MQTTClientWrapper>(context);
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    List<File> files = routeArgs['files'];
    String userId = routeArgs['userId'];
    String userName = routeArgs['userName'];
    String responseType = routeArgs['responseType'];

    void sendSelectedFiles(List<File> files) {
      files.map((file) {
        // final bytes = File(file.path).readAsBytesSync();

        // String img64 = base64Encode(bytes);
        return m.sendMessage(file.toString(), userId, userName, responseType);
      }).toList();
      Navigator.pop(context);
    }

    return Scaffold(
      floatingActionButton: OutlinedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue[100])),
          child: const Text("send"),
          onPressed: () {
            sendSelectedFiles(files);
          }),
      appBar: AppBar(),
      body: GridView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(10),
          scrollDirection: Axis.vertical,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            childAspectRatio: 1.5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 50,
            maxCrossAxisExtent: 350,
          ),
          children: files.map((file) {
            return Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(width: 0.2, color: Colors.black),
                    color: const Color(0xffDBF9DB)),
                // color: const Color(0xffDBF9DB),
                child: Column(
                  children: [
                    Image.file(file),
                    Expanded(child: Text(file.toString().split('\\').last))
                  ],
                ));
          }).toList()),
      // ListView.builder(
      //   itemCount: files.length,
      //   itemBuilder: (context, index) {
      //     return ListTile(
      //       title: Text(files[index].name),
      //       subtitle: Row(
      //         children: [
      //           Text((files[index].size * 0.001).round().toString()),
      //           const Text(' Kb')
      //         ],
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
