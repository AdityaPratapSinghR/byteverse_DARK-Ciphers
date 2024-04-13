import 'package:app/mainPage.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SignInScreen(
              providers: [
                EmailAuthProvider(),
              ],
              subtitleBuilder: (context, action) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: action == AuthAction.signIn
                    ? const Text('Welcome to StudyTube \n Test Id: test@gmail.com, \n Test Password: test123',style: TextStyle(fontWeight: FontWeight.bold),)
                    : const Text('Test Id: test@gmail.com, \n Test Password: test123', style: TextStyle(fontWeight: FontWeight.bold),),
                );
              },
            );
          }
          return const MainPage();
        },
    );
  }
}
