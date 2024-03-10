import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      home: HomePage(),
    );
  }
}
