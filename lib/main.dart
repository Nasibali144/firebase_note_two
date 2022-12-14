


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_note_two/pages/detail_page.dart';
import 'package:firebase_note_two/pages/home_page.dart';
import 'package:firebase_note_two/pages/sign_in_page.dart';
import 'package:firebase_note_two/pages/sign_up_page.dart';
import 'package:firebase_note_two/services/auth_service.dart';
import 'package:firebase_note_two/services/db_service.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyFirebaseApp());
}

class MyFirebaseApp extends StatelessWidget {
  const MyFirebaseApp({Key? key}) : super(key: key);


  Widget _startPage() {
    return StreamBuilder<User?>(
      stream: AuthService.auth.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          DBService.saveUserId(snapshot.data!.uid);
          return HomePage();
        } else {
          DBService.removeUserId();
          return const SignInPage();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "My Firebase App Two",
      home: _startPage(),
      routes: {
        HomePage.id: (context) => HomePage(),
        SignInPage.id: (context) => const SignInPage(),
        SignUpPage.id: (context) => const SignUpPage(),
        DetailPage.id: (context) => const DetailPage(),
      },
    );
  }
}
