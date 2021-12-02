// import 'dart:io';

import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:messageapp/mqtt_connection.dart';
import 'package:messageapp/responsive.dart';
import 'package:messageapp/screens/chat/widgets/send_message_widget.dart';
import 'package:messageapp/screens/popupmenu_button.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key key,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

MQTTClientWrapper m = MQTTClientWrapper();
TextEditingController mycontroller = TextEditingController();
ScrollController scrollController = ScrollController(keepScrollOffset: true);
String userId;
String userName;
String responseType;
bool isMessageSelected;
int selectedIndex;
void _onPressed() {
  if (mycontroller.text != null &&
      mycontroller.text != "" &&
      mycontroller.text != "\n") {
    m.sendMessage(mycontroller.text, userId, userName, responseType);
  }

  mycontroller.clear();
  scrollToBottom();
}

scrollToBottom() {
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    if (scrollController.hasClients) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
  });
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    isMessageSelected = false;
    scrollToBottom();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    m = Provider.of<MQTTClientWrapper>(context);

    var focusNode = FocusNode();

    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final empNo = routeArgs['empno'];
    final user = routeArgs['username'];
    setState(() {
      userId = empNo;
      userName = user;
    });

    //filtering messages intividually..
    List filterTheMessages(List messages) {
      List filteredMessages = [];
      messages.map((message) {
        if (message.sendTo == userId && message.user == m.userDetails[0].myId ||
            message.sendTo == m.userDetails[0].myId && message.user == userId) {
          filteredMessages.add(message);
        }
      }).toList();
      return filteredMessages;
    }

    // Future<File> saveSlectedFiles(PlatformFile file) async {
    //   final fileStorage = await getApplicationDocumentsDirectory();
    //   final newFile = File([fileStorage.path], file.name);
    //   // File([fileStorage.path], '${file.name}');
    //   return newFile;
    // }

    Widget attatchResponseTypes() {
      List<String> responseTypes = [
        'ResponseTypes.Options__Yes_No',
        'ResponseTypes.Options__Maybe_Yes_No',
        'ResponseTypes.Options__Custom',
        'ResponseTypes.Options__True_False',
        'ResponseTypes.Options__A_B_C_D',
        'ResponseTypes.Rating__0_1_2_3_4_5',
        'ResponseTypes.Rating__1_2_3_4_5',
        'ResponseTypes.Rating__0_1_2_3_4_5_6_7_8_9_10',
        'ResponseTypes.Rating__1_2_3_4_5_6_7_8_9_10',
      ];
      return Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 95, left: 6, right: 6),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(25),
        ),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: responseTypes.map((resptype) {
            List respOptions = resptype.split('__');
            List resp = respOptions[1].split('_');

            return ListTile(
              title: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: resp.map((e) {
                    return Container(
                      padding: const EdgeInsets.all(5),
                      child: OutlinedButton(
                        onPressed: () {},
                        child: Text(e),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white)),
                      ),
                    );
                  }).toList(),
                ),
              ),
              onTap: () {
                setState(() {
                  responseType = resptype;
                });
              },
            );
          }).toList(),
        ),
      );
    }

    List<String> menuItems = ['select', 'search', 'unselect'];

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(child: Icon(Icons.person_outline_outlined)),
            const SizedBox(
              width: 10,
            ),
            Expanded(child: Text(userName)),
          ],
        ),
        leading: const BackButton(),
        actions: [
          PopupmenuButton(
            menuItems: menuItems,
            onselected: (item) {
              print(item);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text(userId),
            Expanded(
                flex: 1,
                child: Container(
                  margin: Responsive.isMobile(context)
                      ? const EdgeInsets.all(5)
                      : const EdgeInsets.all(25),
                  color: Colors.grey[200],
                  width: double.infinity,
                  child: ListView.builder(
                      controller: scrollController,
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: filterTheMessages(m.messages).length,
                      itemBuilder: (context, index) {
                        dynamic chatMessage =
                            filterTheMessages(m.messages)[index].contents;

                        bool isFromMe =
                            filterTheMessages(m.messages)[index].user ==
                                m.userDetails[0].myId;

                        // int selectedIndex(List<int> selectedIndexes) {
                        //   int selectedIndex;
                        //   selectedIndexes.map((e) {
                        //     selectedIndex = e;
                        //   });
                        //   return selectedIndex;
                        // }

                        return Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              gradient: selectedIndex == index
                                  ? LinearGradient(
                                      colors: [
                                        Colors.blue.withOpacity(0.2),
                                        Colors.blue.withOpacity(0.2)
                                      ],
                                    )
                                  : const LinearGradient(colors: [
                                      Colors.transparent,
                                      Colors.transparent
                                    ]),
                            ),
                            child: Container(
                              padding: const EdgeInsets.only(top: 0, bottom: 0),
                              child: Align(
                                alignment: isFromMe
                                    ? Alignment.topRight
                                    : Alignment.topLeft,
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black, width: 0.2),
                                      color: isFromMe
                                          ? const Color(0xffDBF9DB)
                                          : Colors.blue[100],
                                      borderRadius: isFromMe
                                          ? const BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              bottomLeft: Radius.circular(15),
                                              bottomRight: Radius.circular(15))
                                          : const BorderRadius.only(
                                              topRight: Radius.circular(15),
                                              bottomLeft: Radius.circular(15),
                                              bottomRight:
                                                  Radius.circular(15))),
                                  child: ListTile(
                                    onLongPress: () {
                                      setState(() {
                                        selectedIndex = index;
                                      });
                                    },
                                    onTap: () {
                                      setState(() {
                                        selectedIndex = 0 - index;
                                      });
                                    },
                                    dense: true,
                                    title: chatMessage == null
                                        ? const SizedBox()
                                        : Align(
                                            alignment: isFromMe
                                                ? Alignment.topRight
                                                : Alignment.topLeft,
                                            child:
                                                // chatMessage.type == 'Image'
                                                //     ? Image.file(_file)
                                                //     :
                                                Text(
                                              utf8.decode(
                                                base64.decode(chatMessage.body),
                                              ),
                                              style:
                                                  const TextStyle(fontSize: 15),
                                            ),
                                          ),
                                    subtitle: Align(
                                      alignment: isFromMe
                                          ? Alignment.topRight
                                          : Alignment.topLeft,
                                      child: Text(
                                        DateFormat('HH:mm')
                                            .format(DateTime
                                                .fromMillisecondsSinceEpoch(
                                                    int.parse(filterTheMessages(
                                                            m.messages)[index]
                                                        .receivedTimeStamp)))
                                            .toString(),
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ));
                      }),
                )),
            SendMessageWidget(
                sendMessage: _onPressed,
                message: mycontroller,
                userId: userId,
                userName: userName),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
