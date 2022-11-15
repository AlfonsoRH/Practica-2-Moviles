part of 'listen_bloc.dart';

abstract class ListenEvent extends Equatable {
  const ListenEvent();

  @override
  List<Object> get props => [];
}

class ListenStart extends ListenEvent {}
