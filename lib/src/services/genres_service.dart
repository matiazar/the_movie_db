import 'package:the_movie_db/src/providers/movies_provider.dart';

class GenresService {
  List<Genre> _items = [];

  static final GenresService _singleton = new GenresService._internal();

  factory GenresService() => _singleton;

  GenresService._internal() {
    // Obtener los Generos
    _obtenerGeneros();
  }

  List<Genre> get items => _items;

  void _obtenerGeneros() async {
    final moviesProvider = new MoviesProvider();
    _items = await moviesProvider.getGenres();
  }
}
