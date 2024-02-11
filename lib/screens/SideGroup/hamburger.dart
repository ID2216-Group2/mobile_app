import 'package:flutter/material.dart';
import 'package:test_app/classes/people.dart';
import 'package:test_app/constants/colours.dart';
import 'package:test_app/constants/paddings.dart';
import 'package:test_app/utility/firebaseutils.dart';
import 'package:test_app/utility/globals.dart';
import 'package:test_app/screens/SideGroup/components/dropdownlist.dart';

class SideGroup extends StatelessWidget {
  const SideGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Person>(
      future: FirebaseUtils.fetchUserByUserId(globalUser),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Return a loading indicator while waiting for data
          return const Drawer(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          // Return an error message if an error occurs
          return const Drawer(
            child: Center(
              child: Text('Error loading user data'),
            ),
          );
        } else {
          // Once data is loaded, build the drawer with the retrieved user
          final Person currentUser = snapshot.data!;

          return Drawer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment
                  .end, // Align children to the end (right side)
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      UserAccountsDrawerHeader(
                        decoration: const BoxDecoration(
                          color: Color(Colours.SECONDARY),
                        ),
                        accountName: Text(currentUser.name),
                        accountEmail: Text(currentUser.email),
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
                      const DropdownList(),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: defaultPadding,
                      right: defaultPadding), // Add space below the FAB
                  child: FloatingActionButton.extended(
                    elevation: 12.0,
                    backgroundColor: const Color(Colours.PRIMARY),
                    onPressed: () async {},
                    icon: const Icon(
                      Icons.edit,
                      color: Color(Colours.WHITECONTRAST),
                    ),
                    label: const Text(
                      "Add Group",
                      style: TextStyle(color: Color(Colours.WHITECONTRAST)),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
