part of 'profil_bloc.dart';

abstract class ProfilEvent extends Equatable {
  const ProfilEvent();

  @override
  List<Object?> get props => [];
}

class FirstConstructed extends ProfilEvent {
  const FirstConstructed();
}

class RetryRequested extends ProfilEvent {
  const RetryRequested();
}

class SaveRequested extends ProfilEvent {
  const SaveRequested();
}

class LogoutRequested extends ProfilEvent {
  const LogoutRequested();
}

class FormVornameChanged extends ProfilEvent {
  const FormVornameChanged(this.vorname);

  final String vorname;

  @override
  List<Object?> get props => [vorname];
}

class FormNachnameChanged extends ProfilEvent {
  const FormNachnameChanged(this.nachname);

  final String nachname;

  @override
  List<Object?> get props => [nachname];
}

class FormEmailChanged extends ProfilEvent {
  const FormEmailChanged(this.email);

  final String email;

  @override
  List<Object?> get props => [email];
}
