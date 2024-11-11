abstract class SessionEvent {}

class AppStarted extends SessionEvent {}

class LoggedIn extends SessionEvent {
  final String uid;
  LoggedIn(this.uid);
}

class LoggedOut extends SessionEvent {}
