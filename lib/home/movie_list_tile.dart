import 'package:crud_project/data/domain/movie.dart';
import 'package:crud_project/home/movie_screen.dart';
import 'package:flutter/material.dart';

class MovieListTile extends StatelessWidget {
  final Movie movie;

  const MovieListTile({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        movie.imageUrl,
        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
          return Image.asset('assets/place_holder_image.jpg');
        },
      ),
      title: Text(movie.name),
      subtitle: Text(movie.category),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MovieScreen(movie: movie),
        ),
      ),
    );
  }
}