import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:the_movie_db/src/bloc/movies_bloc.dart';
import 'package:the_movie_db/src/models/movies_model.dart';
import 'package:the_movie_db/src/providers/movies_provider.dart';

class BackgroundWidget extends StatelessWidget {
  // final String imageUrl;

  // final moviesProvider = new MoviesProvider();
  // BackgroundWidget({Key key, this.imageUrl, this.image}) : super(key: key);
  // const BackgroundWidget({Key key, this.imageUrl}) : super(key: key);
  BackgroundWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final String imageUrl = moviesProvider.imagePath;

    // final selectedMovie = Provider.of<Movie>(context);

    // if (selectedMovie == null) return Container();

    return Container(
      decoration: BoxDecoration(
        // color: Colors.black,
        image: (selectedMovie.selected != null &&
                selectedMovie.selected.posterPath != null &&
                selectedMovie.selected.posterPath != 'null')
            ? DecorationImage(
                image: NetworkImage(
                    '$imageUrl${selectedMovie.selected.posterPath}'),
                fit: BoxFit.cover)
            : null,
      ),
      width: double.infinity,
      height: double.infinity,
      // color: Colors.red,
      child: ClipRRect(
        // make sure we apply clip it properly
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            alignment: Alignment.center,
            color: Colors.black.withOpacity(0.4),
            child: Container(),
          ),
        ),
      ),
    );
  }
}
