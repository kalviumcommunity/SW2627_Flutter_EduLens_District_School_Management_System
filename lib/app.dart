import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';

class EduLensApp extends StatelessWidget {
  const EduLensApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduLens',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const Scaffold(
        body: Center(
          child: Text('Welcome to EduLens'),
        ),
      ),
    );
  }
}
