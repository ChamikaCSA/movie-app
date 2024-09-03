import 'actor.dart';

const Map<String, String> languageMap = {
  'en': 'English',
  'es': 'Spanish',
  'fr': 'French',
  'de': 'German',
  'it': 'Italian',
  'pt': 'Portuguese',
  'ja': 'Japanese',
  'ko': 'Korean',
  'zh': 'Chinese',
  'ar': 'Arabic',
};

class Movie {
  final int id;
  final String title;
  final String imageUrl;
  final double starRating;
  final List<String> genres;
  final int duration;
  final String language;
  final String contentRating;
  final String description;
  final List<Actor> cast;
  final String trailerUrl;

  const Movie({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.starRating,
    required this.genres,
    required this.duration,
    required this.language,
    required this.contentRating,
    required this.description,
    required this.cast,
    required this.trailerUrl,
  });


  factory Movie.fromJson(Map<String, dynamic> json, List<Actor> cast) {
    var imageUrl = '';
    if (json['poster_path'] != null) {
      imageUrl = 'https://image.tmdb.org/t/p/w500${json['poster_path']}';
    }

    var trailerUrl = '';
    if (json['backdrop_path'] != null) {
      trailerUrl = 'https://image.tmdb.org/t/p/w500${json['backdrop_path']}';
    }
    
    return Movie(
      id: json['id'],
      title: json['title'],
      imageUrl: imageUrl,
      starRating: json['vote_average'].toDouble(),
      genres: (json['genres'] as List<dynamic>)
          .map((e) => e['name'] as String)
          .toList(),
      duration: (json['runtime'] ?? 0) as int,
      language: json['original_language'] != null
          ? languageMap[json['original_language']] ?? 'Unknown'
          : 'Unknown',
      contentRating: json['adult'] ? 'R-Rated' : 'PG-13',
      description: json['overview'],
      cast: cast,
      trailerUrl: trailerUrl,
    );
  }
}
