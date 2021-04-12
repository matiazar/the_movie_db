import 'package:flutter/material.dart';

// import 'package:the_movie_db/src/models/movies_model.dart';
import 'package:the_movie_db/src/providers/movies_provider.dart';
import 'package:the_movie_db/src/services/genres_service.dart';

import 'package:the_movie_db/src/widgets/video_player.dart';

class DetailsPage extends StatelessWidget {
  // DetailsPage({Key key}) : super(key: key);

  final moviesProvider = new MoviesProvider();

  Movie movie;

  final genresService = new GenresService();

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;

    movie = args['movie'];
    // genres = args['genres'];
    // genres = genresService.items;

    // final Movie movie = args['movie'];
    // final List<Genre> genres = args['genres'];

    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: ListView(children: [
          _poster(),
          _posterInfo(),
          _descripcion(),
          _actores(),
          _video(),
          SizedBox(
            height: 70.0,
          )
        ]),
      ),
    );
  }

  _posterInfo() {
    return Container(
      // color: Colors.blue,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _imagen(),
          SizedBox(width: 10),
          Flexible(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _titulo(),
                  SizedBox(height: 5),
                  _generos(),
                  SizedBox(height: 5),
                  _promedio(),
                ]),
          ),
        ],
      ),
    );
  }

  _descripcion() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumen',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            movie.overview,
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  _actores() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Elenco',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          _actoresListado(),
        ],
      ),
    );
  }

  _actoresListado() {
    return FutureBuilder(
        future: moviesProvider.getCast(movie),
        builder: (context, AsyncSnapshot<List<Cast>> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return SizedBox(
            height: 150,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) =>
                    _actor(snapshot.data[index])),
          );
        });
  }

  Widget _actor(Cast cast) {
    return Container(
      width: 100,
      padding: const EdgeInsets.only(right: 6),
      child: Column(
        children: [
          (cast.profilePath != null)
              ? FadeInImage(
                  placeholder: AssetImage('assets/default_profile.png'),
                  image: NetworkImage(
                      '${moviesProvider.imagePath}${cast.profilePath}'),
                  height: 120,
                  width: 100,
                  fit: BoxFit.fill,
                )
              : Image.asset('assets/default_profile.png',
                  height: 120, width: 100, fit: BoxFit.cover),
          Flexible(
            child: Text(
              cast.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  _video() {
    //  print(movie.video);

    // seccion al fadi porque ninguna tiene video !!!

    if (movie.video == false) return Container();

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: VideoPlayerScreen(),
    );
  }

  _poster() {
    return Image.network('${moviesProvider.imagePath}${movie.backdropPath}');
  }

  _imagen() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Image.network(
        '${moviesProvider.imagePath}${movie.posterPath}',
        fit: BoxFit.cover,
        width: 150.0,
      ),
    );
  }

  _titulo() {
    return Container(
      // color: Colors.red,
      width: double.infinity,
      child: Text(
        '${movie.title} (${movie.releaseDate.year.toString().padLeft(4, '0')})',
        style: TextStyle(fontSize: 22),
        textAlign: TextAlign.start,
      ),
    );
  }

  _generos() {
    List tmpStrings = [];
    movie.genreIds.forEach((genreId) {
      Genre genre =
          genresService.genres.list.firstWhere((element) => element.id == genreId);

      tmpStrings.add(genre.name);
    });

    if (tmpStrings.length == 0) return Container();

    String s = tmpStrings.join(', ');
    return Text(s, style: TextStyle(fontSize: 16));
  }

  _promedio() {
    return Row(
      children: [
        Icon(Icons.star_border),
        Text(
            '${movie.voteAverage.toString()} de un total de ${movie.voteCount} votos'),
      ],
    );
  }
}
