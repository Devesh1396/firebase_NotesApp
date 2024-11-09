import 'package:cloud_firestore/cloud_firestore.dart';
import 'datamodel.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addNote(Note note) async {
    await _firestore.collection('notes').add(note.toFirestore());
  }

  Stream<List<Note>> getNotes() {
    return _firestore.collection('notes')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      return Note.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    }).toList());
  }

  Future<void> updateNote(Note note) async {
    await _firestore.collection('notes').doc(note.id).update(note.toFirestore());
  }

  Future<void> deleteNote(String id) async {
    await _firestore.collection('notes').doc(id).delete();
  }

  Future<Note?> getNoteById(String noteId) async {
    final doc = await _firestore.collection('notes').doc(noteId).get();
    if (doc.exists) {
      return Note.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }


}
