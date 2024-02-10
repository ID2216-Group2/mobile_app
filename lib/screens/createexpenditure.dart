import 'dart:async';
import 'package:flutter/material.dart';
import 'package:test_app/classes/expenditure.dart';
import 'package:test_app/classes/people.dart';
import 'package:test_app/constants/colours.dart';
import 'package:test_app/constants/categories.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:test_app/utility/globals.dart';

class CreateExpenditureState extends State<CreateExpenditure> {
  DateTime selectedDate = DateTime.now();
  String? selectedCategory = CategoryName.none;
  double? selectedAmount = 0.0;
  List<Person> persons = [];
  final TextEditingController dateController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
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
                Expenditure(
                    date: "${selectedDate.toLocal()}".split(' ')[0],
                    category: selectedCategory as String,
                    amount: double.parse(amountController.text),
                    icon: CategoryIcon.categoryNameToIconMap[selectedCategory]
                        as Icon,
                    people: persons.map((person) {
                      return person.id;
                    }).toList(),
                    creator: globalUser,
                    group: globalGroup));
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
  const CreateExpenditure(
      {super.key, required this.group, required this.creator});
  final List<Person> group;
  final String creator;
  @override
  State<CreateExpenditure> createState() => CreateExpenditureState();
}
