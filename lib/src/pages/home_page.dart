import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';

import 'package:the_movie_db/src/models/movies_model.dart';
import 'package:the_movie_db/src/providers/navigation_provider.dart';
import 'package:the_movie_db/src/providers/movies_provider.dart';
import 'package:the_movie_db/src/search/search_delegate.dart';
// import 'package:the_movie_db/src/services/genres_service.dart';
import 'package:the_movie_db/src/widgets/background.dart';

class HomePage extends StatelessWidget {
  //
  String _tipoPeliculas = 'Popular'; //Popular // Latest
  String _title = 'Populares';

  int popularIndex = 0;
  int upcomingIndex = 0;
  int playingIndex = 0;

  // final genresService = new GenresService();
  // final moviesProvider = new MoviesProvider();

  SwiperController swiperController = new SwiperController();

  @override
  Widget build(BuildContext context) {
    print('build');
    // movieSelected = Provider.of<MovieSelected>(context); //, listen: false);

    // Provider.of<MoviesProvider>(context, listen: false).getGenres();
            

    // List<Genre> genres = genresService.items;

    return Scaffold(
      bottomNavigationBar: _navigationBar(context),

      // BottomAppBar(
      //   elevation: 0,
      //   color: Colors.transparent,
      //   child: Row(
      //     children: [
      //       IconButton(
      //           tooltip: 'Populares',
      //           icon: Icon(Icons.favorite),
      //           onPressed: () {
      //             setState(() {
      //               _title = 'Populares';
      //               _tipoPeliculas = 'Popular';
      //             });
      //           }),
      //       Spacer(),
      //       // IconButton(
      //       //     tooltip: 'Ultimas',
      //       //     icon: Icon(Icons.movie),
      //       //     onPressed: () {
      //       //       _title = 'Ultimas';
      //       //       _tipoPeliculas = 'Latest';
      //       //       setState(() {});
      //       //     }),
      //       // Spacer(),
      //       IconButton(
      //           tooltip: 'En Cine',
      //           icon: Icon(Icons.movie),
      //           onPressed: () {
      //             setState(() {
      //               _title = 'En Cine';
      //               _tipoPeliculas = 'NowPlaying';
      //             });
      //           }),
      //       Spacer(),
      //       IconButton(
      //           tooltip: 'Próximamente',
      //           icon: Icon(Icons.calendar_today),
      //           onPressed: () {
      //             setState(() {
      //               _title = 'Próximos Estrenos';
      //               _tipoPeliculas = 'Upcoming';
      //             });
      //           }),
      //     ],
      //   ),
      // ),
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

  BottomNavigationBar _navigationBar(context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);

    return BottomNavigationBar(
      currentIndex: navigationProvider.index,
      onTap: (index) {
        // print(index);
        navigationProvider.index = index;

        switch (index) {
          case 1:
            _title = 'En Cine';
            _tipoPeliculas = 'NowPlaying';
            swiperController.move(playingIndex, animation: false);
            break;

          case 2:
            _title = 'Próximos Estrenos';
            _tipoPeliculas = 'Upcoming';
            swiperController.move(upcomingIndex, animation: false);
            break;
          default:
            _title = 'Populares';
            _tipoPeliculas = 'Popular';
            swiperController.move(popularIndex, animation: false);
            break;
          // default:
        }

        Provider.of<MoviesProvider>(context, listen: false)
            .getMovies(_tipoPeliculas);
      },
      items: [
        BottomNavigationBarItem(label: 'Populares', icon: Icon(Icons.favorite)),
        BottomNavigationBarItem(label: 'En Cine', icon: Icon(Icons.movie)),
        BottomNavigationBarItem(
            label: 'Próximamente', icon: Icon(Icons.calendar_today)),
      ],
    );
  }

  _backgroundApp(context) {
    final String imageUrl = Provider.of<MoviesProvider>(context).imagePath;
    // String image = movieSelected?.movie?.posterPath;

    // if (image != null) image = imageUrl + image;

    return Stack(
      children: [
        Consumer<MoviesProvider>(builder: (context, data, child) {
          String image = data?.movie?.posterPath;
          if (image != null) image = imageUrl + image;
          return BackgroundWidget(image: image);
        }),
        _estructuraHome(context),
      ],
    );
  }

  _estructuraHome(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
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
            child: _listadoPeliculas(context),
          ),
        ),
      ],
    );
  }

  _listadoPeliculas(context) {
    return Consumer<MoviesProvider>(
      builder: (context, data, child) {
        if (data.movies == null) {
          return Center(child: CircularProgressIndicator());
        }

        return Swiper(
          controller: swiperController,
          // controller: PageController(viewportFraction: 0.8),
          itemCount: data.movies.length,
          itemBuilder: (context, index) =>
              _verMovie(data.movies[index], context),
          // itemCount: 3,
          viewportFraction: 0.7,
          scale: 0.6,
          // pagination: new SwiperPagination(),
          control: new SwiperControl(),
          // layout: SwiperLayout.TINDER,
          // itemHeight: MediaQuery.of(context).size.height * .6,
          // itemWidth: MediaQuery.of(context).size.height * .7,
          onIndexChanged: (index) {
            switch (_tipoPeliculas) {
              case 'NowPlaying':
                playingIndex = index;
                break;
              case 'Upcoming':
                upcomingIndex = index;
                break;
              case 'Popular':
                popularIndex = index;
                break;
              // default:
            }

            Provider.of<MoviesProvider>(context, listen: false).movie =
                data.movies[index];
          },
        );
      },
    );

    // return FutureBuilder(
    //     future: moviesProvider.getMovies(_tipoPeliculas),
    //     builder: (context, AsyncSnapshot<List<Movie>> snapshot) {
    //       if (snapshot.hasError) {
    //         return Center(child: Text("${snapshot.error}"));
    //       } else if (!snapshot.hasData) {
    //         return Center(child: CircularProgressIndicator());
    //       }

    //       if (snapshot.data.length > 0) {
    //         // moviesBloc.changeMovie(snapshot.data[0]);
    //         // movieSelected.movie = snapshot.data[0];
    //         // movieSelected.selected = context.read<Movie>();
    //         //
    //         // Provider.of<MovieSelected>(context, listen: false)
    //         //         .assignMovie(movie: snapshot.data[0]);

    //         // print(snapshot);
    //         return Swiper(
    //           controller: swiperController,
    //           // controller: PageController(viewportFraction: 0.8),
    //           itemCount: snapshot.data.length,
    //           itemBuilder: (context, index) =>
    //               _verMovie(snapshot.data[index], context),
    //           // itemCount: 3,
    //           viewportFraction: 0.7,
    //           scale: 0.6,
    //           // pagination: new SwiperPagination(),
    //           control: new SwiperControl(),
    //           // layout: SwiperLayout.TINDER,
    //           // itemHeight: MediaQuery.of(context).size.height * .6,
    //           // itemWidth: MediaQuery.of(context).size.height * .7,
    //           onIndexChanged: (index) {
    //             // print(index);
    //             // print(_tipoPeliculas);

    //             switch (_tipoPeliculas) {
    //               case 'NowPlaying':
    //                 playingIndex = index;
    //                 break;
    //               case 'Upcoming':
    //                 upcomingIndex = index;
    //                 break;
    //               case 'Popular':
    //                 popularIndex = index;
    //                 break;
    //               // default:
    //             }

    //             // moviesBloc.changeMovie(snapshot.data[index]);
    //             // movieSelected.movie = snapshot.data[index];
    //             // Provider.of<MovieSelected>(context, listen: false).movie = snapshot.data[index];
    //             //
    //             //
    //             //
    //             Provider.of<MovieSelected>(context, listen: false)
    //                 .assignMovie(movie: snapshot.data[index]);

    //             // _posterPath = snapshot.data[index].posterPath;

    //             // BackgroundWidget().refresh();

    //             // if (backWidget.currentState != null)
    //             //   backWidget.currentState.setState(() {
    //             //     _posterPath = snapshot.data[index].posterPath;
    //             //   });
    //             // setState(() {
    //             // _posterPath = snapshot.data[index].posterPath;
    //             // });
    //           },
    //         );
    //       }

    //       return Container();
    //     });
  }

  _verMovie(Movie movie, context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'Details', arguments: {'movie': movie});
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
