import 'package:flutter/material.dart';

class NewGroupScreen extends StatefulWidget {
  const NewGroupScreen({Key key}) : super(key: key);

  @override
  _NewGroupScreenState createState() => _NewGroupScreenState();
}

class _NewGroupScreenState extends State<NewGroupScreen> {
  List selectedMembers;
  @override
  void initState() {
    selectedMembers = [];
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    List users = routeArgs['members'];
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (selectedMembers.isNotEmpty) {
              Navigator.pushNamed(context, 'newgroupnamescreen',
                  arguments: {'selectedmembers': selectedMembers});

              users.map((members) {
                members.isSelected = false;
              });
            }
          },
          child: const Icon(Icons.check),
        ),
        appBar: AppBar(
          title: const ListTile(
            title: Text(
              "New group",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            subtitle: Text(
              "Add Participants",
              style: TextStyle(
                  fontSize: 10, color: Colors.white, letterSpacing: 2),
            ),
          ),
        ),
        body: ListView.builder(
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: const CircleAvatar(
                    child: Icon(Icons.person_outline_outlined)),
                title: users[index].name == null
                    ? const Text('null')
                    : Text(users[index].name),
                trailing: users[index].isSelected
                    ? const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      )
                    : const Icon(
                        Icons.check_circle,
                        color: Colors.grey,
                      ),
                onTap: () {
                  setState(() {
                    users[index].isSelected = !users[index].isSelected;
                    if (users[index].isSelected == true) {
                      selectedMembers.add(users[index]);
                    } else if (users[index].isSelected == false) {
                      selectedMembers.remove(users[index]);
                    }
                  });
                },
              );
            }));
  }
}
