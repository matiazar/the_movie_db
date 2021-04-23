// import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

// import 'package:the_movie_db/src/models/casts_model.dart';
import 'package:the_movie_db/src/models/categories_model.dart';
import 'package:the_movie_db/src/models/genres_model.dart';
import 'package:the_movie_db/src/models/movies_model.dart';
import 'package:the_movie_db/src/providers/service_provider.dart';

export 'package:the_movie_db/src/models/casts_model.dart';
export 'package:the_movie_db/src/models/movies_model.dart';
export 'package:the_movie_db/src/models/genres_model.dart';

class MoviesProvider extends ChangeNotifier {
  final serviceProvider = new ServiceProvider();
  var imagePath;

  List<Category> categories = [
    Category(title: 'Populares', url: 'Popular'),
    Category(title: 'En Cine', url: 'NowPlaying'),
    Category(title: 'Próximos Estrenos', url: 'Upcoming'),
  ];

  SwiperController swiperController = new SwiperController();

  MoviesProvider.init() {
    imagePath = serviceProvider.imagePath;
    getGenres();

    categories.forEach((category) async {
      await getMovies(category);
      if (category.title == 'Populares') {
        this.movie = category.movies.list.first;
      }
    });
  }

  Movie _movie = new Movie();
  Movie get movie => _movie;

  set movie(Movie movie) {
    _movie = movie;
    notifyListeners();
  }

  Genres _genres;
  Genres get genres => _genres;

  set genres(Genres genres) {
    _genres = genres;
    notifyListeners();
  }

  /*Future<Genres>*/ getGenres() async {
    this.genres = await serviceProvider.getGenres();
    notifyListeners();
  }

  Future<void> getMovies(Category category) async {
    category.movies = await serviceProvider.getMovies(category);
    notifyListeners();
    // print('ya las tengo');
  }
}
