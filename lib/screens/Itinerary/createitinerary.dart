import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_app/classes/group.dart';
import 'package:test_app/classes/itinerary.dart';
import 'package:test_app/classes/people.dart';
import 'package:test_app/constants/colours.dart';
import 'package:test_app/constants/categories.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:test_app/utility/globals.dart';

class CreateItineraryState extends State<CreateItinerary> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedStartTime = TimeOfDay.now();
  TimeOfDay selectedEndTime = TimeOfDay.now();
  String? selectedCategory = CategoryName.none;
  String? selectedActivity;
  Group? selectedGroup;
  String? groupName;
  List<Person> persons = [];
  final TextEditingController dateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController activityController = TextEditingController();
  final TextEditingController groupController = TextEditingController();
  final TextEditingController groupNameController = TextEditingController();
  List<Person?> selectedUsers = [];
  //get selectedUsers => null;
  List<Person> allUsers = [];
  bool _usersFetched = false;
  List<String> selectedPeopleID = [];

  
  @override
  void initState() {
    super.initState();
    if (!_usersFetched) {
      fetchAllUsers();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      dateController.value = dateController.value.copyWith(
        text: "${selectedDate.toLocal()}".split(' ')[0],
        selection: TextSelection.collapsed(
            offset: "${selectedDate.toLocal()}".split(' ')[0].length),
      );
    }
  }

  Future<void> selectTime({required int x}) async {
    TimeOfDay? _picked =
        await showTimePicker(context: context, initialTime: selectedStartTime);
    if (_picked != null) {
      setState(() {
        if (x == 0) {
          selectedStartTime = _picked;
          startTimeController.value = startTimeController.value.copyWith(
            text: "${selectedStartTime.hour}:${selectedStartTime.minute.toString().padLeft(2, '0')}",
            selection: TextSelection.collapsed(
                offset: "${selectedStartTime.hour}:${selectedStartTime.minute.toString().padLeft(2, '0')}".length),
          );
        } else {
          selectedEndTime = _picked;
          endTimeController.value = endTimeController.value.copyWith(
          text: "${selectedEndTime.hour}:${selectedEndTime.minute.toString().padLeft(2, '0')}",
          selection: TextSelection.collapsed(
              offset: "${selectedEndTime.hour}:${selectedEndTime.minute.toString().padLeft(2, '0')}".length),
          );
        }
      });

      // startTimeController.text = selectedStartTime.format(context);
      // endTimeController.text = selectedEndTime.format(context);
    }
  }

  Future<void> fetchAllUsers() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      List<Person> fetchedUsers = [];
      querySnapshot.docs.forEach((doc) {
        fetchedUsers.add(Person(id: doc.id, name: doc['name']));
      });

      setState(() {
        _usersFetched = true;
        allUsers = fetchedUsers;
        
      });
      return;
    } catch (error) {
      print('Error fetching users: $error');
    }
  }

  void createGroup() {
    // Generate the bills array
    List<List<double>> bills = List.generate(selectedPeopleID.length, (_) => List.filled(selectedPeopleID.length, 0.0));

    // Convert the bills array to a JSON string
    String billsJson = jsonEncode(bills);
    
    // Create a new document in the "groups" collection with selected users
    FirebaseFirestore.instance.collection('group').add({
      'bill': billsJson,
      'name': groupName,
      'people': selectedPeopleID,
    }).then((value) {
      // Group created successfully
      print('Group created successfully with ID: ${value.id}');
    }).catchError((error) {
      // Error creating group
      print('Error creating group: $error');
    });
  }

  String getAmPm(TimeOfDay time) {
    return time.hour >= 12 ? 'pm' : 'am';
  }
  MultiSelectController<Person> multiSelectController = MultiSelectController();
  
List<Person?> selectedPersons =[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add an Itinerary'),
        backgroundColor: const Color(Colours.SECONDARY),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: dateController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Date',
                    hintText: "YYYY-MM-DD",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_month),
                      onPressed: () {
                        _selectDate(context);
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: startTimeController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Start Time',
                    hintText: "00:00",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.access_time_outlined),
                      onPressed: () {
                        selectTime(x: 0);
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: endTimeController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'End Time',
                    hintText: "00:00",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.access_time_outlined),
                      onPressed: () {
                        selectTime(x: 1);
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SizedBox(
                      child: TextField(
                    controller: activityController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Activity',
                    ),
                    keyboardType: TextInputType.number,
                  ))),

                  Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                    child: DropdownMenu(
                  expandedInsets: EdgeInsets.zero,
                  controller: groupController,
                  requestFocusOnTap: false,
                  label: const Text('Group'),
                  onSelected: (group) {
                    setState(() {
                      if (group is Group) {
                        selectedGroup = group;
                      } else if (group == 'add_group') {
                        // Handle the "Add Group" action
                        // For example, show a dialog to add a new group
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Create New Group"),
                              content: Text("Group members"),
                              actions: <Widget>[
                                TextField(
                                    controller: groupNameController,
                                    decoration: InputDecoration(
                                      labelText: 'Group Name',
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        groupName = value;
                                      });
                                    },
                                  ),
                                SizedBox(height: 16),
                                MultiSelectDropDown<Person>(
                                  fieldBackgroundColor: null,
                                  showClearIcon: false,
                                  controller: multiSelectController,
                                  onOptionSelected: (List<ValueItem<Person>> selectedOptions) {
                                  setState(() {
                                    // Extract the Person objects directly
                                    selectedPersons = selectedOptions.map((item) => item.value).toList();
                                      // Iterate through selectedPeople list to extract IDs
                                      for (Person? person in selectedPersons) {
                                        if (person != null && !selectedPeopleID.contains(person.id)) {
                                          selectedPeopleID.add(person.id);
                                        }
                                      }

                                  
                                  });},

                                  options: allUsers.map((user) => ValueItem(label: user.name, value: user)).toList(),
                                  maxItems: 4,
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
                                  searchEnabled: false,
                                  dropdownMargin: 2,
                                  onOptionRemoved: (index, option) {
                                    print('Removed: $option');
                                  },
                                ),
                                TextButton(
                                  onPressed: () {
                                    
                                    createGroup();
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Add group"),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    });
                  },
                  dropdownMenuEntries: [
                    ...widget.groups
                    .map((item) =>
                        DropdownMenuEntry(label: item.name, value: item))
                    .toList(),
                    DropdownMenuEntry(
                      label: 'Add Group',
                      value: 'add_group',
                    ),
                  ]
                ))),
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
            // Convert selected start and end times into DateTime objects for comparison
            DateTime startDateTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedStartTime.hour, selectedStartTime.minute);
            DateTime endDateTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedEndTime.hour, selectedEndTime.minute);
            //check whether endTime is later than startTime
            if (startDateTime.isAfter(endDateTime)) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Invalid Time'),
                    content: Text('Start time cannot be later than end time. Please choose valid times.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }
            else{
              //createGroup();
                  Navigator.pop(
                      context,
                      Itinerary(
                          date: "${selectedDate.toLocal()}".split(' ')[0],
                          activity: activityController.text,
                          startTime: "${selectedStartTime.hourOfPeriod}:${selectedStartTime.minute.toString().padLeft(2, '0')} ${getAmPm(selectedStartTime)}",
                          endTime: "${selectedEndTime.hourOfPeriod}:${selectedEndTime.minute.toString().padLeft(2, '0')} ${getAmPm(selectedEndTime)}",
                          people: (selectedGroup as Group).people.map((person) {
                            return person.id;
                          }).toList(),
                          creator: globalUser.id,
                          group: (selectedGroup as Group).id));
            }
          },
          // icon: const Icon(Icons.edit, color: Color(Colours.WHITECONTRAST)),
          label: const Text("Add Itinerary",
              style: TextStyle(color: Color(Colours.WHITECONTRAST))),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class CreateItinerary extends StatefulWidget {
  const CreateItinerary(
      {super.key, required this.groups, required this.creator});
  final List<Group> groups;
  final String creator;
  @override
  State<CreateItinerary> createState() => CreateItineraryState();
}
