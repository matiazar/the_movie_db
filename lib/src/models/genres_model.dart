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
