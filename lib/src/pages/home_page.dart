import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:the_movie_db/src/models/movies_model.dart';
import 'package:the_movie_db/src/providers/movies_provider.dart';
import 'package:the_movie_db/src/search/search_delegate.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _posterPath;
  String _tipoPeliculas = 'Popular'; //Popular // Latest
  String _title = 'Populares';

  final moviesProvider = new MoviesProvider();
  // moviesProvider.getPopulars();
  List<Genre> genres;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Colors.transparent,
        child: Row(
          children: [
            IconButton(
                tooltip: 'Populares',
                icon: Icon(Icons.favorite),
                onPressed: () {
                  _title = 'Populares';
                  _tipoPeliculas = 'TopRated';
                  setState(() {});
                }),
            Spacer(),
            IconButton(
                tooltip: 'Ultimas',
                icon: Icon(Icons.movie),
                onPressed: () {
                  _title = 'Ultimas';
                  _tipoPeliculas = 'Latest';
                  setState(() {});
                }),
            Spacer(),
            IconButton(
                tooltip: 'Próximamente',
                icon: Icon(Icons.calendar_today),
                onPressed: () {
                  _title = 'Próximos Estrenos';
                  _tipoPeliculas = 'Upcoming';
                  setState(() {});
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.search),
          onPressed: () {
            showSearch(
              
              context: context,
              delegate: CustomSearchDelegate(),
            );
          }),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: ColorfulSafeArea(
        // overflowRules: OverflowRules.all(true),
        color: Colors.white.withOpacity(0.7),
        // filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: _backgroundApp(context),
      ),
    );
  }

  _backgroundApp(context) {
    return Container(
      decoration: BoxDecoration(
        // color: Colors.black,
        image: (_posterPath != null && _posterPath != 'null')
            ? DecorationImage(
                image: NetworkImage('${moviesProvider.imagePath}$_posterPath'),
                fit: BoxFit.cover)
            : null,
      ),
      width: double.infinity,
      height: double.infinity,
      // color: Colors.red,
      child: ClipRRect(
        // make sure we apply clip it properly
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            alignment: Alignment.center,
            color: Colors.black.withOpacity(0.4),
            child: _estructuraHome(context),
          ),
        ),
      ),
    );
  }

  _estructuraHome(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            'The Movie DB',
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text(
            _title,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        Expanded(
          child: Center(
            child: _listadoPeliculas(),
          ),
        ),
        _listadoGeneros(),
      ],
    );
  }

  _listadoGeneros() {
    return FutureBuilder(
        future: moviesProvider.getGenres(),
        builder: (context, AsyncSnapshot<List<Genre>> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return Container();
          }

          genres = snapshot.data;

          return Container();
        });
  }

  _listadoPeliculas() {
    return FutureBuilder(
        future: moviesProvider.getMovies(_tipoPeliculas),
        builder: (context, AsyncSnapshot<List<Movie>> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data.length > 0) {
            _posterPath = snapshot.data[0].posterPath;
            // print(snapshot);
            return Swiper(
              // controller: PageController(viewportFraction: 0.8),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) =>
                  _verMovie(snapshot.data[index], context),
              // itemCount: 3,
              viewportFraction: 0.7,
              scale: 0.6,
              // pagination: new SwiperPagination(),
              control: new SwiperControl(),
              // layout: SwiperLayout.TINDER,
              // itemHeight: MediaQuery.of(context).size.height * .6,
              // itemWidth: MediaQuery.of(context).size.height * .7,
              onIndexChanged: (index) {
                // print(index);
                setState(() {
                  _posterPath = snapshot.data[index].posterPath;
                });
              },
            );
          }

          return Container();

          // return PageView.builder(
          //   controller: PageController(viewportFraction: 0.8),
          //   itemCount: snapshot.data.length,
          //   itemBuilder: (context, index) =>
          //       _verMovie(snapshot.data[index], context),
          //   onPageChanged: (index) {
          //     // print(index);
          //     setState(() {
          //       _posterPath = snapshot.data[index].posterPath;
          //     });
          //   },
          // );
        });
  }

  _verMovie(Movie movie, context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'Details',
            arguments: {'movie': movie, 'genres': genres});
        // print(movie);
      },
      child: Center(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: FadeInImage(
                      height: MediaQuery.of(context).size.height * .6,
                      fit: BoxFit.cover,
                      placeholder: AssetImage('assets/loading.gif'),
                      image: NetworkImage(
                          'https://image.tmdb.org/t/p/w500/${movie.posterPath}'))),
            ),
            Text(
              movie.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
      ),
    );
  }
}
