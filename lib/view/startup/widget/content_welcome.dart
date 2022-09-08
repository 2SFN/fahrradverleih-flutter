import 'package:fahrradverleih/view/startup/bloc/startup_bloc.dart';
import 'package:fahrradverleih/view/startup/widget/white_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Einfacher Willkommens-Bildschirm, welcher dem Anwender Optionen zum
/// Anmelden oder Registrieren anbietet.
class ContentWelcome extends StatelessWidget {
  const ContentWelcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Text("Willkommen!", style: _TitleTextStyle()),
        Padding(padding: EdgeInsets.all(10)),
        _LoginButton(),
        Padding(padding: EdgeInsets.all(4)),
        Text("oder", style: _BaseTextStyle()),
        Padding(padding: EdgeInsets.all(4)),
        WhiteOutlinedButton(onPressed: null, child: Text("Registrieren")),
      ],
    );
  }
}

/// Button, welcher mit dem [StartupBloc] interagiert und ein Event auslöst,
/// welches den Inhalt zu [StartupContent.login] wechseln soll.
class _LoginButton extends StatelessWidget {
  const _LoginButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StartupBloc, StartupState>(
        builder: (context, state) => WhiteOutlinedButton(
            onPressed: () {
              context
                  .read<StartupBloc>()
                  .add(const StartupNavigationEvent(StartupContent.login));
            },
            child: const Text("Anmelden")));
  }
}

class _BaseTextStyle extends TextStyle {
  const _BaseTextStyle();

  @override
  Color? get color => Colors.white;

  @override
  double? get fontSize => 18;
}

class _TitleTextStyle extends _BaseTextStyle {
  const _TitleTextStyle();

  @override
  double? get fontSize => 24;

  @override
  FontWeight? get fontWeight => FontWeight.w300;
}
