import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:the_movie_db/src/bloc/movies_bloc.dart';
import 'package:the_movie_db/src/models/movies_model.dart';

class BackgroundWidget extends StatelessWidget {
  final String imageUrl;
  // BackgroundWidget({Key key, this.imageUrl, this.image}) : super(key: key);
  const BackgroundWidget({Key key, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedMovie = Provider.of<Movie>(context);

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
