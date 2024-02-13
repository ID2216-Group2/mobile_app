import 'package:flutter/material.dart';
import 'package:test_app/classes/group.dart';
import 'package:test_app/classes/people.dart';

class DropdownList extends StatefulWidget {
  const DropdownList({super.key, required this.groups, required this.expandedIndex});

  final List<Group> groups;
  final List<bool> expandedIndex;

  @override
  State<DropdownList> createState() => _DropdownListState();
}

class _DropdownListState extends State<DropdownList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          // Update the index of the expanded panel
          widget.expandedIndex[index] = isExpanded;
        });
      },
      children: widget.groups.asMap().entries.map<ExpansionPanel>((entry) {
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
          isExpanded: widget.expandedIndex[index],
        );
      }).toList(),
    );
  }
}
