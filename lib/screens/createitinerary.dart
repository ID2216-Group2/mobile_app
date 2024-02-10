import 'dart:async';
import 'package:flutter/material.dart';
import 'package:test_app/classes/expenditure.dart';
import 'package:test_app/classes/itinerary.dart';
import 'package:test_app/classes/people.dart';
import 'package:test_app/constants/colours.dart';
import 'package:test_app/constants/categories.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class CreateItineraryState extends State<CreateItinerary> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedStartTime = TimeOfDay.now();
  TimeOfDay selectedEndTime = TimeOfDay.now();
  String? selectedCategory = CategoryName.none;
  String? selectedActivity;
  List<Person> persons = [];
  final TextEditingController dateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController activityController = TextEditingController();
  final MultiSelectController<Person> groupController = MultiSelectController();

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
                          persons = options
                              .toList()
                              .map((item) => item.value)
                              .toList()
                              .cast<Person>();
                        });
                      },
                      options: widget.group
                          .map((item) =>
                              ValueItem(label: item.name, value: item))
                          .toList(),
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
            Navigator.pop(
                context,
                Itinerary(
                    date: "${selectedDate.toLocal()}".split(' ')[0],
                    activity: activityController.text,
                    startTime: selectedStartTime,
                    endTime: selectedEndTime,
                    people: persons,
                    creator: widget.creator));
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
      {super.key, required this.group, required this.creator});
  final List<Person> group;
  final Person creator;
  @override
  State<CreateItinerary> createState() => CreateItineraryState();
}
