import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:crud_project/data/domain/movie.dart';
import 'package:crud_project/data/service/api_service.dart';
import 'package:dio/dio.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MovieService extends ApiService{
  MovieService(super.dio);

  Future<Movie> addMovie(Movie movie) async {
    final response = await dio.post("/movie",
        data: movie.toJson());
    log(response.toString());
    return Movie.fromJson(jsonDecode(response.toString()));
  }

  Future<List<Movie>> getMovies() async {
    final response = await dio.get("/movies");
    return Movie.listFromJson(response.data);
  }

  Future<Stream> getMoviesStream() async{
    final channel = WebSocketChannel.connect(
      Uri.parse('ws://localhost:3000/movies'),
    );
    return channel.stream;
  }
}