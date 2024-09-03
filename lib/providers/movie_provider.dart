import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';

final movieServiceProvider = Provider<MovieService>((ref) {
  return MovieService();
});

final popularMoviesProvider = FutureProvider.family<List<Movie>, int>((ref, page) async {
  final movieService = ref.read(movieServiceProvider);
  final movieIds = await movieService.fetchPopularMovies(page);
  final movies = await Future.wait(movieIds.map((id) => movieService.fetchMovieDetails(id)));
  return movies;
});

final topRatedMoviesProvider = FutureProvider.family<List<Movie>, int>((ref, page) async {
  final movieService = ref.read(movieServiceProvider);
  final movieIds = await movieService.fetchTopRatedMovies(page);
  final movies = await Future.wait(movieIds.map((id) => movieService.fetchMovieDetails(id)));
  return movies;
});

final searchMoviesProvider = FutureProvider.family<List<Movie>, String>((ref, query) async {
  final movieService = ref.read(movieServiceProvider);
  final movieIds = await movieService.searchMovies(query);
  final movies = await Future.wait(movieIds.map((id) => movieService.fetchMovieDetails(id)));
  return movies;
});