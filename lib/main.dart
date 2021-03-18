import 'package:flutter/material.dart';


import 'src/pages/home_page.dart';
import 'src/pages/details_page.dart';

void main() {
  runApp(MyApp());
}


// https://api.themoviedb.org/3/movie/popular?api_key=0e685fd77fb3d76874a3ac26e0db8a4b&language=es-AR&page=1

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

          headline5: TextStyle(fontSize: 22.0, color: Colors.white, ),

          subtitle1: TextStyle(fontSize: 20.0, color: Colors.white, fontFamily: 'Calibri',),
          subtitle2: TextStyle(fontSize: 18.0, color: Colors.white, fontFamily: 'Calibri',),
                  
          
        )
      ),
    );
  }
}

