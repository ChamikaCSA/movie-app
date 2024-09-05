import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  var _email = '';
  var _password = '';
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    bool isValidEmail(String email) {
      final RegExp emailRegExp =
          RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
      return emailRegExp.hasMatch(email);
    }

    void onLoginTap() async {
      final isValid = _formKey.currentState!.validate();
      if (!isValid) {
        return;
      }

      setState(() {
        _isLoading = true;
      });
      _formKey.currentState!.save();
      final response = await AuthService().login(
        email: _email,
        password: _password,
      );

      if (!context.mounted) {
        return;
      }

      if (response.isEmpty) {
        Navigator.of(context).pop();
        return;
      }

      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(
        msg: response,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        textColor: Theme.of(context).colorScheme.onSecondary,
        fontSize: 16.0,
      );
    }

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/login.svg',
                  height: 300,
                ),
                Text(
                  'Login',
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 36),
                TextFormField(
                  keyboardType: TextInputType.emailAddress  ,
                  decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!isValidEmail(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  onSaved: (value) => _email = value!,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  onSaved: (value) => _password = value!,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(6),
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 130,
                    height: 50,
                    child: FilledButton(
                      onPressed: _isLoading ? null : onLoginTap,
                      child: _isLoading
                          ? CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.onPrimary,
                            )
                          : const Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
