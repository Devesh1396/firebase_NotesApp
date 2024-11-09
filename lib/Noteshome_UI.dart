import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'NoteEditor_UI.dart';
import 'datamodel.dart';
import 'fb_service.dart';


class NoteUI extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text('Note Keeper', style: TextStyle(color: Colors.white)),
      ),
      body: StreamBuilder<List<Note>>(
        stream: _firestoreService.getNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Add Your First Note',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NoteEditor(isEdit: false),
                        ),
                      );
                    },
                    child: Text('Add Note'),
                  ),
                ],
              ),
            );
          } else {
            final notes = snapshot.data!;
            return ListView.separated(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                String noteId = note.id!;
                String formattedDate = DateFormat('dd/MM/yy').format(note.timestamp);

                return ListTile(
                  leading: Text('${index + 1}'),
                  title: Text(note.title),
                  subtitle: Text('${note.content}\nLast Modified: $formattedDate'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NoteEditor(noteId: noteId, isEdit: true),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _showDeleteConfirmDialog(context, noteId);
                        },
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => Divider(),
            );
          }
        },
      ),
      floatingActionButton: StreamBuilder<List<Note>>(
        stream: _firestoreService.getNotes(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NoteEditor(isEdit: false),
                  ),
                );
              },
              child: Icon(Icons.add, color: Colors.black),
              backgroundColor: Colors.white,
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, String noteId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          title: Text("Wait!"),
          content: Text("Are you sure you want to delete this note?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("No"),
            ),
            TextButton(
              onPressed: () async {
                await _firestoreService.deleteNote(noteId);
                Navigator.of(context).pop();
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }
}

