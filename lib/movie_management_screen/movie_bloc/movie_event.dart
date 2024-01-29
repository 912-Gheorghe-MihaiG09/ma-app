part of 'movie_bloc.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object?> get props => [];
}

class FetchMovies extends MovieEvent {
  const FetchMovies();
}

class AddMovie extends MovieEvent {
  final String category;
  final String imageUrl;
  final String link;
  final String name;
  final String desc;

  const AddMovie({
    required this.category,
    required this.imageUrl,
    required this.link,
    required this.name,
    required this.desc,
  });

  @override
  List<Object?> get props => [category, imageUrl, link, name, desc];
}

class DeleteMovie extends MovieEvent {
  final Movie movie;

  const DeleteMovie(this.movie);

  @override
  List<Object?> get props => [movie];
}

class UpdateMovie extends MovieEvent {
  final String category;
  final String imageUrl;
  final String link;
  final String name;
  final String desc;

  const UpdateMovie({
    required this.category,
    required this.imageUrl,
    required this.link,
    required this.name,
    required this.desc,
  });

  @override
  List<Object?> get props => [category, imageUrl, link, name, desc];
}

class SyncMovies extends MovieEvent {}
