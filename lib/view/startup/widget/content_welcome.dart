import 'package:fahrradverleih/view/startup/bloc/startup_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Einfacher Willkommens-Bildschirm, welcher dem Anwender Optionen zum
/// Anmelden oder Registrieren anbietet.
class ContentWelcome extends StatelessWidget {
  const ContentWelcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Title(color: Colors.white, child: const Text("Willkommen!")),
        const Padding(padding: EdgeInsets.all(10)),
        const ElevatedButton(onPressed: null, child: Text("Registrieren")),
        const Padding(padding: EdgeInsets.all(4)),
        const Text("oder"),
        const Padding(padding: EdgeInsets.all(4)),
        _LoginButton(),
      ],
    );
  }
}

/// Button, welcher mit dem [StartupBloc] interagiert und ein Event auslöst,
/// welches den Inhalt zu [StartupContent.login] wechseln soll.
class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StartupBloc, StartupState>(
        builder: (context, state) => ElevatedButton(
            onPressed: () {
              context
                  .read<StartupBloc>()
                  .add(const StartupNavigationEvent(StartupContent.login));
            },
            child: const Text("Einloggen")));
  }
}
