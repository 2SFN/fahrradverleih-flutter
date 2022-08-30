import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'tabs_event.dart';
part 'tabs_state.dart';

class TabsBloc extends Bloc<TabsEvent, TabsState> {
  TabsBloc() : super(const TabsState()) {
    on<TabSelected>(_onTabSelected);
    on<BackPressed>(_onBackPressed);
  }

  _onTabSelected(TabSelected event, Emitter<TabsState> emit) {
    emit(state.copyWith(tab: TabsTab.values[event.index]));
  }

  _onBackPressed(BackPressed event, Emitter<TabsState> emit) {
    if(state.tab != TabsTab.map) {
      add(const TabSelected(0));
    }
  }
}
