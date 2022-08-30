import 'package:fahrradverleih/view/startup/bloc/startup_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContentLogin extends StatelessWidget {
  const ContentLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<StartupBloc, StartupState>(
      listener: (context, state) {
        if (state.authenticationStatus == AuthenticationStatus.failed) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
                const SnackBar(content: Text("Login fehlgeschlagen")));
        }
      },
      child: Column(
        children: [
          _EmailInput(),
          _PasswordInput(),
          _LoginButton(),
        ],
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StartupBloc, StartupState>(
        buildWhen: (previous, current) =>
            previous.authenticationStatus != current.authenticationStatus,
        builder: (context, state) => TextField(
              key: const Key("startup_login_email"),
              onChanged: (email) =>
                  context.read<StartupBloc>().add(LoginEmailChanged(email)),
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: "E-Mail Adresse"),
              enabled: state.authenticationStatus !=
                  AuthenticationStatus.authenticating,
            ));
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StartupBloc, StartupState>(
        buildWhen: (previous, current) =>
            previous.authenticationStatus != current.authenticationStatus,
        builder: (context, state) => TextField(
              key: const Key("startup_login_password"),
              onChanged: (password) => context
                  .read<StartupBloc>()
                  .add(LoginPasswordChanged(password)),
              keyboardType: TextInputType.visiblePassword,
              decoration: const InputDecoration(labelText: "Passwort"),
              obscureText: true,
              enabled: state.authenticationStatus !=
                  AuthenticationStatus.authenticating,
            ));
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StartupBloc, StartupState>(
      buildWhen: (previous, current) =>
          previous.authenticationStatus != current.authenticationStatus,
      builder: (context, state) => ElevatedButton(
          onPressed: state.authenticationStatus ==
                  AuthenticationStatus.authenticating
              ? null
              : () => context.read<StartupBloc>().add(const LoginSubmitted()),
          child: Text(
              state.authenticationStatus == AuthenticationStatus.authenticating
                  ? "..."
                  : "Anmelden")),
    );
  }
}
