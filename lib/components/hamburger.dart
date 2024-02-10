import 'package:flutter/material.dart';
import 'package:test_app/classes/people.dart';
import 'package:test_app/classes/group.dart';
import 'package:test_app/constants/colours.dart';
import 'package:test_app/utility/firebaseutils.dart';
import 'package:test_app/utility/globals.dart';

class Hamburger extends StatelessWidget {
  const Hamburger({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        FirebaseUtils.fetchUserByUserId(globalUser), 
        FirebaseUtils.fetchGroupsByUserId(globalUser),
      ]),
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
          final List<dynamic> results = snapshot.data!;
          final Person currentUser = results[0] as Person;
          final List<Group> userGroups = results[1] as List<Group>;

          return Drawer(
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
                ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    // Expand or collapse the panel when clicked
                  },
                  children: userGroups.map<ExpansionPanel>((Group group) {
                    return ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          title: Text(group.name),
                        );
                      },
                      body: Column(
                        children: group.people.map<Widget>((Person person) {
                          return ListTile(
                            title: Text(person.name),
                            subtitle: Text(person.email),
                            // Add more fields as needed
                          );
                        }).toList(),
                      ),
                      isExpanded: false, // Set to true if you want some panels to be initially expanded
                    );
                  }).toList(),
                )
              ],
            ),
          );
        }
      },
    );
  }
}
