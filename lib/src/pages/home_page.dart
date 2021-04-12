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
  // SwiperController swiperController = new SwiperController();

  @override
  Widget build(BuildContext context) {
    print('build');

    return Scaffold(
      bottomNavigationBar: _navigationBar(context),
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
    final categories = Provider.of<MoviesProvider>(context).categories;
    final swiperController =
        Provider.of<MoviesProvider>(context).swiperController;

    return BottomNavigationBar(
      currentIndex: navigationProvider.index,
      onTap: (index) {
        // print(index);
        navigationProvider.index = index;
        swiperController.move(categories[index].index, animation: false);

        Provider.of<MoviesProvider>(context, listen: false)
            .getMovies(categories[index].url);
      },
      items: [
        BottomNavigationBarItem(
            label: categories[0].title, icon: Icon(Icons.favorite)),
        BottomNavigationBarItem(
            label: categories[1].title, icon: Icon(Icons.movie)),
        BottomNavigationBarItem(
            label: categories[2].title, icon: Icon(Icons.calendar_today)),
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
    final navigationProvider = Provider.of<NavigationProvider>(context);
    final categories = Provider.of<MoviesProvider>(context).categories;

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
            categories[navigationProvider.index].title,
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
    final navigationProvider = Provider.of<NavigationProvider>(context);
    final categories = Provider.of<MoviesProvider>(context).categories;
    final swiperController =
        Provider.of<MoviesProvider>(context).swiperController;

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
            categories[navigationProvider.index].index = index;
            Provider.of<MoviesProvider>(context, listen: false).movie =
                data.movies[index];
          },
        );
      },
    );
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

// class _listadoPeliculas extends StatelessWidget {
//   _listadoPeliculas({Key key}) : super(key: key);

//   SwiperController swiperController = new SwiperController();

//   @override
//   Widget build(BuildContext context) {
//     final navigationProvider = Provider.of<NavigationProvider>(context);
//     final categories = Provider.of<MoviesProvider>(context).categories;

//     return Consumer<MoviesProvider>(
//       builder: (context, data, child) {
//         if (data.movies == null) {
//           return Center(child: CircularProgressIndicator());
//         }

//         return Swiper(
//           controller: swiperController,
//           // controller: PageController(viewportFraction: 0.8),
//           itemCount: data.movies.length,
//           itemBuilder: (context, index) =>
//               _verMovie(data.movies[index], context),
//           // itemCount: 3,
//           viewportFraction: 0.7,
//           scale: 0.6,
//           // pagination: new SwiperPagination(),
//           control: new SwiperControl(),
//           // layout: SwiperLayout.TINDER,
//           // itemHeight: MediaQuery.of(context).size.height * .6,
//           // itemWidth: MediaQuery.of(context).size.height * .7,
//           onIndexChanged: (index) {
// // categories[navigationProvider.index].title,

//             // switch (_tipoPeliculas) {
//             //   case 'NowPlaying':
//             //     playingIndex = index;
//             //     break;
//             //   case 'Upcoming':
//             //     upcomingIndex = index;
//             //     break;
//             //   case 'Popular':
//             //     popularIndex = index;
//             //     break;
//             //   // default:
//             // }

//             Provider.of<MoviesProvider>(context, listen: false).movie =
//                 data.movies[index];
//           },
//         );
//       },
//     );
//   }

//   _verMovie(Movie movie, context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.pushNamed(context, 'Details', arguments: {'movie': movie});
//       },
//       child: Center(
//         child: Column(
//           children: [
//             Padding(
//               padding:
//                   const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
//               child: ClipRRect(
//                   borderRadius: BorderRadius.circular(15.0),
//                   child: FadeInImage(
//                       height: MediaQuery.of(context).size.height * .6,
//                       fit: BoxFit.cover,
//                       placeholder: AssetImage('assets/loading.gif'),
//                       image: NetworkImage(
//                           'https://image.tmdb.org/t/p/w500/${movie.posterPath}'))),
//             ),
//             Text(
//               movie.title,
//               textAlign: TextAlign.center,
//               style: Theme.of(context).textTheme.subtitle1,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
