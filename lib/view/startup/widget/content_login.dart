import 'package:fahrradverleih/view/startup/bloc/startup_bloc.dart';
import 'package:fahrradverleih/view/startup/widget/white_outlined_button.dart';
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
          const Padding(padding: EdgeInsets.all(8)),
          _PasswordInput(),
          const Padding(padding: EdgeInsets.all(8)),
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
        builder: (context, state) => _FormIconTextField(
            key: const Key("startup_login_email"),
            label: "E-Mail Adresse",
            onChanged: (email) =>
                context.read<StartupBloc>().add(LoginEmailChanged(email)),
            keyboardType: TextInputType.emailAddress,
            enabled: state.authenticationStatus !=
                AuthenticationStatus.authenticating,
            icon: const Icon(
              Icons.alternate_email,
              color: Colors.white,
              size: 28,
            )));
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StartupBloc, StartupState>(
        buildWhen: (previous, current) =>
            previous.authenticationStatus != current.authenticationStatus,
        builder: (context, state) => _FormIconTextField(
            key: const Key("startup_login_password"),
            label: "Passwort",
            onChanged: (password) =>
                context.read<StartupBloc>().add(LoginPasswordChanged(password)),
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            enabled: state.authenticationStatus !=
                AuthenticationStatus.authenticating,
            icon: const Icon(Icons.lock, color: Colors.white, size: 28)));
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StartupBloc, StartupState>(
      buildWhen: (previous, current) =>
          previous.authenticationStatus != current.authenticationStatus,
      builder: (context, state) => WhiteOutlinedButton(
          onPressed:
              state.authenticationStatus == AuthenticationStatus.authenticating
                  ? null
                  : () => _onPress(context),
          child: Text(
              state.authenticationStatus == AuthenticationStatus.authenticating
                  ? "..."
                  : "Anmelden")),
    );
  }

  _onPress(BuildContext context) {
    // BLoC Event auslösen
    context.read<StartupBloc>().add(const LoginSubmitted());

    // Versteckt die Tastatur auf Geräten mit Soft-Keyboard
    FocusManager.instance.primaryFocus?.unfocus();
  }
}

class _FormIconTextField extends StatelessWidget {
  const _FormIconTextField(
      {Key? key,
      required this.label,
      this.icon,
      this.onChanged,
      this.keyboardType,
      this.obscureText = false,
      this.enabled = true})
      : super(key: key);

  final String label;
  final Widget? icon;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      keyboardType: keyboardType,
      obscureText: obscureText,
      enabled: enabled,
      decoration: InputDecoration(
          labelText: label,
          labelStyle: _whiteText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          fillColor: Colors.white,
          icon: icon,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: _whiteBorder,
          focusedBorder: _whiteBorder,
          disabledBorder: _whiteBorder,
          enabledBorder: _whiteBorder),
      style: _whiteText,
      cursorColor: Colors.white,
    );
  }

  static const _whiteText = TextStyle(color: Colors.white);

  static const _whiteBorder = UnderlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(color: Colors.white, width: 1));
}
