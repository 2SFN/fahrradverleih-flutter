import 'package:fahrradverleih/api/rad_api.dart';
import 'package:fahrradverleih/view/startup/bloc/startup_bloc.dart';
import 'package:fahrradverleih/view/startup/widget/content_auth.dart';
import 'package:fahrradverleih/view/startup/widget/content_login.dart';
import 'package:fahrradverleih/view/startup/widget/content_welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Container, welcher den Hintergrund und die AppBar konfiguriert.
///
/// Stellt außerdem eine [RadApi]-Instanz bereit, welche durch die Verwendung
/// des [BlockProvider] in untergeordneten Widgets weiterverwendet werden kann.
class StartupPage extends StatelessWidget {
  const StartupPage({Key? key}) : super(key: key);

  static Route<void> route() =>
      MaterialPageRoute<void>(builder: (_) => const StartupPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            StartupBloc(api: RepositoryProvider.of<RadApi>(context))
                .appStarted(),
        child: BlocBuilder<StartupBloc, StartupState>(
          // WillPopScope fängt die "Zurück"-Taste/-Geste ab, und erlaubt es
          // das Standard-Verhalten zu unterdrücken
          builder: (context, state) => WillPopScope(
            onWillPop: () => _handleBackEvent(context, state),
            child: Scaffold(
                appBar: _buildAppBar(),
                // Zeichnet Hintergrund auch unter der AppBar
                extendBodyBehindAppBar: true,
                body: _buildBody()),
          ),
        ));
  }

  _buildBody() => SizedBox.expand(
          child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16).copyWith(top: 88),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/startup.webp"),
                fit: BoxFit.cover)),
        child: Wrap(children: [
          Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              decoration: const BoxDecoration(
                  color: Color(0x44FFFFFF),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: const StartupContentView()),
        ]),
      ));

  _buildAppBar() => AppBar(
      title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Fahrradverleih",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400)),
            Text("Monheim am Rhein",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300))
          ]),
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
        child: SvgPicture.asset(
          "assets/icons/monheim.svg",
          semanticsLabel: "Monheim am Rhein Logo",
          color: Colors.white
        ),
      ),
      leadingWidth: 90,
      toolbarHeight: 120,
      systemOverlayStyle:
          const SystemUiOverlayStyle(statusBarColor: Color(0x440297DC)),
      elevation: 0,
      backgroundColor: const Color(0x440297DC));
}

/// Entscheidet, ob beim Interagieren mit der "Zurück"-Taste oder -Geste
/// der BLoC auf das Event reagieren soll (```false```), oder das
/// Standard-Verhalten ausgelöst wird (```true```).
Future<bool> _handleBackEvent(BuildContext context, StartupState state) async {
  switch (state.content) {
    case StartupContent.welcome:
    case StartupContent.authentication:
      return true;
    case StartupContent.login:
    case StartupContent.register:
      context.read<StartupBloc>().add(const BackPressed());
      return false;
  }
}

/// Rendering des aktuell anzuzeigenden Widgets.
/// S. [StartupState.content].
class StartupContentView extends StatelessWidget {
  const StartupContentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StartupBloc, StartupState>(
      buildWhen: (previous, current) => previous.content != current.content,
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
