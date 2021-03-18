import 'package:dio/dio.dart';

import 'package:the_movie_db/src/models/movies_model.dart';

class MoviesProvider {
  final _url = 'https://api.themoviedb.org/3/';
  final _apiKey = '0e685fd77fb3d76874a3ac26e0db8a4b';
  final _lang = 'es-AR';
  final imagePath = 'https://image.tmdb.org/t/p/w500/';

  int _page = 1;
  Dio dio = new Dio(); // with default Options

  // 3/movie/popular?api_key=0e685fd77fb3d76874a3ac26e0db8a4b&language=es-AR&page=1
  MoviesProvider() {
    // Set default configs
    dio.options.baseUrl = _url;
    // dio.options.connectTimeout = 5000; //5s
    // dio.options.receiveTimeout = 3000;
    dio.options.queryParameters = {
      "api_key": _apiKey,
      "language": _lang,
      "page": _page
    };
  }

  Future<List<Genre>> getGenres() async {
    //movie/popular?api_key=0e685fd77fb3d76874a3ac26e0db8a4b&language=es-AR&page=1

    final path = 'genre/movie/list';
    Response response;

    try {
      response = await dio.get('$_url$path', queryParameters: {});
    } catch (e) {
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
      }
    }

    var genres = Genres.fromJson(response.data['genres']);
    return genres.items;
  }

  Future<List<Movie>> getPopulars() async {
    //movie/popular?api_key=0e685fd77fb3d76874a3ac26e0db8a4b&language=es-AR&page=1

    final path = 'movie/popular';
    Response response;

    try {
      response = await dio.get('$_url$path', queryParameters: {});
    } catch (e) {
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
      }
    }

    var movies = Movies.fromJson(response.data['results']);
    return movies.items;
  }

  Future<List<Movie>> getLatest() {
    //movie/latest?api_key=<<api_key>>&language=en-US

    List<Movie> a = [];
    return Future.value(a);
  }

  Future<List<Movie>> search() {
    //search/movie?api_key=<<api_key>>&language=en-US&page=1&include_adult=false
    List<Movie> a = [];
    return Future.value(a);
  }

  Future<Movie> get() {
    //movie/{movie_id}?api_key=<<api_key>>&language=en-US
    Movie a = new Movie(); // = [];
    return Future.value(a);
  }
}
