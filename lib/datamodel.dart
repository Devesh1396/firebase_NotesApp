import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String? id;
  String? userId;
  String title;
  String content;
  DateTime timestamp;

  Note({
    this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.timestamp,
  });

  factory Note.fromFirestore(Map<String, dynamic> json, String id) {
    return Note(
      id: id,
      userId: json['userId'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'title': title,
      'content': content,
      'timestamp': timestamp,
    };
  }
}

class UserModel {
  String uid;
  String name;
  String email;
  String contact;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.contact,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      contact: json['contact'] as String,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'contact': contact,
    };
  }
}

