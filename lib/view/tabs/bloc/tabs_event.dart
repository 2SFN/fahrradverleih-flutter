part of 'tabs_bloc.dart';

abstract class TabsEvent extends Equatable {
  const TabsEvent();

  @override
  List<Object?> get props => [];
}

class TabSelected extends TabsEvent {
  const TabSelected(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}

class BackPressed extends TabsEvent {
  const BackPressed();
}
