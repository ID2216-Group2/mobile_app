import 'dart:async';
import 'package:flutter/material.dart';
import 'package:test_app/classes/group.dart';
import 'package:test_app/classes/people.dart';
import 'package:test_app/constants/colours.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:test_app/utility/globals.dart';
import 'package:test_app/utility/firebaseutils.dart';


class CreateGroupState extends State<CreateGroup> {
  List<Person> persons = [];
  List<Person> _otherUsers = [];
  final TextEditingController nameController = TextEditingController();
  final MultiSelectController<Person> groupController = MultiSelectController();

  @override
  void initState() {
    super.initState();
    _setOtherUsers();
    _setCurrentUser();
  }

  Future<void> _setOtherUsers() async {
    List<Person> otherUsers = await FirebaseUtils.fetchOtherUsersByUserId(globalUser);
    setState(() {
      _otherUsers = otherUsers;
    });
  }

  Future<void> _setCurrentUser() async {
    Person currentUser = await FirebaseUtils.fetchUserByUserId(globalUser);
    setState(() {
      persons = [currentUser];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add an Expenditure'),
        backgroundColor: const Color(Colours.SECONDARY),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
          child: Column(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SizedBox(
                      child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Group Name',
                    ),
                    keyboardType: TextInputType.text,
                  ))),
              Padding(
                padding: const EdgeInsets.only(
                    top: 5.0, bottom: 15.0, left: 15.0, right: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('People Involved'),
                    const SizedBox(
                      height: 4,
                    ),
                    MultiSelectDropDown<Person>(
                      fieldBackgroundColor: null,
                      showClearIcon: false,
                      controller: groupController,
                      onOptionSelected: (options) {
                        setState(() {
                          persons = persons + options
                              .toList()
                              .map((item) => item.value)
                              .toList()
                              .cast<Person>();
                        });
                      },
                      options: _otherUsers
                          .map((users) =>
                              ValueItem(label: users.name, value: users))
                          .toList(),
                      selectionType: SelectionType.multi,
                      chipConfig: const ChipConfig(
                          wrapType: WrapType.wrap,
                          backgroundColor: Color(Colours.p500)),
                      optionTextStyle: const TextStyle(fontSize: 16),
                      selectedOptionIcon: const Icon(
                        Icons.check_circle,
                        color: Color(Colours.p500),
                      ),
                      selectedOptionTextColor: Colors.blue,
                      searchEnabled: true,
                      dropdownMargin: 2,
                      onOptionRemoved: (index, option) {
                        print('Removed: $option');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width - 50,
        child: FloatingActionButton.extended(
          elevation: 0,
          backgroundColor: const Color(Colours.PRIMARY),
          onPressed: () {
            int size = persons.length;
            List<List<double>> bills = List.generate(size, (_) => List.filled(size, 0));
            Navigator.pop(
                context,
                Group(
                    name: nameController.text,
                    people: persons,
                    bills: bills));
          },
          // icon: const Icon(Icons.edit, color: Color(Colours.WHITECONTRAST)),
          label: const Text("Add Group",
              style: TextStyle(color: Color(Colours.WHITECONTRAST))),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  State<CreateGroup> createState() => CreateGroupState();
}
