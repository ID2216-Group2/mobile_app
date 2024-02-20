import 'package:flutter/material.dart';
import 'package:test_app/classes/people.dart';
import 'package:test_app/classes/group.dart';
import 'package:test_app/constants/colours.dart';
import 'package:test_app/constants/paddings.dart';
import 'package:test_app/screens/Login/login_screen.dart';
import 'package:test_app/utility/firebaseutils.dart';
import 'package:test_app/utility/globals.dart';
import 'package:test_app/screens/SideGroup/components/dropdownlist.dart';
import 'package:test_app/screens/SideGroup/components/creategroup.dart';

class SideGroup extends StatefulWidget {
  const SideGroup({super.key});
  @override
  SideGroupState createState() => SideGroupState();
}

class SideGroupState extends State<SideGroup> {
  late Person currentUser;
  List<Group> userGroups = [];
  bool userHasLoaded = false;
  bool groupsHasLoaded = false;

  @override
  void initState() {
    super.initState();

    FirebaseUtils.fetchUserByUserId(globalUser.id).then((user) {
      setState(() {
        currentUser = user;
        userHasLoaded = true;
      });
    });

    FirebaseUtils.fetchGroupsByUserId(globalUser.id, true).then((groups) {
      setState(() {
        userGroups = groups;
        groupsHasLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!userHasLoaded) {
      return const Drawer(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: ListView(
                children: [
                  UserAccountsDrawerHeader(
                    decoration: const BoxDecoration(
                      color: Color(Colours.SECONDARY),
                    ),
                    accountName: Text(currentUser.name),
                    accountEmail: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(currentUser.email),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => LoginScreen()
                              ));
                            },
                            child: const Row(
                              children: [
                                Icon(Icons.logout),
                                Text("Logout"),
                                SizedBox(width: 10),
                              ],
                            ),
                          )
                        ]),
                    currentAccountPicture: const CircleAvatar(
                      child: ClipOval(),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                      left: defaultPadding,
                      bottom: defaultPadding,
                    ),
                    child: Text(
                      "Your Groups",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  groupsHasLoaded
                      ? DropdownList(
                          groups: userGroups,
                          expandedIndex: List.generate(
                              userGroups.length, (_) => false,
                              growable: false),
                        )
                      : const SizedBox(
                          width: 54,
                          height: 54,
                          child: Center(child: CircularProgressIndicator()),
                        )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: defaultPadding,
                  right: defaultPadding), // Add space below the FAB
              child: FloatingActionButton.extended(
                elevation: 12.0,
                backgroundColor: const Color(Colours.PRIMARY),
                icon: const Icon(
                  Icons.edit,
                  color: Color(Colours.WHITECONTRAST),
                ),
                label: const Text(
                  "Add Group",
                  style: TextStyle(color: Color(Colours.WHITECONTRAST)),
                ),
                onPressed: () async {
                  final Group? newGroup = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateGroup()));

                  if (newGroup != null) {
                    setState(() {
                      groupsHasLoaded = false;
                    });
                    FirebaseUtils.uploadData("group", newGroup.toDbObject())
                        .then((_) {
                      FirebaseUtils.fetchGroupsByUserId(globalUser.id, true)
                          .then((groups) {
                        setState(() {
                          userGroups = groups;
                          groupsHasLoaded = true;
                        });
                      });
                    });
                  }
                },
              ),
            ),
          ],
        ),
      );
    }
  }
}
