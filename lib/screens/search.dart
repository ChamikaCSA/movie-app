import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/providers/movie_provider.dart';
import 'package:movie_app/widgets/movie_list_item.dart';

import '../models/movie.dart';
import 'movie_details.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({
    super.key,
    required this.query,
  });

  final String query;

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(searchMoviesProvider(widget.query));

    void onMovieTap(Movie movie) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MovieDetailsScreen(movie: movie),
      ));
    }

    return searchResults.when(
      data: (movies) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                onMovieTap(movies[index]);
              },
              borderRadius: BorderRadius.circular(16),
              child: MovieListItem(movie: movies[index]),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) {
        return const Center(
          child: Text('Failed to search movies'),
        );
      },
    );
  }
}
