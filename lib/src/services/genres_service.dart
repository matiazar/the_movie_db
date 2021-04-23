import 'package:the_movie_db/src/providers/service_provider.dart';

class GenresService {
  Genres _genres;

  static final GenresService _singleton = new GenresService._internal();

  factory GenresService() => _singleton;

  GenresService._internal() {
    // Obtener los Generos
    _obtenerGeneros();
  }

  Genres get genres => _genres;

  void _obtenerGeneros() async {
    final serviceProvider = new ServiceProvider();
    _genres = await serviceProvider.getGenres();
  }
}
