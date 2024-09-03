import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/providers/movie_provider.dart';
import 'package:movie_app/widgets/movie_list_item.dart';

import '../models/movie.dart';
import '../widgets/movie_card.dart';
import '../widgets/section_header.dart';
import 'movie_details.dart';
import 'movie_list.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final popularMoviesAsyncValue = ref.watch(popularMoviesProvider(1));
    final topRatedMoviesAsyncValue = ref.watch(topRatedMoviesProvider(1));

    void onMovieTap(Movie movie) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MovieDetailsScreen(movie: movie),
      ));
    }

    void onSeeMoreTap(AsyncValue<List<Movie>> moviesAsyncValue, String title) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MovieListScreen(
          moviesAsyncValue: moviesAsyncValue,
          title: title,
        ),
      ));
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SectionHeader(
              title: 'Popular',
              buttonText: 'See More',
              onPressed: () {
                onSeeMoreTap(popularMoviesAsyncValue, 'Popular');
              },
            ),
          ),
          SizedBox(
            height: 300,
            child: popularMoviesAsyncValue.when(
              data: (movies) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 18),
                      child: InkWell(
                          onTap: () {
                            onMovieTap(movies[index]);
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: MovieCard(movie: movies[index])),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) =>
                  const Center(child: Text('Failed to load movies')),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SectionHeader(
              title: 'Top Rated',
              buttonText: 'See More',
              onPressed: () {
                onSeeMoreTap(topRatedMoviesAsyncValue, 'Top Rated');
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: topRatedMoviesAsyncValue.when(
              data: (movies) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () {
                          onMovieTap(movies[index]);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: MovieListItem(movie: movies[index]));
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) =>
                  const Center(child: Text('Failed to load movies')),
            ),
          ),
        ],
      ),
    );
  }
}
