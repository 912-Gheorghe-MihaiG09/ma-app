import 'package:crud_project/common/theme/theme_builder.dart';
import 'package:crud_project/data/data_sources/movie_remote_data_source.dart';
import 'package:crud_project/data/repository/movie_repository.dart';
import 'package:crud_project/data/repository/movie_repository_impl.dart';
import 'package:crud_project/data/repository/movie_repository_remote.dart';
import 'package:crud_project/data/service/movie_service.dart';
import 'package:crud_project/home/movie_home_page.dart';
import 'package:crud_project/movie_management_screen/movie_bloc/movie_bloc.dart';
import 'package:crud_project/network/network_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Dio _dio = Dio();
  final MovieRepository _movieRepository = MovieRepositoryImpl();
  late final MovieRepository _movieRepositoryRemote =
      MovieRepositoryRemote(MovieRemoteDataSource(MovieService(_dio)));

  final networkBloc = NetworkBloc();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => _movieRepositoryRemote,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => networkBloc..add(NetworkObserve()),
            lazy: false,
          ),
          BlocProvider(
            create: (_) => MovieBloc(_movieRepositoryRemote, networkBloc)
              ..add(const FetchMovies()),
          )
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeBuilder.getThemeData(),
          home: const MovieHomePage(),
        ),
      ),
    );
  }
}
