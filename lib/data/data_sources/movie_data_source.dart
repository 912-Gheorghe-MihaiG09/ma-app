import 'package:crud_project/data/domain/movie.dart';

abstract class MovieDataSource {
  Future<Movie> addMovie(Movie movie);

  Future<List<Movie>> getMovies();

  Future<Movie?> getMovie(String movieId);

  Future<Movie?> updateMovie(Movie movie);

  Future<void> deleteMovie(Movie movie);
}