import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final bool showButton;
  final VoidCallback onPressed;

  const SectionHeader({
    super.key,
    required this.title,
    required this.showButton,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            ),
        ),
        !showButton
            ? const SizedBox(height: 48)
            :
        OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            textStyle: const TextStyle(fontSize: 12),
            minimumSize: const Size(0, 0),
            side: BorderSide(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            foregroundColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          child: const Text('See more'),
        ),
      ],
    );
  }
}