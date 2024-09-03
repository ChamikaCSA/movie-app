import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/movie.dart';
import '../widgets/movie_card.dart';
import 'movie_details.dart';

class MovieListScreen extends StatelessWidget {
  final AsyncValue<List<Movie>> moviesAsyncValue;
  final String title;

  const MovieListScreen({
    super.key,
    required this.moviesAsyncValue,
    required this.title,
  });
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: moviesAsyncValue.when(
          data: (movies) {
            return GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, 
                crossAxisSpacing: 10.0, 
                mainAxisSpacing: 10.0, 
                childAspectRatio: 0.45, 
              ),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MovieDetailsScreen(movie: movies[index]),
                    ));
                  },
                  child: MovieCard(movie: movies[index]),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
        ),
    );
  }
}