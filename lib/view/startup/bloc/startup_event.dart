part of 'startup_bloc.dart';

abstract class StartupEvent extends Equatable {
  const StartupEvent();

  @override
  List<Object?> get props => [];
}

class AppStarted extends StartupEvent {
  const AppStarted();
}

class StartupNavigationEvent extends StartupEvent {
  const StartupNavigationEvent(this.content);

  final StartupContent content;

  @override
  List<Object?> get props => [content];
}

class LoginEmailChanged extends StartupEvent {
  const LoginEmailChanged(this.email);

  final String email;

  @override
  List<Object?> get props => [email];
}

class LoginPasswordChanged extends StartupEvent {
  const LoginPasswordChanged(this.password);

  final String password;

  @override
  List<Object?> get props => [password];
}

class LoginSubmitted extends StartupEvent {
  const LoginSubmitted();
}

class AuthenticationFailed extends StartupEvent {
  const AuthenticationFailed(this.cause);

  final String cause;

  @override
  List<Object?> get props => [cause];
}
