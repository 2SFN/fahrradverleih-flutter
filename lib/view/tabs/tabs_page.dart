import 'package:fahrradverleih/view/profil/profil_page.dart';
import 'package:fahrradverleih/view/tabs/bloc/tabs_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabsPage extends StatelessWidget {
  const TabsPage({Key? key}) : super(key: key);

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const TabsPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TabsBloc>(
        create: (_) => TabsBloc(), child: _TabsView());
  }
}

class _TabsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<TabsBloc, TabsState>(
        builder: (context, state) => WillPopScope(
              onWillPop: () async => _handleBackEvent(state, context),
              child: Scaffold(
                body: IndexedStack(
                  index: state.tab.index,
                  children: const [
                    Center(child: Text("Map Placeholder")), // TODO
                    Center(child: Text("Ausleihen Placeholder")), // TODO
                    ProfilPage(),
                  ],
                ),
                bottomNavigationBar: BottomNavigationBar(
                  onTap: (index) {
                    context.read<TabsBloc>().add(TabSelected(index));
                  },
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home), label: "Suchen"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.pedal_bike), label: "Ausleihen"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.person), label: "Profil"),
                  ],
                  currentIndex: state.tab.index,
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: colorScheme.primary,
                  unselectedItemColor: Colors.black26,
                  backgroundColor: Colors.white,
                ),
              ),
            )
    );
  }

  bool _handleBackEvent(TabsState state, BuildContext context) {
    if(state.tab == TabsTab.map) {
      return true;
    } else {
      context.read<TabsBloc>().add(const BackPressed());
      return false;
    }
  }
}
