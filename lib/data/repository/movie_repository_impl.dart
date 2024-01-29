import 'dart:async';

import 'package:crud_project/data/domain/movie.dart';
import 'package:crud_project/data/repository/movie_repository.dart';

class MovieRepositoryImpl extends MovieRepository {
  late List<Movie> _movies;
  int latestId = 11;

  MovieRepositoryImpl() {
    _movies = List.of(Movie.getPopulation(),);
    super.databaseInitialized.complete();
  }

  @override
  Future<Movie> addMovie(Movie movie) async {
    await Future.delayed(const Duration(seconds: 1));

    _movies.insert(0, movie);
    latestId++;

    return movie;
  }

  @override
  Future<void> deleteMovie(Movie movie) async {
    await Future.delayed(const Duration(seconds: 1));
    _movies.remove(movie);
  }

  @override
  Future<List<Movie>> getMovies() async {
    await Future.delayed(const Duration(seconds: 1));
    return _movies;
  }

  @override
  Future<Movie?> updateMovie(Movie movie) async {
    await Future.delayed(const Duration(seconds: 1));
    return movie;
    // for (int i = 0; i < _movies.length; i++) {
    //   if (_movies[i].id == movie.id) {
    //     _movies[i] = movie;
    //     return _movies[i];
    //   }
    // }
    // return null;
  }
}
