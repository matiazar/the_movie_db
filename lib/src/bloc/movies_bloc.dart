import 'dart:async';

import 'package:the_movie_db/src/providers/movies_provider.dart';

class MoviesBloc {
  static final MoviesBloc _singleton = new MoviesBloc._();

  factory MoviesBloc() {
    return _singleton;
  }

  MoviesBloc._();

  final _moviesController = StreamController<Movie>.broadcast();

  Function(Movie) get moviesSink => _moviesController.sink.add;

  Stream<Movie> get moviesStream => _moviesController.stream;

  dispose() {
    _moviesController?.close();
  }

  changeMovie(Movie movie) {
    moviesSink(movie);
  }
}
