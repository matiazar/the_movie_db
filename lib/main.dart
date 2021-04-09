import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_db/src/models/movies_model.dart';
import 'package:the_movie_db/src/models/navigation_model.dart';

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
        ChangeNotifierProvider(create: (context) => MovieSelected()),
        ChangeNotifierProvider(create: (context) => NavigationModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'The Movie DB',
        initialRoute: 'Home',
        routes: {
          'Home': (BuildContext context) => HomePage(),
          'Details': (BuildContext context) => DetailsPage(),
          // 'Result': (BuildContext context) => ResultPage(),
          // 'Search': (BuildContext context) => SearchPage(),
        },
        theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: TextTheme(
              headline3: TextStyle(
                color: Colors.white,
              ),
              headline5: TextStyle(
                fontSize: 22.0,
                color: Colors.white,
              ),
              subtitle1: TextStyle(
                fontSize: 24.0,
                color: Colors.white,
                fontFamily: 'Calibri',
              ),
              subtitle2: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
                fontFamily: 'Calibri',
              ),
            )),
      ),
    );
  }
}
