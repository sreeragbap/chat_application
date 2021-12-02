import 'package:flutter/material.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:messageapp/handlers/message_parsers.dart';

class AttatchRespondeTypes extends StatelessWidget {
  const AttatchRespondeTypes({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> responseTypes = EnumToString.toList(
      ResponseTypes.values,
    );
    return Scaffold(
        appBar: AppBar(
          title: const Text('Response Types'),
        ),
        body: ListView.separated(
            itemBuilder: (context, index) {
              responseTypes.removeWhere((element) => !element.contains('__'));
              List respOptions = responseTypes[index].split('__');
              List response = respOptions[1].split('_');
              return ListTile(
                title: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: response.map((resp) {
                      return Container(
                        padding: const EdgeInsets.all(5),
                        child: TextButton(
                          onPressed: () {},
                          child: Text(resp),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.blue[100])),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                onTap: () {
                  // setState(() {
                  //   responseType = resptype;
                  // });
                },
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(
                  height: 0,
                  thickness: 0.4,
                ),
            itemCount: responseTypes.length - 1));
  }
}
