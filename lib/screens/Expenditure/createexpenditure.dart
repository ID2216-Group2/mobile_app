import 'dart:async';
import 'package:flutter/material.dart';
import 'package:test_app/classes/expenditure.dart';
import 'package:test_app/classes/group.dart';
import 'package:test_app/constants/colours.dart';
import 'package:test_app/constants/categories.dart';
import 'package:test_app/utility/globals.dart';

class CreateExpenditureState extends State<CreateExpenditure> {
  DateTime selectedDate = DateTime.now();
  String? selectedCategory = CategoryName.none;
  double? selectedAmount = 0.0;
  Group? selectedGroup;
  final TextEditingController dateController = TextEditingController(
    text: "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}"
  );
  final TextEditingController amountController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController groupController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.groups.length == 1) {
      selectedGroup = widget.groups[0];
      groupController.text = widget.groups[0].name;
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
                child: TextField(
                  textCapitalization: TextCapitalization.sentences,
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
                  child: SizedBox(
                      child: TextField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: amountController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Amount',
                    ),
                    keyboardType: TextInputType.number,
                  ))),
              Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SizedBox(
                      child: DropdownMenu(
                    expandedInsets: EdgeInsets.zero,
                    initialSelection: CategoryName.none,
                    controller: categoryController,
                    requestFocusOnTap: false,
                    label: const Text('Category'),
                    onSelected: (category) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    dropdownMenuEntries: CategoryName.possibleCategories
                        .map<DropdownMenuEntry<String>>((String category) {
                      return DropdownMenuEntry<String>(
                        value: category,
                        label: category,
                      );
                    }).toList(),
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
                      selectedGroup = group;
                    });
                  },
                  dropdownMenuEntries: widget.groups
                    .map((item) =>
                        DropdownMenuEntry(label: item.name, value: item))
                    .toList(),
                ))),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width - 50,
        child: FloatingActionButton.extended(
          elevation: 0,
          backgroundColor: const Color(Colours.PRIMARY),
          onPressed: () {
            Navigator.pop(
                context,
                Expenditure(
                    date: "${selectedDate.toLocal()}".split(' ')[0],
                    category: selectedCategory as String,
                    amount: double.parse(amountController.text),
                    icon: CategoryIcon.categoryNameToIconMap[selectedCategory]
                        as Icon,
                    people: (selectedGroup as Group).people.map((person) {
                      return person.id;
                    }).toList(),
                    creator: globalUser.id,
                    group: (selectedGroup as Group).id));
          },
          // icon: const Icon(Icons.edit, color: Color(Colours.WHITECONTRAST)),
          label: const Text("Add Expenditure",
              style: TextStyle(color: Color(Colours.WHITECONTRAST))),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class CreateExpenditure extends StatefulWidget {
  const CreateExpenditure({
    super.key, 
    required this.groups, 
    required this.creator,
    this.title="",
  });
  final List<Group> groups;
  final String creator;
  final String title;

  @override
  State<CreateExpenditure> createState() => CreateExpenditureState();
}
