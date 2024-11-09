import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String? id;
  String title;
  String content;
  DateTime timestamp;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.timestamp,
  });

  factory Note.fromFirestore(Map<String, dynamic> json, String id) {
    return Note(
      id: id,
      title: json['title'] as String,
      content: json['content'] as String,
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'content': content,
      'timestamp': timestamp,
    };
  }
}
