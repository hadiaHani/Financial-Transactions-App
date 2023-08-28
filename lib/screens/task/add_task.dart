import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:g_final_project/firebase/fb_firestore_controller.dart';
import 'package:g_final_project/models/note.dart';
import 'package:g_final_project/screens/custom_text_field.dart';
import 'package:g_final_project/screens/task/task_screen.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  late TextEditingController _titleTextController;
  late TextEditingController _infoTextController;
  late TextEditingController startDateController;
  late TextEditingController endDateController;
  String? imprtant = "";
  String? status = "";

  int? selectedValue;

  void _handleRadioValueChange(int? value) {
    setState(() {
      selectedValue = value;
      imprtant = value == 1 ? "Imprtant" : "Not Imprtant";
    });
  }

  @override
  void initState() {
    super.initState();
    _titleTextController = TextEditingController();
    _infoTextController = TextEditingController();
    startDateController = TextEditingController();
    endDateController = TextEditingController();
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _infoTextController.dispose();
    startDateController.dispose();
    endDateController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Add Task',
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
                titleTextController: _titleTextController, hintText: "Title"),
            const SizedBox(height: 16.0),
            CustomText(text: "Detailes"),
            const SizedBox(height: 5),
            CustomTextField(
              titleTextController: _infoTextController,
              hintText: "Detailes",
              maxLines: 4,
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(text: "Creation Data"),
                CustomText(text: "delivery Data"),
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
                      controller: startDateController,
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
                      controller: endDateController,
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
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(7),
                  labelText: 'Choose Status',
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
                'Add',
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
    if (_titleTextController.text.isNotEmpty &&
        _infoTextController.text.isNotEmpty &&
        startDateController.text.isNotEmpty &&
        endDateController.text.isNotEmpty &&
        status != "" &&
        imprtant != "") {
      return true;
    }
    showSnackBar('Enter required data', true);
    return false;
  }

  void _save() async {
    Note note = Note();
    note.title = _titleTextController.text;
    note.description = _infoTextController.text;
    note.id = FirebaseAuth.instance.currentUser!.uid;
    note.creationData = startDateController.text;
    note.endData = endDateController.text;
    note.important = imprtant!;
    note.status = status!;

    bool result = await FbFireStoreController().create(
      note,
    );
    if (result) {
      _titleTextController.clear();
      _infoTextController.clear();
      endDateController.clear();
      startDateController.clear();
      showSnackBar('Add success', false);

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
