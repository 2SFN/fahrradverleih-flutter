part of 'tabs_bloc.dart';

/// Beschreibt die verfügbaren Tabs für die Navigation.
///
/// Der Name ist ein wenig eigenartig gewählt, um Kollisionen mit der
/// Material library zu vermeiden.
enum TabsTab { map, ausleihen, profil }

class TabsState extends Equatable {
  const TabsState({
    this.tab = TabsTab.map,
  });

  final TabsTab tab;

  @override
  List<Object?> get props => [tab];

  TabsState copyWith({
    TabsTab? tab,
  }) {
    return TabsState(
      tab: tab ?? this.tab,
    );
  }
}
