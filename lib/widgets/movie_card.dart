import 'package:flutter/material.dart';
import 'package:movie_app/models/movie.dart';

import '../screens/movie_details.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    void onMovieTap(Movie movie) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MovieDetailsScreen(movie: movie),
      ));
    }

    return InkWell(
      onTap: () => onMovieTap(movie),
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 150,
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: Image(
                  image: NetworkImage(movie.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              movie.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '${movie.starRating.toStringAsFixed(1)}/10 IMDb',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
