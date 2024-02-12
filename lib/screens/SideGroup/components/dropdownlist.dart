import 'package:flutter/material.dart';
import 'package:test_app/classes/group.dart';
import 'package:test_app/classes/people.dart';
import 'package:test_app/utility/globals.dart';
import 'package:test_app/utility/firebaseutils.dart';

class DropdownList extends StatefulWidget {
  const DropdownList({super.key});

  @override
  State<DropdownList> createState() => _DropdownListState();
}

class _DropdownListState extends State<DropdownList> {
  List<Group> userGroups = [];
  bool isLoading = true;
  List<bool> _expandedIndex = [];

  @override
  void initState() {
    super.initState();
    _getUserGroups();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child:
                CircularProgressIndicator(), // Show CircularProgressIndicator if isLoading is true
          )
        : ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                // Update the index of the expanded panel
                _expandedIndex[index] = isExpanded;
              });
            },
            children: userGroups.asMap().entries.map<ExpansionPanel>((entry) {
              final int index = entry.key;
              final Group group = entry.value;
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
                    );
                  }).toList(),
                ),
                isExpanded: _expandedIndex[index],
              );
            }).toList(),
          );
  }

  Future<void> _getUserGroups() async {
    List<Group> groups = await FirebaseUtils.fetchGroupsByUserId(globalUser);
    setState(() {
      userGroups = groups;
      _expandedIndex =
          List.generate(userGroups.length, (_) => false, growable: false);
      isLoading = false;
    });
  }
}
