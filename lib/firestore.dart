import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // get
  final CollectionReference notes = FirebaseFirestore.instance.collection(
    'notes',
  );

  // create
  Future<void> addNote(String note) {
    return notes.add({'note': note, 'timestamp': Timestamp.now()});
  }

  // read
  Stream<QuerySnapshot> getNotesStream() {
    final notesStream = notes
        .orderBy('timestamp', descending: true)
        .snapshots();

    return notesStream;
  }
  // update

  // delete
}
