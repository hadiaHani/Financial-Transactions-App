import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:g_final_project/firebase/fb_firestore_controller.dart';
import 'package:g_final_project/models/note.dart';
import 'package:g_final_project/screens/custom_text_field.dart';
import 'package:g_final_project/screens/task/task_screen.dart';

class EditTaskScreen extends StatefulWidget {
  final Note note;
  final dynamic docid;

  const EditTaskScreen({
    super.key,
    required this.note,
    required this.docid,
  });

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _endDateController;
  late TextEditingController _startDataController;
  late String imprtant;
  late String status;
  late int selectedValue;

  void _handleRadioValueChange(int? value) {
    setState(() {
      selectedValue = value!;
      imprtant = value == 1 ? "Imprtant" : "Not Imprtant";
    });
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _descriptionController =
        TextEditingController(text: widget.note.description);
    _endDateController = TextEditingController(text: widget.note.endData);
    _startDataController =
        TextEditingController(text: widget.note.creationData);
    imprtant = widget.note.important;
    status = widget.note.status;
    selectedValue = widget.note.important == "Imprtant" ? 1 : 2;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _endDateController.dispose();
    _startDataController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Edit Task',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFB2EBF2),
                Color.fromARGB(255, 213, 224, 230),
              ],
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFB2EBF2),
              Color.fromARGB(255, 213, 224, 230),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomText(text: "Title"),
            const SizedBox(height: 5),
            CustomTextField(
                titleTextController: _titleController, hintText: "Title"),
            const SizedBox(height: 16.0),
            CustomText(text: "Detailes"),
            const SizedBox(height: 5),
            CustomTextField(
              titleTextController: _descriptionController,
              hintText: "Detailes",
              maxLines: 4,
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(text: "Creation Data"),
                CustomText(text: "Modification Data"),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: TextFormField(
                      controller: _startDataController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(7),
                        hintText: 'dd/mm/yy',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: TextFormField(
                      controller: _endDateController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(7),
                        hintText: 'dd/mm/yy',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            CustomText(text: "Importance"),
            const SizedBox(height: 5),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Row(children: [
                Radio(
                  value: 1,
                  groupValue: selectedValue,
                  onChanged: _handleRadioValueChange,
                ),
                const Text('Important'),
                Radio(
                  value: 2,
                  groupValue: selectedValue,
                  onChanged: _handleRadioValueChange,
                ),
                const Text('not Important')
              ]),
            ),
            /* TextFormField(
              decoration: const InputDecoration(
                labelText: 'الأهمية',
              ),
            ),*/
            const SizedBox(height: 5),
            CustomText(text: "Status"),
            const SizedBox(height: 5.0),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: DropdownButtonFormField<String>(
                value: widget.note.status,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(7),
                  hintText: 'Choose Status',
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'pending',
                    child: Text('pending'),
                  ),
                  DropdownMenuItem(
                    value: 'Underway',
                    child: Text('Underway'),
                  ),
                  DropdownMenuItem(
                    value: 'Done ',
                    child: Text('Done'),
                  ),
                  DropdownMenuItem(
                    value: 'Canceled',
                    child: Text('Canceled'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    status = value.toString();
                  });
                },
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(40, 45),
                  backgroundColor: Colors.blueGrey),
              onPressed: () => _performSave(),
              child: const Text(
                'Edit',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _performSave() {
    if (_checkData()) {
      _save();
    }
  }

  bool _checkData() {
    if (_titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _startDataController.text.isNotEmpty &&
        _endDateController.text.isNotEmpty &&
        status != "" &&
        imprtant != "") {
      return true;
    }
    showSnackBar('Enter required data', true);
    return false;
  }

  void _save() async {
    Note note = Note();
    note.title = _titleController.text;
    note.description = _descriptionController.text;
    note.id = FirebaseAuth.instance.currentUser!.uid;
    note.creationData = _startDataController.text;
    note.endData = _endDateController.text;
    note.important = imprtant;
    note.status = status;

    bool result = await FbFireStoreController().update(note, widget.docid);
    if (result) {
      _titleController.clear();
      _descriptionController.clear();
      _endDateController.clear();
      _startDataController.clear();
      showSnackBar('Edit success', false);

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const TaskScreen(),
      ));
    }
  }

  void showSnackBar(String message, [bool error = false]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
