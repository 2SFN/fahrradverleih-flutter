import 'dart:ui';

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            _spacing,
            _VornameInput(),
            _spacing,
            _NachnameInput(),
            _spacing,
            _EmailInput(),
            _spacing,
            _PasswortButton(),
            _spacing,
            _IdInput()
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _AbmeldenButton(),
              const Padding(padding: EdgeInsets.all(3)),
              _AnwendenButton()
            ]),
      ),
    );
  }

  static const _spacing = Padding(padding: EdgeInsets.symmetric(vertical: 3));
}

class _VornameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilBloc, ProfilState>(
        buildWhen: (previous, current) => previous.jobState != current.jobState,
        builder: (context, state) => _FormTextField(
              label: "Vorname",
              prefill: state.benutzer.vorname,
              enabled: state.jobState == JobState.idle,
              keyboardType: TextInputType.name,
              icon: const Icon(
                Icons.badge,
                size: 28,
                color: _FormFieldBase.accentColor,
              ),
              onChanged: (vorname) =>
                  context.read<ProfilBloc>().add(FormVornameChanged(vorname)),
            ));
  }
}

class _NachnameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilBloc, ProfilState>(
      buildWhen: (previous, current) => previous.jobState != current.jobState,
      builder: (context, state) => _FormTextField(
        key: const Key("profil_nachname"),
        label: "Nachname",
        enabled: state.jobState == JobState.idle,
        prefill: state.benutzer.name,
        onChanged: (nachname) =>
            context.read<ProfilBloc>().add(FormNachnameChanged(nachname)),
        keyboardType: TextInputType.name,
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilBloc, ProfilState>(
      buildWhen: (previous, current) => previous.jobState != current.jobState,
      builder: (context, state) => _FormTextField(
        key: const Key("profil_email"),
        label: "E-Mail Adresse",
        enabled: state.jobState == JobState.idle,
        prefill: state.benutzer.email,
        onChanged: (email) =>
            context.read<ProfilBloc>().add(FormEmailChanged(email)),
        keyboardType: TextInputType.emailAddress,
        icon: const Icon(Icons.alternate_email,
            size: 28, color: _FormFieldBase.accentColor),
      ),
    );
  }
}

class _PasswortButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilBloc, ProfilState>(
        buildWhen: (previous, current) => previous.jobState != current.jobState,
        builder: (context, state) => _FormFieldBase(
            icon: const Icon(Icons.lock,
                semanticLabel: "Anmeldung ändern",
                size: 28,
                color: _FormFieldBase.accentColor),
            child: OutlinedButton(
              style: _primaryButtonStyle(context),
              onPressed: state.jobState == JobState.idle ? () {} : null,
              child: const Text("Anmeldung Ändern"),
            )));
  }
}

class _IdInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilBloc, ProfilState>(
      buildWhen: (previous, current) => previous.jobState != current.jobState,
      builder: (context, state) => _FormTextField(
          key: const Key("profil_id"),
          label: "Profil ID",
          enabled: state.jobState == JobState.idle,
          readOnly: true,
          prefill: state.benutzer.id,
          icon: const Icon(Icons.link,
              size: 28, color: _FormFieldBase.accentColor)),
    );
  }
}

class _AbmeldenButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilBloc, ProfilState>(
      buildWhen: (previous, current) => previous.jobState != current.jobState,
      builder: (context, state) => OutlinedButton(
          style: _dangerButtonStyle(context),
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
      builder: (context, state) => OutlinedButton(
          style: _primaryButtonStyle(context),
          onPressed: state.jobState != JobState.idle
              ? null
              : () {
                  context.read<ProfilBloc>().add(const SaveRequested());
                },
          child: const Text("Änderungen Übernehmen")),
    );
  }
}

/// Basis-Klasse für Formular-Felder mit einem Icon und Inhalt.
///
/// Erzwingt vordefinierte Größen für das Icon und Padding, um unabhängig vom
/// [child]-Widget ein möglichst einheitliches Aussehen zu erhalten.
class _FormFieldBase extends StatelessWidget {
  const _FormFieldBase({Key? key, this.icon, required this.child})
      : super(key: key);

  final Widget? icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints.expand(width: 28, height: 28),
                child: icon,
              ),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 3)),
              Expanded(child: child)
            ]));
  }

  static const accentColor = Color(0xFF5e5e5e);
}

class _FormTextField extends StatelessWidget {
  const _FormTextField(
      {Key? key,
      required this.label,
      this.icon,
      this.prefill,
      this.enabled = true,
      this.readOnly = false,
      this.keyboardType,
      this.onChanged})
      : super(key: key);

  final String label;
  final Widget? icon;
  final String? prefill;
  final bool enabled;
  final bool readOnly;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    const accentColor = _FormFieldBase.accentColor;
    const textSecondary = TextStyle(color: accentColor);
    return _FormFieldBase(
        icon: icon,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: textSecondary.copyWith(fontSize: 12)),
            const Padding(padding: EdgeInsets.symmetric(vertical: .5)),
            SizedBox(
              child: TextField(
                enabled: enabled,
                readOnly: readOnly,
                controller: (prefill != null)
                    ? (TextEditingController()..text = prefill!)
                    : null,
                style: textSecondary,
                decoration: const InputDecoration(
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: accentColor, width: 1),
                      gapPadding: 10,
                      borderRadius: BorderRadius.zero,
                    )),
              ),
            )
          ],
        ));
  }
}

ButtonStyle _primaryButtonStyle(BuildContext context) {
  final color = Theme.of(context).primaryColor;
  final borderSide = BorderSide(color: color, width: 1);
  return OutlinedButton.styleFrom(
      // Verhindert ungewolltes, äußeres margin
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      // Lässt den Button schmaler erscheinen
      minimumSize: const Size(200, 20),
      textStyle: const TextStyle(fontWeight: FontWeight.w400),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      side: borderSide,
      shape: RoundedRectangleBorder(
          side: borderSide, borderRadius: BorderRadius.zero),
      foregroundColor: color);
}

ButtonStyle _dangerButtonStyle(BuildContext context) {
  const color = Color(0xFFEB445A);
  const borderSide = BorderSide(color: color, width: 1);
  return OutlinedButton.styleFrom(
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      minimumSize: const Size(200, 20),
      textStyle: const TextStyle(fontWeight: FontWeight.w400),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      side: borderSide,
      shape: const RoundedRectangleBorder(
          side: borderSide, borderRadius: BorderRadius.zero),
      foregroundColor: color);
}
