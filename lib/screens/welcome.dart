import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_app/screens/login.dart';
import 'package:movie_app/screens/sign_up.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void onLoginTap() {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ));
    }

    void onSignUpTap() {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ));
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/welcome.svg',
            width: 300,
            height: 300,
          ),
          const SizedBox(height: 44),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 68),
            child: Column(
              children: [
                Text(
                  'Hello',
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 10),
                Text('Welcome to FilmKu, where you\'ll find your favorite movies',
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                    textAlign: TextAlign.center),
                const SizedBox(height: 44),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton(
                    onPressed: onLoginTap,
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: onSignUpTap,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    child: const Text('Sign Up',
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
