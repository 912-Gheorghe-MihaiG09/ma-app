import 'dart:async';

import 'package:crud_project/data/data_sources/movie_remote_data_source.dart';
import 'package:crud_project/data/domain/movie.dart';
import 'package:crud_project/data/repository/movie_repository.dart';

class MovieRepositoryRemote extends MovieRepository {
  final MovieRemoteDataSource _remoteDataSource;

  MovieRepositoryRemote(this._remoteDataSource) {
    super.databaseInitialized.complete();
  }

  @override
  Future<Movie> addMovie(Movie movie) {
    return _remoteDataSource.addMovie(movie);
  }

  @override
  Future<void> deleteMovie(Movie movie) {
    return _remoteDataSource.deleteMovie(movie);
  }

  @override
  Future<List<Movie>> getMovies() {
    return _remoteDataSource.getMovies();
  }

  @override
  Future<Movie?> updateMovie(Movie movie) {
    return _remoteDataSource.updateMovie(movie);
  }

  Future<Stream> getMoviesStream(){
    return _remoteDataSource.getMoviesStream();
  }
}
