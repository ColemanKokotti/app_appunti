import 'package:appunti/screens/home_page.dart';
import 'package:appunti/themes/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Appunti',
      theme: AppTheme.darkTheme ,
      home: const HomePage(),
    );
  }
}


