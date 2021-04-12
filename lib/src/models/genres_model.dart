class Genres {
  List<Genre> list = [];

  Genres({this.list});

  factory Genres.fromJson(List<dynamic> jsonList) {
    final List<Genre> genres = [];

    jsonList.forEach((json) {
      genres.add(Genre.fromJson(json));
    });

    return Genres(list: genres);
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
