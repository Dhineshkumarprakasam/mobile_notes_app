import 'package:flutter/material.dart';
import 'package:mobile_notes_app/screen/home_page.dart';

import 'mytheme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: AppTheme.light, home: HomePage());
  }
}
