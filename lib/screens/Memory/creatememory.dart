import 'dart:async';
import 'dart:typed_data';
import 'package:test_app/classes/group.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:test_app/classes/memory.dart';
import 'package:test_app/classes/people.dart';
import 'package:test_app/constants/colours.dart';
import 'package:test_app/components/imagepickercard.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_app/utility/globals.dart';

class CreateMemoryState extends State<CreateMemory> {
  DateTime selectedDate = DateTime.now();
  String? selectedComments = "";
  Group? selectedGroup;
  List<Person> persons = [];
  List<String> imgList = [];

  final storageRef =
      FirebaseStorage.instanceFor(bucket: "gs://kth-mobile-app.appspot.com")
          .ref();

  final TextEditingController dateController = TextEditingController(
    text: "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}"
  );
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController commentsController = TextEditingController();
  final TextEditingController groupController = TextEditingController();

  List<Widget> imageSliders = [];

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    if (widget.groups.length == 1) {
      selectedGroup = widget.groups[0];
      groupController.text = widget.groups[0].name;
    }

    if (widget.activity != "") {
      
      nameController.text = widget.activity;
    }
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery, maxHeight: 500, maxWidth: 500);
    if (pickedFile != null) {
      Uint8List pickedFileBytes = await pickedFile.readAsBytes();
      var uuid = const Uuid().v4();
      final imageRef = storageRef.child(uuid);
      try {
        await imageRef.putData(pickedFileBytes);
        // final url = await imageRef.getDownloadURL();
        setState(() {
          imgList.add(uuid);
        });
      } on FirebaseException catch (e) {
        print(e);
      }
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
        title: const Text('Add a Memory'),
        backgroundColor: const Color(Colours.SECONDARY),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Title',
                        hintText: "Best trip ever!",
                      ),
                    ),
                  ),
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
                      padding: const EdgeInsets.only(
                          top: 5.0, bottom: 15.0, left: 15.0, right: 15.0),
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
                            .map((item) => DropdownMenuEntry(
                                label: item.name, value: item))
                            .toList(),
                      ))),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: commentsController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Comments',
                        hintText: "This place was amazing!",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: locationController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Location',
                        hintText: "Stockholm",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child:
                        ImagePickerCard(getImage: getImage, imageList: imgList),
                  ),
                ],
              ),
            ),
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
                Memory(
                  docid: "",
                  group: globalGroup,
                  date: "${selectedDate.toLocal()}".split(' ')[0],
                  mainImage:
                      imgList.isNotEmpty ? imgList[0] : "placeholder.png",
                  images: imgList.isNotEmpty ? imgList : [],
                  location: locationController.text,
                  title: nameController.text,
                  comments: commentsController.text,
                  people: persons.map((person) => person.id).toList(),
                  creator: globalUser.id,
                ));
          },
          // icon: const Icon(Icons.edit, color: Color(Colours.WHITECONTRAST)),
          label: const Text("Add Memory",
              style: TextStyle(color: Color(Colours.WHITECONTRAST))),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class CreateMemory extends StatefulWidget {
  const CreateMemory({super.key, required this.groups, required this.creator, this.activity=""});
  final List<Group> groups;
  final Person creator;
  final String activity;
  @override
  State<CreateMemory> createState() => CreateMemoryState();
}
