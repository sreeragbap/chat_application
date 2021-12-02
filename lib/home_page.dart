import 'package:flutter/material.dart';
import 'package:messageapp/mqtt_connection.dart';
import 'package:messageapp/screens/tab_screens/alert_tabscreen.dart';
import 'package:messageapp/screens/tab_screens/debug.dart';
import 'package:messageapp/screens/tab_screens/groups_tabscreen.dart';
import 'package:messageapp/screens/tab_screens/members_tabscreen.dart';
import 'package:provider/provider.dart';
import 'package:system_shortcuts/system_shortcuts.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

dynamic userId;
MQTTClientWrapper m = MQTTClientWrapper();
TextEditingController mycontroller = TextEditingController();
bool isTrue = false;

class _MyHomePageState extends State<MyHomePage> {
  TabController tabController;

  // void sentOtp() async {}
  Future<bool> customFeature() async {
    await SystemShortcuts.home();
    return false;
  }

  logOut() {
    m.publishRegister('unregister');
    m.users.clear();
    m.userDetails.clear();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushNamedAndRemoveUntil(
        context,
        'loginscreen',
        (root) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    m = Provider.of<MQTTClientWrapper>(context);
    return DefaultTabController(
      initialIndex: 0,
      length: isTrue == false ? 3 : 4,
      child: WillPopScope(
        onWillPop: customFeature,
        child: Scaffold(
          appBar: AppBar(
            actions: [
              PopupMenuButton(
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      onTap: () {
                        setState(() {
                          isTrue = !isTrue;
                        });
                      },
                      child: isTrue
                          ? Row(
                              children: [
                                const Text('debug'),
                                const SizedBox(width: 10),
                                Icon(
                                  Icons.check_box,
                                  color: Colors.green[400],
                                )
                              ],
                            )
                          : const Text('debug'),
                      value: 'debug',
                    ),
                    PopupMenuItem(
                      onTap: () {},
                      child: const Text('settings'),
                      value: 'settings',
                    ),
                    PopupMenuItem(
                      onTap: () {
                        logOut();
                        print('done');
                      },
                      child: const Text('Logout'),
                      value: 'Logout',
                    ),
                  ];
                },
              ),
            ],
            title: const Text(
              "Nouncio",
              style: TextStyle(fontSize: 25),
            ),
            bottom: TabBar(
              onTap: (index) {},
              controller: tabController,
              tabs: isTrue == false
                  ? const [
                      Tab(
                        text: 'Members',
                        // icon: Icon(Icons.people),
                      ),
                      Tab(
                        text: 'Groups',
                        // icon: Icon(Icons.groups),
                      ),
                      Tab(
                        text: 'Alerts',
                        // icon: Icon(Icons.warning),
                      )
                    ]
                  : const [
                      Tab(text: 'Members'),
                      Tab(text: 'Groups'),
                      Tab(text: 'Alerts'),
                      Tab(text: 'Debug')
                    ],
            ),
          ),
          body: Column(children: <Widget>[
            Expanded(
              child: isTrue == false
                  ? const TabBarView(children: [
                      MembersTabScreen(),
                      GroupsTabScreen(),
                      AlertTabScreen(),
                    ])
                  : const TabBarView(children: [
                      MembersTabScreen(),
                      GroupsTabScreen(),
                      AlertTabScreen(),
                      Debug(),
                    ]),
            )
          ]),
        ),
      ),
    );
  }
}
