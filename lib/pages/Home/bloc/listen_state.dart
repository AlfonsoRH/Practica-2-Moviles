part of 'listen_bloc.dart';

abstract class ListenState extends Equatable {
  const ListenState();

  @override
  List<Object> get props => [];
}

class ListenInitial extends ListenState {}

class ListenListening extends ListenState {}

class ListenFinished extends ListenState {}

class ListenError extends ListenState {}

class ListenSuccess extends ListenState {
  final String title, album, artista, fecha, apple, spotify, image, link;

  ListenSuccess(
      {required this.title,
      required this.album,
      required this.artista,
      required this.fecha,
      required this.apple,
      required this.spotify,
      required this.image,
      required this.link});
}
