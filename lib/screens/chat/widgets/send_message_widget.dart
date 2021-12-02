import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:messageapp/responsive.dart';

class SendMessageWidget extends StatelessWidget {
  String userId;
  String userName;
  void Function() sendMessage;
  TextEditingController message;
  SendMessageWidget(
      {Key key, this.sendMessage, this.message, this.userId, this.userName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var focusNode = FocusNode();

    void loadPickedFiles(List<File> files) {
      Navigator.pushNamed(context, 'filesendingscreeen', arguments: {
        'files': files,
        'userId': userId,
        'userName': userName,
        'responseType': ''
      });
    }

    void pickFiles() async {
      File _file;
      List<File> selectedFiles = [];
      final pickedFiles = await FilePicker.platform
          .pickFiles(allowMultiple: true, dialogTitle: 'hai');
      if (pickedFiles == null) return;
      for (PlatformFile file in pickedFiles.files) {
        _file = File(file.path);
        selectedFiles.add(_file);
      }

      print(_file);
      loadPickedFiles(selectedFiles);
    }

    Widget chatAttatchSection() {
      return Stack(
        children: [
          Row(
            children: [
              const Expanded(
                child: SizedBox(
                  width: 7,
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 10, right: 6, bottom: 10),
                margin: EdgeInsets.only(
                  bottom: Responsive.isMobile(context) ? 95 : 115,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[400], width: 0.5),
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent.withOpacity(0.1),
                      Colors.transparent.withOpacity(0.1)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(55),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () async {
                          pickFiles();

                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.image,
                          color: Colors.blue,
                          size: 30,
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'attatchresponsetypes');
                        },
                        icon: const Icon(
                          Icons.r_mobiledata,
                          color: Colors.blue,
                          size: 60,
                        )),
                  ],
                ),
              ),
              const SizedBox(
                width: 80,
              ),
            ],
          ),
          Positioned(
            bottom: 35,
            right: 87,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.attach_file,
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      );
    }

    return Container(
      margin: const EdgeInsets.all(3),
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        children: [
          Expanded(
            child: RawKeyboardListener(
              includeSemantics: false,
              autofocus: true,
              focusNode: focusNode,
              onKey: (event) {
                if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
                  sendMessage;
                  message.clear();
                }
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 0.3),
                    borderRadius: BorderRadius.circular(30)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        maxLines: Responsive.isMobile(context) ? 5 : 3,
                        minLines: 1,
                        // keyboardType: TextInputType.multiline,
                        textInputAction: Responsive.isMobile(context)
                            ? TextInputAction.none
                            : TextInputAction.continueAction,
                        controller: message,
                        decoration: const InputDecoration(
                          hintText: "Type a message",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                              enableDrag: true,
                              isDismissible: true,
                              barrierColor: Colors.transparent,
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) {
                                return chatAttatchSection();
                                // attatchType == 'responseTypes'
                                //     ? attatchResponseTypes()
                                //     : chatAttatchSection();
                              });
                        },
                        icon: const Icon(Icons.attach_file))
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          FloatingActionButton(
            onPressed: sendMessage,
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
