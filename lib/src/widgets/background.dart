import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:the_movie_db/src/bloc/movies_bloc.dart';
import 'package:the_movie_db/src/models/movies_model.dart';

class BackgroundWidget extends StatefulWidget {
  final String imageUrl;
  // BackgroundWidget({Key key, this.imageUrl, this.image}) : super(key: key);
  BackgroundWidget({Key key, this.imageUrl}) : super(key: key);

  @override
  BackgroundWidgetState createState() => BackgroundWidgetState();
}

class BackgroundWidgetState extends State<BackgroundWidget> {
  final moviesBloc = new MoviesBloc();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Movie>(
        stream: moviesBloc.moviesStream,
        builder: (context, snapshot) {
          // print(snapshot.data.title);

          return Container(
            decoration: BoxDecoration(
              // color: Colors.black,
              image: (snapshot.data != null &&
                      snapshot.data.posterPath != null &&
                      snapshot.data.posterPath != 'null')
                  ? DecorationImage(
                      image: NetworkImage(
                          '${widget.imageUrl}${snapshot.data.posterPath}'),
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
        });
  }
}
