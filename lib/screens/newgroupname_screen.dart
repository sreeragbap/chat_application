import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class NewGroupNameScreen extends StatefulWidget {
  const NewGroupNameScreen({Key key}) : super(key: key);

  @override
  _NewGroupNameScreenState createState() => _NewGroupNameScreenState();
}

TextEditingController groupNameController = TextEditingController();

class _NewGroupNameScreenState extends State<NewGroupNameScreen> {
  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final List selectedMembers = routeArgs['selectedmembers'];
    void onpressed() {
      Navigator.pushNamed(context, 'homepage',
          arguments: {'selectedmembers': selectedMembers});
    }

    return Scaffold(
      appBar: AppBar(
        title: const ListTile(
          title: Text(
            "New group",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          subtitle: Text(
            "Add Subject",
            style:
                TextStyle(fontSize: 10, color: Colors.white, letterSpacing: 2),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.blue[50],
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.blue[50],
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: groupNameController,
                              decoration: const InputDecoration(
                                  hintText: "Type group subject here"),
                            ),
                          ),
                          FloatingActionButton(
                              onPressed: onpressed,
                              child: const Icon(Icons.check)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 17),
                  child: Row(
                    children: [
                      const Text(
                        "Participants : ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(selectedMembers.length.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: GridView(
                    scrollDirection: Axis.vertical,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      childAspectRatio: 1.5,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 10,
                      maxCrossAxisExtent: 125,
                    ),
                    children: selectedMembers.map((member) {
                      return SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const CircleAvatar(
                              child: Icon(Icons.person_outline_outlined),
                            ),
                            Expanded(child: Text(member.name))
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
