import 'dart:async';

import 'package:crud_project/data/domain/movie.dart';

abstract class MovieRepository {
  final Completer databaseInitialized = Completer();

  Future<Movie> addMovie(Movie movie);

  Future<List<Movie>> getMovies();

  Future<Movie?> updateMovie(Movie movie);

  Future<void> deleteMovie(Movie movie);
}