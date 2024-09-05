import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/providers/movie_provider.dart';

import '../models/movie.dart';
import '../widgets/movie_card.dart';

class MovieListScreen extends ConsumerStatefulWidget {
  const MovieListScreen({
    super.key,
  });

  @override
  ConsumerState<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends ConsumerState<MovieListScreen> {
  final _isScrollNotifier = ValueNotifier<bool>(false);
  final _pageController = PageController();
  final _scrollController = ScrollController();
  final _moviesPerPage = 18;
  int _pageLength = 0;
  int _pageNumber = 1;
  List<Movie> movies = [];

  void _onPreviousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onNextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    bool isScrolled = _scrollController.position.pixels >
        _scrollController.position.minScrollExtent;
    if (isScrolled != _isScrollNotifier.value) {
      _isScrollNotifier.value = isScrolled;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    _isScrollNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
      ),
      body: FutureBuilder(
        future: ref
            .read(popularMoviesProvider.notifier)
            .getInitialPopularMovies()
            .then((value) => _pageLength = value.length ~/ _moviesPerPage),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Failed to load movies'),
            );
          } else {
            return Consumer(
              builder: (context, ref, _) {
                return Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (pageIndex) {
                          _pageNumber = pageIndex + 1;
                          if (pageIndex == _pageLength) {
                            ref
                                .read(popularMoviesProvider.notifier)
                                .getNextPopularMovies();
                            _pageLength =
                                (movies.length / _moviesPerPage).ceil();
                          }
                        },
                        itemCount: _pageLength + 1,
                        itemBuilder: (context, pageIndex) {
                          if (pageIndex == _pageLength) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          movies = ref.watch(popularMoviesProvider);
                          final startIndex = pageIndex * _moviesPerPage;
                          final endIndex = (startIndex + _moviesPerPage)
                              .clamp(0, movies.length);
                          final pageMovies =
                              movies.sublist(startIndex, endIndex);
                          return GridView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(20),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 4,
                              crossAxisSpacing: 16,
                              crossAxisCount: 3,
                              childAspectRatio: 0.45,
                            ),
                            itemCount: pageMovies.length,
                            itemBuilder: (context, index) {
                              return MovieCard(
                                movie: pageMovies[index],
                              );
                            },
                          );
                        },
                      )
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: _isScrollNotifier,
                      builder: (context, isScrolled, child) {
                        return isScrolled
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    IconButton(
                                      icon:
                                          const Icon(Icons.arrow_back_ios_new),
                                      onPressed: _onPreviousPage,
                                    ),
                                    Text(
                                      '$_pageNumber',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.arrow_forward_ios),
                                      onPressed: _onNextPage,
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink();
                      },
                    )
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
