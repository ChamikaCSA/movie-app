import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../screens/movie_details.dart';

class MovieListItem extends StatelessWidget {
  final Movie movie;

  const MovieListItem({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    String formatDuration(int minutes) {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      return '${hours}h ${remainingMinutes}m';
    }

    void onMovieTap(Movie movie) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MovieDetailsScreen(movie: movie),
      ));
    }

    return InkWell(
      onTap: () => onMovieTap(movie),
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: double.infinity,
        height: 140,
        child: Row(
          children: [
            Card(
              clipBehavior: Clip.antiAlias,
              child: movie.imageUrl != ''
                  ? Image.network(
                      movie.imageUrl,
                      width: 100,
                      height: 140,
                      fit: BoxFit.cover,
                    )
                  : Center(
                      child: Icon(
                        Icons.movie,
                        size: 100,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
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
                  const SizedBox(height: 8),
                  Wrap(
                    children: movie.genres.take(2).map((genre) {
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          genre.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.8),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        formatDuration(movie.duration),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
