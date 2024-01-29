import 'package:crud_project/common/theme/colors.dart';
import 'package:crud_project/common/widgets/default_button.dart';
import 'package:crud_project/data/domain/movie.dart';
import 'package:crud_project/home/movie_form_screen.dart';
import 'package:crud_project/movie_management_screen/movie_bloc/movie_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieScreen extends StatelessWidget {
  final Movie movie;
  const MovieScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MovieBloc, MovieState>(
      listenWhen: (prev, current) =>
          prev is MovieLoading && current is MovieLoaded,
      listener: (context, state) => Navigator.of(context).pop(),
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            title: Text(
              movie.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(Icons.arrow_back_ios_new),
            ),
          ),
          body: Padding(
            padding:
                const EdgeInsets.only(left: 32, right: 32, bottom: 64, top: 32),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Image.network(
                          movie.imageUrl,
                          errorBuilder: (BuildContext context, Object error,
                              StackTrace? stackTrace) {
                            return Image.asset('assets/place_holder_image.jpg', height: 150,);
                          },

                        ),
                        _section(context, Icons.category, movie.category),
                        const Divider(
                          endIndent: 1,
                          indent: 1,
                          thickness: 1,
                        ),
                        _section(context, Icons.link, movie.link),
                        const Divider(
                          endIndent: 1,
                          indent: 1,
                          thickness: 1,
                        ),
                        _section(context, Icons.description, movie.desc),
                        const Divider(
                          endIndent: 1,
                          indent: 1,
                          thickness: 1,
                        ),
                      ],
                    ),
                  ),
                ),
                // DefaultButton(
                //   text: "Update",
                //   onPressed: () => Navigator.of(context).push(
                //             MaterialPageRoute(
                //               builder: (_) => MovieFormScreen(
                //                 type: MovieFormType.update,
                //                 movie: movie,
                //               ),
                //             ),
                //           )
                // ),
                DefaultButton(
                  text: "Delete",
                  onPressed: () => BlocProvider.of<MovieBloc>(context).add(
                            DeleteMovie(movie),
                          ),
                  isLoading: state is MovieLoading,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _section(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Icon(icon),
          ),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
