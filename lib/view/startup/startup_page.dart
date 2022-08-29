import 'package:fahrradverleih/api/rad_api.dart';
import 'package:fahrradverleih/view/startup/bloc/startup_bloc.dart';
import 'package:fahrradverleih/view/startup/widget/content_auth.dart';
import 'package:fahrradverleih/view/startup/widget/content_login.dart';
import 'package:fahrradverleih/view/startup/widget/content_welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Container, welcher den Hintergrund und die AppBar konfiguriert.
/// Stellt außerdem eine [RadApi]-Instanz bereit, welche durch die Verwendung
/// des [BlockProvider] in untergeordneten Widgets weiterverwendet werden kann.
class StartupPage extends StatelessWidget {
  const StartupPage({Key? key}) : super(key: key);

  static Route<void> route() =>
      MaterialPageRoute<void>(builder: (_) => const StartupPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Fahrradverleih")),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: BlocProvider(
              create: (context) =>
                  StartupBloc(api: RepositoryProvider.of<RadApi>(context))
                      .appStarted(),
              child: const StartupContentView(),
            ),
          ),
        ));
  }
}

/// Rendering des aktuell anzuzeigenden Widgets.
/// S. [StartupState.content].
class StartupContentView extends StatelessWidget {
  const StartupContentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StartupBloc, StartupState>(
      // buildWhen: (previous, current) => previous.content != current.content,
      builder: (context, state) {
        switch (state.content) {
          case StartupContent.authentication:
            return const ContentAuth();
          case StartupContent.login:
            return const ContentLogin();
          case StartupContent.register:
            return const Text("Nicht implementiert");
          case StartupContent.welcome:
            return const ContentWelcome();
        }
      },
    );
  }
}
