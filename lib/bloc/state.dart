abstract class SessionState {}

class SessionUnauthenticated extends SessionState {}

class SessionAuthenticated extends SessionState {
  final String uid;
  SessionAuthenticated(this.uid);
}

class SessionLoading extends SessionState {}
