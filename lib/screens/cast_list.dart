import 'package:flutter/material.dart';

import '../models/movie.dart';

class CastListScreen extends StatelessWidget {
  final Movie movie;

  const CastListScreen({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cast'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 0.63,
        ),
        itemCount: movie.cast.length,
        itemBuilder: (context, index) {
          final cast = movie.cast[index];
          return Column(
            children: [
              Card(
                clipBehavior: Clip.antiAlias,
                child: cast.imageUrl != ''
                    ? Image.network(
                        cast.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 120,
                      )
                    : SizedBox(
                        width: double.infinity,
                        height: 120,
                        child: Icon(
                          Icons.person,
                          size: 100,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
              ),
              Text(
                cast.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
