import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/services/movie_service.dart';

class TopRatedMoviesNotifier extends StateNotifier<List<Movie>> {
  TopRatedMoviesNotifier() : super([]);
  var page = 1;

  Future<List<Movie>> getInitialTopRatedMovies() async {
    final movieService = MovieService();
    final movieIds = await movieService.fetchTopRatedMovies(page);
    final movies = await Future.wait(movieIds.map((id) => movieService.fetchMovieDetails(id)));
    state = movies;
    return state;
  }

  getNextTopRatedMovies() async {
    page++;
    final movieService = MovieService();
    final movieIds = await movieService.fetchTopRatedMovies(page);
    final movies = await Future.wait(movieIds.map((id) => movieService.fetchMovieDetails(id)));
    state = [...state, ...movies];
  }
}
