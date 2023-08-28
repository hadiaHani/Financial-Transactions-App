import 'package:flutter/material.dart';
import 'package:g_final_project/firebase/fb_auth_controller.dart';
import 'package:g_final_project/screens/financial_transactions/financial_transactions_screen.dart';

import 'package:g_final_project/screens/task/task_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        leading: IconButton(
            onPressed: () => FbAuthController().signOut(context),
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.black,
            )),
        title: const Text(
          'Home Page',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
          alignment: Alignment.topLeft,
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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TaskScreen(),
                      ),
                    );
                  },
                  child: const Text("Go to the tasks screen",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FinancialTransactionsPage(),
                      ),
                    );
                  },
                  child: const Text("Go to the financial transactions screen",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          )),
    );
  }
}
