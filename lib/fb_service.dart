import 'package:cloud_firestore/cloud_firestore.dart';
import 'datamodel.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addNote(Note note) async {
    await _firestore.collection('notes').add(note.toFirestore());
  }

  Stream<List<Note>> getNotesForUser(String userId) {
    return FirebaseFirestore.instance
        .collection('notes')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      return Note.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    }).toList());
  }

  Future<void> updateNote(Note note) async {

    final noteDoc = await _firestore.collection('notes').doc(note.id).get();

    if (noteDoc.exists && noteDoc['userId'] == note.userId) {
      await _firestore.collection('notes').doc(note.id).update(note.toFirestore());
    } else {
      throw Exception('Note not found or no permission.');
    }
  }

  Future<void> deleteNote(String id, String userId) async {

    final noteDoc = await _firestore.collection('notes').doc(id).get();

    if (noteDoc.exists && noteDoc['userId'] == userId) {
      await _firestore.collection('notes').doc(id).delete();
    } else {
      throw Exception('Note not found or no permission.');
    }
  }


  Future<Note?> getNoteById(String noteId) async {
    final doc = await _firestore.collection('notes').doc(noteId).get();
    if (doc.exists) {
      return Note.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }


  Future<void> addUser(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toFirestore());
  }


}

// Stream<List<Note>> getNotes() {
//   return _firestore.collection('notes')
//       .orderBy('timestamp', descending: true)
//       .snapshots()
//       .map((snapshot) => snapshot.docs.map((doc) {
//     return Note.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
//   }).toList());
// }
/*Future<void> updateNote(Note note) async {
    await _firestore.collection('notes').doc(note.id).update(note.toFirestore());
  }*/
