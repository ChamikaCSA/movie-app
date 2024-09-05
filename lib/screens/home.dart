import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/providers/movie_provider.dart';
import 'package:movie_app/widgets/movie_list_item.dart';

import '../widgets/movie_card.dart';
import '../widgets/section_header.dart';
import 'movie_list.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    ref.read(popularMoviesProvider.notifier).getInitialPopularMovies();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(topRatedMoviesProvider.notifier).getNextTopRatedMovies();
    }
  }

  @override
  Widget build(BuildContext context) {
    final popularMovies = ref.watch(popularMoviesProvider);

    void onSeeMoreTap() {
      ref.read(popularMoviesProvider.notifier).reset();
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const MovieListScreen(),
      ));
    }

    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SectionHeader(
              title: 'Popular',
              showButton: true,
              onPressed: () {
                onSeeMoreTap();
              },
            ),
          ),
          SizedBox(
            height: 300,
            child: popularMovies.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.only(left: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: popularMovies.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: MovieCard(movie: popularMovies[index]),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SectionHeader(
              title: 'Top Rated',
              showButton: false,
              onPressed: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: FutureBuilder(
              future: ref
                  .read(topRatedMoviesProvider.notifier)
                  .getInitialTopRatedMovies(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Failed to load movies'));
                } else {
                  return Consumer(
                    builder: (context, ref, _) {
                      final topRatedMovies = ref.watch(topRatedMoviesProvider);
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: topRatedMovies.length + 1,
                        itemBuilder: (context, index) {
                          if (index == topRatedMovies.length) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          else {
                            return MovieListItem(movie: topRatedMovies[index]);
                          }
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
