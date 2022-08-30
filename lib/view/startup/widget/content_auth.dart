import 'package:fahrradverleih/view/startup/bloc/startup_bloc.dart';
import 'package:fahrradverleih/view/tabs/tabs_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Einfacher Splash-Screen mit einem Lade-Indikator.
///
/// Registriert außerdem einen [BlocListener], um auf den Status
/// [AuthenticationStatus.authenticated] zu hören und entsprechend zu der
/// nächsten Ansicht zu navigieren.
class ContentAuth extends StatelessWidget {
  const ContentAuth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<StartupBloc, StartupState>(
      listener: (context, state) {
        if (state.authenticationStatus == AuthenticationStatus.authenticated) {
          Navigator.of(context).pushReplacement(TabsPage.route());
        }
      },
      child: const Padding(
          padding: EdgeInsets.all(12), child: CircularProgressIndicator()),
    );
  }
}
