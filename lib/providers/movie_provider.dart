import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/providers/popular_movies_notifier.dart';
import 'package:movie_app/providers/top_rated_movies_notifier.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';

final movieServiceProvider = Provider<MovieService>((ref) {
  return MovieService();
});

final popularMoviesProvider = StateNotifierProvider<PopularMoviesNotifier, List<Movie>>((ref) {
  return PopularMoviesNotifier();
});

final topRatedMoviesProvider = StateNotifierProvider<TopRatedMoviesNotifier, List<Movie>>((ref) {
  return TopRatedMoviesNotifier();
});

final searchMoviesProvider = FutureProvider.family<List<Movie>, String>((ref, query) async {
  final movieService = ref.read(movieServiceProvider);
  final movieIds = await movieService.searchMovies(query);
  final movies = await Future.wait(movieIds.map((id) => movieService.fetchMovieDetails(id)));
  return movies;
});
