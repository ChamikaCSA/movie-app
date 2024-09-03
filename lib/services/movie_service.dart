import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/actor.dart';
import '../models/movie.dart';

class MovieService {
  final String apiKey = dotenv.env['API_KEY']!;
  final String baseUrl = dotenv.env['BASE_URL']!;

  Future<List<int>> fetchTopRatedMovies(page) async {
    final response = await http.get(Uri.parse('$baseUrl/movie/top_rated?page=$page&api_key=$apiKey'));

    if (response.statusCode == 200) {
      final List<dynamic> movies = json.decode(response.body)['results'];
      return movies.map<int>((movie) => movie['id'] as int).toList();
    } else {
      throw Exception('Failed to load top rated movies');
    }
  }

  Future<List<int>> fetchPopularMovies(page) async {
    final response = await http.get(Uri.parse('$baseUrl/movie/popular?page=$page&api_key=$apiKey'));

    if (response.statusCode == 200) {
    final List<dynamic> movies = json.decode(response.body)['results'];
      return movies.map<int>((movie) => movie['id'] as int).toList();
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  Future<Movie> fetchMovieDetails(int movieId) async {
    final detailsResponse = await http.get(Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey'));
    final creditsResponse = await http.get(Uri.parse('$baseUrl/movie/$movieId/credits?api_key=$apiKey'));

    if (detailsResponse.statusCode == 200 && creditsResponse.statusCode == 200) {
    final detailsData = json.decode(detailsResponse.body);
    final creditsData = json.decode(creditsResponse.body);

      final cast = (creditsData['cast'] as List<dynamic>)
        .map((e) => Actor.fromJson(e as Map<String, dynamic>))
        .toList();

    return Movie.fromJson(detailsData, cast);
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  Future<List<int>> searchMovies(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/search/movie?query=$query&api_key=$apiKey'));

    if (response.statusCode == 200) {
      final List<dynamic> movies = json.decode(response.body)['results'];
      return movies.map<int>((movie) => movie['id'] as int).toList();
    } else {
      throw Exception('Failed to search movies');
    }
  }
}