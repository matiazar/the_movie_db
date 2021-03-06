import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:the_movie_db/src/models/casts_model.dart';
import 'package:the_movie_db/src/models/categories_model.dart';
import 'package:the_movie_db/src/models/genres_model.dart';
import 'package:the_movie_db/src/models/movies_model.dart';

export 'package:the_movie_db/src/models/casts_model.dart';
export 'package:the_movie_db/src/models/movies_model.dart';
export 'package:the_movie_db/src/models/genres_model.dart';

class ServiceProvider {

  final _url = 'https://api.themoviedb.org/3/';
  final _apiKey = '0e685fd77fb3d76874a3ac26e0db8a4b';
  final _lang = 'es-ES';
  final imagePath = 'https://image.tmdb.org/t/p/w500/';

  int _page = 1;
  Dio dio = new Dio(); // with default Options
  Response _response;

  ServiceProvider() {
    _initDio();
  }

  _initDio() {
    dio.options.baseUrl = _url;
    // dio.options.connectTimeout = 5000; //5s
    // dio.options.receiveTimeout = 3000;
    dio.options.queryParameters = {
      "api_key": _apiKey,
      "language": _lang,
      "page": _page
    };
  }

  Future<Genres> getGenres() async {
    //movie/popular?api_key=0e685fd77fb3d76874a3ac26e0db8a4b&language=es-AR&page=1
    print('get genres');
    final path = 'genre/movie/list';

    try {
      _response = await dio.get('$_url$path', queryParameters: {});
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

    var genres = Genres.fromJson(_response.data['genres']);
    return genres;
  }

  Future<Movies> getMovies(Category category) async {
    //movie/popular?api_key=0e685fd77fb3d76874a3ac26e0db8a4b&language=es-AR&page=1

    print('get movies');

    var path;

    switch (category.url) {
      // case 'Populars': final path = 'movie/popular'; break;
      case 'Upcoming':
        path = 'movie/upcoming';
        break;
      case 'Latest':
        path = 'movie/latest';
        break;
      case 'TopRated':
        path = 'movie/top_rated';
        break;
      case 'NowPlaying':
        path = 'movie/now_playing';
        break;
      default:
        path = 'movie/popular';
        break;
    }
    // final path = 'movie/popular';

    try {
      _response = await dio.get('$_url$path', queryParameters: {});
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

    var movies = Movies.fromJson(_response.data['results']);
    return movies;
  }

  Future<Movies> search(String query) async {
    //search/movie?api_key=<<api_key>>&language=en-US&page=1&include_adult=false

    if (query == null || query == '') return Movies();

    final path = 'search/movie';

    try {
      _response =
          await dio.get('$_url$path', queryParameters: {'query': query});
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

    var movies = Movies.fromJson(_response.data['results']);
    return movies;
  }

  Future<Movie> get() {
    //movie/{movie_id}?api_key=<<api_key>>&language=en-US
    Movie a = new Movie(); // = [];
    return Future.value(a);
  }

  Future<Movies> getSimilar(Movie movie) async {
    final path = 'movie/${movie.id}/similar';

    try {
      _response = await dio.get('$_url$path', queryParameters: {});
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

    var movies = Movies.fromJson(_response.data['results']);
    return movies;
  }

  Future<List<Cast>> getCast(Movie movie) async {
    final path = 'movie/${movie.id}/credits';

    try {
      _response = await dio.get('$_url$path', queryParameters: {});
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

    var casts = Casts.fromJson(_response.data['cast']);
    return casts.items;
  }
}
