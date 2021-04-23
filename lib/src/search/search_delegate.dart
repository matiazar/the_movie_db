import 'package:flutter/material.dart';
import 'package:the_movie_db/src/providers/service_provider.dart';

class CustomSearchDelegate extends SearchDelegate {
  final serviceProvider = new ServiceProvider();

  @override
  String get searchFieldLabel => "Buscador de Películas";

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Debe ingresar mas de 2 letras.",
            ),
          )
        ],
      );
    }

    return Column();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.

    if (query == '') return Container();

    return FutureBuilder(
        future: serviceProvider.search(query),
        builder: (context, AsyncSnapshot<Movies> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data.list.length == 0)
            return Center(
                child:
                    Text('No se encontraron peliculas con la frase "$query".'));

          return ListView(
            children: snapshot.data.list.map((movie) {
              return ListTile(
                trailing: Icon(Icons.arrow_forward),
                title: Text(
                  '${movie.title}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, 'Details',
                      arguments: {'movie': movie, 'genres': null});
                },
              );
            }).toList(),
          );

          // return ListView.builder(
          //   itemCount: snapshot.data.length,
          //   itemBuilder: (context, index) {
          //     Movie movie = snapshot.data[index];
          //     return ListTile(
          //       trailing: Icon(Icons.arrow_forward),
          //       title: Text(
          //         '${movie.title}',
          //         overflow: TextOverflow.ellipsis,
          //         style: TextStyle(
          //           color: Colors.black,
          //           fontSize: 18,
          //         ),
          //       ),
          //       onTap: () {
          //         Navigator.pushNamed(context, 'Details',
          //             arguments: {'movie': movie, 'genres': null});
          //       },
          //     );
          //   },
          // );
        });
  }
}
