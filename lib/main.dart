import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_notesapp/LoginUI.dart';
import 'package:firebase_notesapp/bloc/event.dart';
import 'package:firebase_notesapp/bloc/session_bloc.dart';
import 'package:firebase_notesapp/bloc/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Noteshome_UI.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SessionBloc()..add(AppStarted()),
      child: MaterialApp(
        home: BlocBuilder<SessionBloc, SessionState>(
          builder: (context, state) {
            if (state is SessionAuthenticated) {
              return NoteUI();
            } else if (state is SessionUnauthenticated) {
              return LoginUI();
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
