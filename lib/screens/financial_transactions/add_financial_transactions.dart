import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:g_final_project/firebase/fb_firestore_financial_movment_controller.dart';
import 'package:g_final_project/models/financial_transaction.dart';
import 'package:g_final_project/screens/custom_text_field.dart';
import 'package:g_final_project/screens/financial_transactions/financial_transactions_screen.dart';

class AddFinancialTransactionsPage extends StatefulWidget {
  const AddFinancialTransactionsPage({super.key});

  @override
  State<AddFinancialTransactionsPage> createState() =>
      _AddFinancialTransactionsPageState();
}

class _AddFinancialTransactionsPageState
    extends State<AddFinancialTransactionsPage> {
  late TextEditingController _titleTextController;
  late TextEditingController _infoTextController;
  late TextEditingController valueController;
  late TextEditingController dateController;
  String? movmentType = "";
  String? currency = "";

  int? selectedValue;

  void _handleRadioValueChange(int? value) {
    setState(() {
      selectedValue = value;
      movmentType = value == 1 ? "export" : "import";
    });
  }

  @override
  void initState() {
    super.initState();
    _titleTextController = TextEditingController();
    _infoTextController = TextEditingController();
    valueController = TextEditingController();
    dateController = TextEditingController();
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _infoTextController.dispose();
    valueController.dispose();
    dateController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Add financial movment',
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
            CustomText(text: "movment Type"),
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
                const Text('export'),
                Radio(
                  value: 2,
                  groupValue: selectedValue,
                  onChanged: _handleRadioValueChange,
                ),
                const Text('import')
              ]),
            ),
            const SizedBox(height: 5),
            CustomText(text: "Title"),
            const SizedBox(height: 5),
            CustomTextField(
                titleTextController: _titleTextController, hintText: "Title"),
            const SizedBox(height: 16.0),
            Row(children: [
              CustomText(text: "financial value"),
              const SizedBox(width: 70.0),
              CustomText(text: "currency"),
            ]),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: TextFormField(
                      controller: valueController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(7),
                        hintText: 'value',
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
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(7),
                        labelText: 'Choose currency',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Dollar',
                          child: Text('Dollar'),
                        ),
                        DropdownMenuItem(
                          value: 'Dinar',
                          child: Text('Dinar'),
                        ),
                        DropdownMenuItem(
                          value: 'Shekel ',
                          child: Text('Shekel'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          currency = value.toString();
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            CustomText(text: "Movment History"),
            const SizedBox(height: 5.0),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: TextFormField(
                controller: dateController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(7),
                  hintText: 'dd/mm/yy',
                ),
              ),
            ),
            const SizedBox(height: 5.0),
            CustomText(text: "Comments"),
            const SizedBox(height: 5),
            CustomTextField(
              titleTextController: _infoTextController,
              hintText: "Enter Detailes",
              maxLines: 4,
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
        valueController.text.isNotEmpty &&
        dateController.text.isNotEmpty &&
        currency != "" &&
        movmentType != "") {
      return true;
    }
    showSnackBar('Enter required data', true);
    return false;
  }

  void _save() async {
    FinancialTransactions transactions = FinancialTransactions();
    transactions.title = _titleTextController.text;
    transactions.description = _infoTextController.text;
    transactions.id = FirebaseAuth.instance.currentUser!.uid;
    transactions.value = valueController.text;
    transactions.movmentHistory = dateController.text;
    transactions.movmentType = movmentType!;
    transactions.currency = currency!;

    bool result = await FbFireStoreFinaicialMovmentController().create(
      transactions,
    );
    if (result) {
      _titleTextController.clear();
      _infoTextController.clear();
      dateController.clear();
      valueController.clear();
      showSnackBar('Add success', false);

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const FinancialTransactionsPage(),
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
