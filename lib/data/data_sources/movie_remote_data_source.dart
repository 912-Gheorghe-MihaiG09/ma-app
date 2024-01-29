import 'package:crud_project/data/data_sources/movie_data_source.dart';
import 'package:crud_project/data/domain/movie.dart';
import 'package:crud_project/data/service/movie_service.dart';

class MovieRemoteDataSource implements MovieDataSource {
  final MovieService _movieService;
  late final Stream movieStream;

  MovieRemoteDataSource(this._movieService) {
    _movieService.getMoviesStream().then((value) {
      movieStream = value;
      movieStream.listen((event) {
        print("MovieRemoteDataSource received data $event");
      });
    });
  }

  @override
  Future<Movie> addMovie(Movie movie) {
    return _movieService.addMovie(movie);
  }

  @override
  Future<void> deleteMovie(Movie movie) async {}

  @override
  Future<Movie?> getMovie(String movieId) async {
    return null;
  }

  @override
  Future<List<Movie>> getMovies() {
    return _movieService.getMovies();
  }

  @override
  Future<Movie?> updateMovie(Movie movie) async {
    return movie;
  }

  Future<Stream> getMoviesStream() async {
    return movieStream;
  }
}
