import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          
          Text('Hello',
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
          const SizedBox(height: 10),
          Text('Welcome to FilmKu, where you can find your favorite movies',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
