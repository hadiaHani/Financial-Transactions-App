import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:g_final_project/models/note.dart';

class FbFireStoreController {
  final FirebaseFirestore _instance = FirebaseFirestore.instance;

  Future<bool> create(Note note) {
    return _instance.collection('Notes').add(note.toMap()).then((value) {
      return true;
    }).onError((error, stackTrace) => false);
  }

  Stream<QuerySnapshot<Note>> read() async* {
    yield* _instance
        .collection('Notes')
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .withConverter(
          fromFirestore: (snapshot, options) => Note.fromMap(snapshot.data()!),
          toFirestore: (value, options) => value.toMap(),
        )
        .snapshots();
  }

  Future<bool> update(Note note, docid) {
    return _instance
        .collection('Notes')
        .doc(docid)
        .update(note.toMap())
        .then((value) => true)
        .onError((error, stackTrace) => false);
  }

  Future<bool> delete(String id) {
    return _instance
        .collection('Notes')
        .doc(id)
        .delete()
        .then((value) => true)
        .onError((error, stackTrace) => false);
  }
}
