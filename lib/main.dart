import 'package:umd_dining/pages/confirm_email.dart';
import 'package:umd_dining/pages/home.dart';
import 'package:umd_dining/pages/signin.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:umd_dining/pages/create_password.dart';
import 'package:umd_dining/pages/splash_page.dart';
import 'package:umd_dining/pages/start.dart';

// TODO: APPLE AUTH ONCE I GET DEVELOPER
Future<void> main() async {
  await Supabase.initialize(
    url: 'https://plximrqrwrpqshptjfkq.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBseGltcnFyd3JwcXNocHRqZmtxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDc3OTQzMzAsImV4cCI6MjAyMzM3MDMzMH0.8F6V5aYRUHnL1coZ8IbaVxJX1Dhw2I_bDgkjHqrmrU8',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: SignInPage(),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (context) => const SplashPage(),
        '/signin': (context) => const SignInPage(),
        '/signup': (context) => const CreatePasswordPage(),
        '/home': (context) => const HomePage(),
        '/confirm': (context) => const ConfirmEmailPage(),
        '/start': (context) => const StartPage(),
      },
    );
  }
}
