part of 'movie_bloc.dart';

abstract class MovieState extends Equatable {
  final String username;
  final List<Movie> movies;

  const MovieState({required this.username, required this.movies});

  @override
  List<Object?> get props => [username, movies];
}

class MovieInitial extends MovieState {
  const MovieInitial({required super.username, required super.movies});
}

class MovieLoading extends MovieState {
  const MovieLoading({required super.username, required super.movies});
}

class MovieLoaded extends MovieState {
  const MovieLoaded({required super.username, required super.movies});
}

class MovieError extends MovieState {
  final String message;
  final MovieErrorReason reason;

  const MovieError({
    required super.username,
    required super.movies,
    required this.message,
    required this.reason,
  });

  @override
  List<Object> get props => [username, message, reason];
}

enum MovieErrorReason {
  invalidField,
}
