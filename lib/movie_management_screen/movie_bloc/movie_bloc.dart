import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:crud_project/data/domain/movie.dart';
import 'package:crud_project/data/repository/movie_repository.dart';
import 'package:crud_project/data/repository/movie_repository_remote.dart';
import 'package:crud_project/network/network_bloc.dart';
import 'package:equatable/equatable.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository _movieRepository;
  final NetworkBloc _networkBloc;

  MovieBloc(this._movieRepository, this._networkBloc)
      : super(const MovieInitial(username: "", movies: [])) {
    on<AddMovie>(_onAddMovie);
    on<UpdateMovie>(_onUpdateMovie);
    on<DeleteMovie>(_onDeleteMovie);
    on<FetchMovies>(_onFetchMovies);
    on<SyncMovies>(_onSyncMovies);
    if (_movieRepository is MovieRepositoryRemote) {
      (_movieRepository as MovieRepositoryRemote)
          .getMoviesStream()
          .then((stream) {
        StreamTransformer<Uint8List, List<int>> unit8Transformer =
            StreamTransformer.fromHandlers(
          handleData: (data, sink) {
            sink.add(List<int>.from(data));
          },
        );
        stream
            .transform(unit8Transformer)
            .transform(const Utf8Decoder())
            .transform(const LineSplitter())
            .listen(
          (event) {
            print(event);
          },
        );
      });
    }
    // _networkBloc.stream.asBroadcastStream().listen((networkState) async {
    //   if (networkState is NetworkSuccess) {
    //     if (_movieRepository is MovieRepositoryRemote) {
    //       add(SyncMovies());
    //     }
    //   }
    // });
  }

  FutureOr<void> _onSyncMovies(
      SyncMovies event, Emitter<MovieState> emit) async {
    // emit(MovieLoading(username: state.username, movies: state.movies));
    // await (_movieRepository as MovieRepositoryRemote).syncServer();
    //
    // add(const FetchMovies());
  }

  FutureOr<void> _onAddMovie(AddMovie event, Emitter<MovieState> emit) async {
    emit(MovieLoading(username: state.username, movies: state.movies));
    await _movieRepository.databaseInitialized.future;

    await _movieRepository.addMovie(
      Movie(
        category: event.category,
        imageUrl: event.imageUrl,
        link: event.link,
        name: event.name,
        desc: event.desc,
      ),
    );

    var newList = await _movieRepository.getMovies();

    emit(MovieLoaded(username: state.username, movies: newList));
  }

  FutureOr<void> _onUpdateMovie(
      UpdateMovie event, Emitter<MovieState> emit) async {
    emit(MovieLoading(username: state.username, movies: state.movies));
    await _movieRepository.databaseInitialized.future;

    await _movieRepository.updateMovie(Movie(
      category: event.category,
      imageUrl: event.imageUrl,
      link: event.link,
      name: event.name,
      desc: event.desc,
    ));

    var newList = await _movieRepository.getMovies();

    emit(MovieLoaded(username: state.username, movies: newList));
  }

  FutureOr<void> _onDeleteMovie(
      DeleteMovie event, Emitter<MovieState> emit) async {
    emit(MovieLoading(username: state.username, movies: state.movies));
    await _movieRepository.databaseInitialized.future;

    await _movieRepository.deleteMovie(event.movie);

    var newList = await _movieRepository.getMovies();

    emit(MovieLoaded(username: state.username, movies: newList));
  }

  FutureOr<void> _onFetchMovies(
      FetchMovies event, Emitter<MovieState> emit) async {
    emit(MovieLoading(username: state.username, movies: state.movies));
    await _movieRepository.databaseInitialized.future;

    var newList = await _movieRepository.getMovies();

    emit(MovieLoaded(username: state.username, movies: newList));
  }
}
