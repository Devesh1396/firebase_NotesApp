import 'package:firebase_notesapp/bloc/event.dart';
import 'package:firebase_notesapp/bloc/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_notesapp/session_service.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {

  final SessionManager _sessionManager = SessionManager();

  SessionBloc() : super(SessionUnauthenticated()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
  }

  void _onAppStarted(AppStarted event, Emitter<SessionState> emit) async {
    final uid = await _sessionManager.getUid();
    if (uid != null) {
      emit(SessionAuthenticated(uid));
    } else {
      emit(SessionUnauthenticated());
    }
  }

  void _onLoggedIn(LoggedIn event, Emitter<SessionState> emit) async {
    await _sessionManager.setUid(event.uid);
    emit(SessionAuthenticated(event.uid));
  }

  void _onLoggedOut(LoggedOut event, Emitter<SessionState> emit) async {
    emit(SessionLoading());
    await _sessionManager.clearSession();
    emit(SessionUnauthenticated());
  }
}
