import 'package:crud_project/common/theme/colors.dart';
import 'package:crud_project/home/movie_form_screen.dart';
import 'package:crud_project/home/movie_list_tile.dart';
import 'package:crud_project/movie_management_screen/movie_bloc/movie_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieHomePage extends StatefulWidget {
  const MovieHomePage({super.key});

  @override
  State<MovieHomePage> createState() => _MovieHomePageState();
}

class _MovieHomePageState extends State<MovieHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("Movie Manager"),
      ),
      floatingActionButton: _addButton(),
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is! MovieLoaded) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListView.separated(
              itemCount: state.movies.length,
              itemBuilder: (context, index) {
                return MovieListTile(
                  movie: state.movies[index],
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  indent: 1,
                  endIndent: 1,
                  thickness: 1,
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _addButton() {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => MovieFormScreen(
            type: MovieFormType.add,
          ),
        ),
      ),
      child: Container(
        decoration: const BoxDecoration(
            color: AppColors.primary, shape: BoxShape.circle),
        child: const Padding(
          padding: EdgeInsets.all(12),
          child: Icon(
            Icons.add,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
