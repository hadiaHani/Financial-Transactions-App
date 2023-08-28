import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:g_final_project/models/financial_transaction.dart';

class FbFireStoreFinaicialMovmentController {
  final FirebaseFirestore _instance = FirebaseFirestore.instance;

  Future<bool> create(FinancialTransactions financialTransactions) {
    return _instance
        .collection('financialTransactions')
        .add(financialTransactions.toMap())
        .then((value) {
      return true;
    }).onError((error, stackTrace) => false);
  }

  Stream<QuerySnapshot<FinancialTransactions>> read() async* {
    yield* _instance
        .collection('financialTransactions')
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .withConverter(
          fromFirestore: (snapshot, options) =>
              FinancialTransactions.fromMap(snapshot.data()!),
          toFirestore: (value, options) => value.toMap(),
        )
        .snapshots();
  }

  Future<bool> update(FinancialTransactions note, docid) {
    return _instance
        .collection('financialTransactions')
        .doc(docid)
        .update(note.toMap())
        .then((value) => true)
        .onError((error, stackTrace) => false);
  }

  Future<bool> delete(String id) {
    return _instance
        .collection('financialTransactions')
        .doc(id)
        .delete()
        .then((value) => true)
        .onError((error, stackTrace) => false);
  }
}
