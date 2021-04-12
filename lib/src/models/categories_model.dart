import 'movies_model.dart';

class Category {
  final String title;
  final String url;
  int index = 0;
  Movies movies;

  Category({this.title, this.url, this.index = 0, this.movies});
}
