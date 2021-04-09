import 'package:flutter/cupertino.dart';

class MovieSelected extends ChangeNotifier {
  Movie _movie = new Movie();

  Movie get movie => _movie;

  set movie(Movie movie) {
    _movie = movie;
    notifyListeners();
  }
}

class Movies {
  List<Movie> items = [];

  Movies();

  Movies.fromJson(List<dynamic> jsonList) {
    if (jsonList == null) return;

    jsonList.forEach((json) {
      Movie movie = Movie.fromJson(json);
      items.add(movie);
    });
  }
}

// class Movie extends ChangeNotifier {
  // Movie _selected;

  // Movie get selected => _selected;

  // set selected(Movie movie) {
  //   _selected = movie;
  //   notifyListeners();
  // }
class Movie {
  Movie({
    this.adult,
    this.backdropPath,
    this.genreIds,
    this.id,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.releaseDate,
    this.title,
    this.video,
    this.voteAverage,
    this.voteCount,
  });

  bool adult;
  String backdropPath;
  List<int> genreIds;
  int id;
  String originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  String posterPath;
  DateTime releaseDate;
  String title;
  bool video;
  double voteAverage;
  int voteCount;

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        adult: json["adult"],
        backdropPath: json["backdrop_path"],
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        id: json["id"],
        originalLanguage: json["original_language"],
        originalTitle: json["original_title"],
        overview: json["overview"],
        popularity: json["popularity"].toDouble(),
        posterPath: json["poster_path"],
        releaseDate:
            (json["release_date"] == '' || json["release_date"] == null)
                ? null
                : DateTime.parse(json["release_date"]),
        title: json["title"],
        video: json["video"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
      );

  Map<String, dynamic> toJson() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
        "id": id,
        "original_language": originalLanguage,
        "original_title": originalTitle,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "release_date":
            "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
        "title": title,
        "video": video,
        "vote_average": voteAverage,
        "vote_count": voteCount,
      };
}

class Genres {
  List<Genre> items = [];

  Genres();

  Genres.fromJson(List<dynamic> jsonList) {
    if (jsonList == null) return;

    jsonList.forEach((json) {
      Genre genre = Genre.fromJson(json);
      items.add(genre);
    });
  }
}

class Genre {
  Genre({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
