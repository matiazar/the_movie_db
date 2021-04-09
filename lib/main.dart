import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_db/src/models/movies_model.dart';
import 'package:the_movie_db/src/providers/navigation_provider.dart';
import 'package:the_movie_db/src/theme/theme.dart';

import 'src/pages/home_page.dart';
import 'src/pages/details_page.dart';
import 'src/providers/movies_provider.dart';

void main() {
  runApp(MyApp());
}

// https://api.themoviedb.org/3/movie/popular?api_key=0e685fd77fb3d76874a3ac26e0db8a4b&language=es-AR&page=1

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MoviesProvider()),
        ChangeNotifierProvider(create: (context) => NavigationProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'The Movie DB',
        initialRoute: 'Home',
        routes: {
          'Home': (BuildContext context) => HomePage(),
          'Details': (BuildContext context) => DetailsPage(),
        },
        theme: theme,
      ),
    );
  }
}
