import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_app/classes/expenditure.dart';
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
  List<Person> persons = [];
  final TextEditingController dateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController activityController = TextEditingController();
  final TextEditingController groupController = TextEditingController();

  get selectedUsers => null;
  List<Person> allUsers = [];
  bool _usersFetched = false;
  
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
            text: "${selectedStartTime}".split(' ')[0],
            selection: TextSelection.collapsed(
                offset: "${selectedStartTime}".split(' ')[0].length),
          );
        } else {
          selectedEndTime = _picked;
          endTimeController.value = endTimeController.value.copyWith(
            text: "${selectedEndTime}".split(' ')[0],
            selection: TextSelection.collapsed(
                offset: "${selectedEndTime}".split(' ')[0].length),
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
      debugPrint("qqqq");
      List<Person> fetchedUsers = [];
      querySnapshot.docs.forEach((doc) {
        debugPrint(doc['name']);
        fetchedUsers.add(Person(id: doc.id, name: doc['name']));
      });

      setState(() {
        debugPrint("ttttttttttttttttt");
        _usersFetched = true;
        allUsers = fetchedUsers;
        
      });
      return;
    } catch (error) {
      print('Error fetching users: $error');
    }
  }

  void createGroup() {
    // Create a new document in the "groups" collection with selected users
    FirebaseFirestore.instance.collection('groups').add({
      'users': selectedUsers,
      'createdAt': Timestamp.now(),
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
//   Widget buildDropdown() {
//   // return MultiSelectDropDown<String>(
//   //   items: allUsers.map((user) {
//   //     return MultiSelectItem<String>(value: user, label: user);
//   //   }).toList(),
//   //   onConfirm: (List<String> selectedValues) {
//   //     setState(() {
//   //       selectedUsers.clear(); // Clear previous selection
//   //       selectedUsers.addAll(selectedValues); // Add new selection
//   //     });
//   //   },
//   //   buttonBarColor: Colors.blue, // Customize button bar color if needed
//   //   checkBoxColor: Colors.blue, // Customize checkbox color if needed
//   //   titleTextColor: Colors.blue, // Customize title text color if needed
//   // );


//    return MultiSelectDropDown<Person>(
//     fieldBackgroundColor: null,
//     showClearIcon: false,
//     controller: groupController,
//     onOptionSelected: (List<ValueItem<Person>> selectedOptions) {
//     setState(() {
//       // Extract the Person objects directly
//       List<Person?> selectedPersons = selectedOptions.map((item) => item.value).toList();
//       // Handle selected options
//     });},

//     options: allUsers.map((user) => ValueItem(label: user.name, value: user)).toList(),
//     maxItems: 4,
//     selectionType: SelectionType.multi,
//     chipConfig: const ChipConfig(
//         wrapType: WrapType.wrap,
//         backgroundColor: Color(Colours.p500)),
//     optionTextStyle: const TextStyle(fontSize: 16),
//     selectedOptionIcon: const Icon(
//       Icons.check_circle,
//       color: Color(Colours.p500),
//     ),
//     selectedOptionTextColor: Colors.blue,
//     searchEnabled: false,
//     dropdownMargin: 2,
//     onOptionRemoved: (index, option) {
//       print('Removed: $option');
//     },
//   );
// }

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

                  // FutureBuilder(
                  //   future: _usersFetched ? null : fetchAllUsers(), // Only call fetchAllUsers() if _usersFetched is false
                  //   builder: (context, snapshot) {
                  //     if (snapshot.connectionState == ConnectionState.waiting) {
                  //       return Center(child: CircularProgressIndicator());
                  //     } else if (snapshot.hasError) {
                  //       return Center(child: Text('Error: ${snapshot.error}'));
                  //     } else {
                  //       //List<String> users = snapshot.data as List<String>;
                  //       return buildDropdown();
                  //     }
                  //   },
                  // ),

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
                      selectedGroup = group;
                    });
                  },
                  dropdownMenuEntries: widget.groups
                    .map((item) =>
                        DropdownMenuEntry(label: item.name, value: item))
                    .toList(),
                ))),

        //           Padding(
        // padding: const EdgeInsets.all(16.0),
        // child: Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Text(
        //       'Select Users:',
        //       style: TextStyle(fontSize: 18),
        //     ),
        //     SizedBox(height: 8),
        //     DropdownButtonFormField<String>(
        //       items: allUsers.map((user) {
        //         return DropdownMenuItem(
        //           value: user,
        //           child: Text(user),
        //         );
        //       }).toList(),
        //       onChanged: (String? selectedUser) {
        //         if (selectedUser != null) {
        //           setState(() {
        //             selectedUsers.add(selectedUser);
        //           });
        //         }
        //       },
        //       value: null,
        //       hint: Text('Select Users'),
        //     ),
        //     SizedBox(height: 16),
        //     ElevatedButton(
        //       onPressed: () {
        //         createGroup();
        //       },
        //       child: Text('Create Group'),
        //     ),
        //   ],
        // ),)
              // Padding(
              //   padding: const EdgeInsets.only(
              //       top: 5.0, bottom: 15.0, left: 15.0, right: 15.0),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       const Text('People Involved'),
              //       const SizedBox(
              //         height: 4,
              //       ),
              //       MultiSelectDropDown<Person>(
              //         fieldBackgroundColor: null,
              //         showClearIcon: false,
              //         controller: groupController,
              //         onOptionSelected: (options) {
              //           setState(() {
              //             persons = options
              //                 .toList()
              //                 .map((item) => item.value)
              //                 .toList()
              //                 .cast<Person>();
              //           });
              //         },
              //         options: widget.group
              //             .map((item) =>
              //                 ValueItem(label: item.name, value: item))
              //             .toList(),
              //         maxItems: 4,
              //         selectionType: SelectionType.multi,
              //         chipConfig: const ChipConfig(
              //             wrapType: WrapType.wrap,
              //             backgroundColor: Color(Colours.p500)),
              //         optionTextStyle: const TextStyle(fontSize: 16),
              //         selectedOptionIcon: const Icon(
              //           Icons.check_circle,
              //           color: Color(Colours.p500),
              //         ),
              //         selectedOptionTextColor: Colors.blue,
              //         searchEnabled: false,
              //         dropdownMargin: 2,
              //         onOptionRemoved: (index, option) {
              //           print('Removed: $option');
              //         },
              //       ),
              //     ],
              //   ),
              // ),
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
            createGroup();
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
