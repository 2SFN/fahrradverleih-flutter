import 'package:fahrradverleih/api/rad_api.dart';
import 'package:fahrradverleih/view/profil/bloc/profil_bloc.dart';
import 'package:fahrradverleih/view/startup/startup_page.dart';
import 'package:fahrradverleih/widget/error_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfilBloc>(
      create: (context) =>
          ProfilBloc(api: RepositoryProvider.of<RadApi>(context))
              .firstConstructed(),
      child: _ProfilView(),
    );
  }
}

/// Widget welches entscheidet, welcher Inhalt angezeigt wird.
///
/// Im Normalfall wird das [_ProfilForm] Widget eingesetzt, im Zustand
/// [JobState.failed] stattdessen das [_RetryPanel].
///
/// Außerdem wird hier auf den Zustand [JobState.logout] reagiert.
class _ProfilView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfilBloc, ProfilState>(
      listenWhen: (previous, current) => current.jobState == JobState.logout,
      listener: (context, state) =>
          Navigator.of(context).pushReplacement(StartupPage.route()),
      child: BlocBuilder<ProfilBloc, ProfilState>(
        buildWhen: (previous, current) => previous.jobState != current.jobState,
        builder: (context, state) {
          if (state.jobState == JobState.failed) {
            return ErrorPanel(
                onRetry: () =>
                    context.read<ProfilBloc>().add(const RetryRequested()));
          } else {
            return _ProfilForm();
          }
        },
      ),
    );
  }
}

/// Zeigt die Formular-Struktur mit den Benutzer-Informationen an.
class _ProfilForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mein Profil"),
      ),
      body: Column(
        children: [
          _VornameInput(),
          _NachnameInput(),
          _EmailInput(),
          _PasswortButton(),
          _IdInput()
        ],
      ),
      persistentFooterButtons: [_AbmeldenButton(), _AnwendenButton()],
    );
  }
}

class _VornameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilBloc, ProfilState>(
      buildWhen: (previous, current) => previous.jobState != current.jobState,
      builder: (context, state) => TextField(
        key: const Key("profil_vorname"),
        enabled: state.jobState == JobState.idle,
        controller: TextEditingController()..text = state.benutzer.vorname,
        onChanged: (vorname) =>
            context.read<ProfilBloc>().add(FormVornameChanged(vorname)),
        keyboardType: TextInputType.name,
        decoration: const InputDecoration(
            labelText: "Vorname", icon: Icon(Icons.badge)),
      ),
    );
  }
}

class _NachnameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilBloc, ProfilState>(
      buildWhen: (previous, current) => previous.jobState != current.jobState,
      builder: (context, state) => TextField(
        key: const Key("profil_nachname"),
        enabled: state.jobState == JobState.idle,
        controller: TextEditingController()..text = state.benutzer.name,
        onChanged: (nachname) =>
            context.read<ProfilBloc>().add(FormNachnameChanged(nachname)),
        keyboardType: TextInputType.name,
        decoration: const InputDecoration(
            labelText: "Nachname",
            icon: Icon(
              Icons.badge,
              color: Colors.transparent,
            )),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilBloc, ProfilState>(
      buildWhen: (previous, current) => previous.jobState != current.jobState,
      builder: (context, state) => TextField(
        key: const Key("profil_email"),
        enabled: state.jobState == JobState.idle,
        controller: TextEditingController()..text = state.benutzer.email,
        onChanged: (email) =>
            context.read<ProfilBloc>().add(FormEmailChanged(email)),
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
            labelText: "E-Mail Adresse", icon: Icon(Icons.alternate_email)),
      ),
    );
  }
}

class _PasswortButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilBloc, ProfilState>(
      buildWhen: (previous, current) => previous.jobState != current.jobState,
      builder: (context, state) => Row(
        children: [
          const Icon(Icons.lock),
          ElevatedButton(
            child: const Text("Anmeldung Ändern"),
            onPressed: state.jobState == JobState.idle ? () {} : null,
          )
        ],
      ),
    );
  }
}

class _IdInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilBloc, ProfilState>(
      buildWhen: (previous, current) => previous.jobState != current.jobState,
      builder: (context, state) => TextField(
        key: const Key("profil_id"),
        enabled: state.jobState == JobState.idle,
        readOnly: true,
        controller: TextEditingController()..text = state.benutzer.id,
        decoration: const InputDecoration(
            labelText: "Profil ID", icon: Icon(Icons.link)),
      ),
    );
  }
}

class _AbmeldenButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilBloc, ProfilState>(
      buildWhen: (previous, current) => previous.jobState != current.jobState,
      builder: (context, state) => ElevatedButton(
          onPressed: state.jobState != JobState.idle
              ? null
              : () {
                  context.read<ProfilBloc>().add(const LogoutRequested());
                },
          child: const Text("Abmelden")),
    );
  }
}

class _AnwendenButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilBloc, ProfilState>(
      buildWhen: (previous, current) => previous.jobState != current.jobState,
      builder: (context, state) => ElevatedButton(
          onPressed: state.jobState != JobState.idle
              ? null
              : () {
                  context.read<ProfilBloc>().add(const SaveRequested());
                },
          child: const Text("Änderungen Speichern")),
    );
  }
}

// TODO: Einheitliche [InputDecoration] für Eingabefelder
