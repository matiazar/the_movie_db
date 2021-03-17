import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:the_movie_db/src/models/movies_model.dart';
import 'package:the_movie_db/src/pages/providers/movies_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _posterPath;

  @override
  Widget build(BuildContext context) {
    final moviesProvider = new MoviesProvider();
    // moviesProvider.getPopulars();

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            IconButton(
                tooltip: 'Populares',
                icon: Icon(Icons.star_border_outlined),
                onPressed: () {}),
            Spacer(),
            IconButton(
                tooltip: 'Ultimas',
                icon: Icon(Icons.movie_creation_outlined),
                onPressed: () {}),
          ],
        ),
      ),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.search), onPressed: () {}),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: _backgroundApp(context),
      ),
    );
  }

  _backgroundApp(context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image:
                  NetworkImage('https://image.tmdb.org/t/p/w500/$_posterPath'),
              fit: BoxFit.cover)),
      width: double.infinity,
      height: double.infinity,
      // color: Colors.red,
      child: ClipRRect(
        // make sure we apply clip it properly
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            alignment: Alignment.center,
            color: Colors.black.withOpacity(0.5),
            child: _estructuraHome(context),
          ),
        ),
      ),
    );
  }

  _estructuraHome(context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            'The Movie DB',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        Text(
          'Populares',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        Expanded(
            child: Center(
          child: _listadoPeliculas(),
        )),
      ],
    );
  }

  _listadoPeliculas() {
    final moviesProvider = new MoviesProvider();

    return FutureBuilder(
        future: moviesProvider.getPopulars(),
        builder: (context, AsyncSnapshot<List<Movie>> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          // print(snapshot);

          return PageView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) =>
                _verMovie(snapshot.data[index], context),
            onPageChanged: (index) {
              // print(index);
              setState(() {
                _posterPath = snapshot.data[index].posterPath;
              });
            },
          );
        });
  }

  _verMovie(Movie movie, context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: FadeInImage(
                    height: MediaQuery.of(context).size.height * .65,
                    fit: BoxFit.cover,
                    placeholder: AssetImage('assets/loading.gif'),
                    image: NetworkImage(
                        'https://image.tmdb.org/t/p/w500/${movie.posterPath}'))),
          ),
          Text(
            movie.title,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ],
      ),
    );
  }
}
