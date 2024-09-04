import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/services/movie_service.dart';

class PopularMoviesNotifier extends StateNotifier<List<Movie>> {
  PopularMoviesNotifier() : super([]);
  var page = 1;

  Future<List<Movie>> getInitialPopularMovies() async {
    final movieService = MovieService();
    final movieIds = await movieService.fetchPopularMovies(page);
    final movies = await Future.wait(movieIds.map((id) => movieService.fetchMovieDetails(id)));
    state = movies;
    return state;
  }

  getNextPopularMovies() async {
    page++;
    final movieService = MovieService();
    final movieIds = await movieService.fetchPopularMovies(page);
    final movies = await Future.wait(movieIds.map((id) => movieService.fetchMovieDetails(id)));
    state = [...state, ...movies];
  }

  void reset() {
    state = [];
    page = 1;
  }
}