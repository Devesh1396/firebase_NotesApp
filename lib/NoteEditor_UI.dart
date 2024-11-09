import 'package:flutter/material.dart';
import 'datamodel.dart';
import 'fb_service.dart';

class NoteEditor extends StatefulWidget {
  final String? noteId;
  final bool isEdit;

  NoteEditor({this.noteId, this.isEdit = false});

  @override
  _NoteEditorState createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.noteId != null && widget.noteId!.isNotEmpty) {
      _loadNoteData();
    }
  }

  // Fetching existing note data from Firestore
  Future<void> _loadNoteData() async {
    final noteData = await _firestoreService.getNoteById(widget.noteId!);
    if (noteData != null) {
      titleController.text = noteData.title;
      descriptionController.text = noteData.content;
    }
  }

  // Add or Update Note
  void _saveNote() async {
    String title = titleController.text;
    String description = descriptionController.text;

    if (title.isNotEmpty && description.isNotEmpty) {
      if (widget.isEdit) {
        final updatedNote = Note(
          id: widget.noteId,
          title: title,
          content: description,
          timestamp: DateTime.now(),
        );
        await _firestoreService.updateNote(updatedNote);
      } else {
        final newNote = Note(
          title: title,
          content: description,
          timestamp: DateTime.now(),
        );
        await _firestoreService.addNote(newNote);
      }
      titleController.clear();
      descriptionController.clear();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            padding: EdgeInsets.all(6.0),
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: TextField(
          controller: titleController,
          decoration: InputDecoration(
            hintText: widget.isEdit && titleController.text.isNotEmpty ? null : 'Title...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white),
          ),
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: Colors.white),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: descriptionController,
          decoration: InputDecoration(
            hintText: widget.isEdit && descriptionController.text.isNotEmpty ? null : 'Start typing...',
            border: InputBorder.none,
          ),
          maxLines: null,
          expands: true,
          keyboardType: TextInputType.multiline,
        ),
      ),
    );
  }
}
