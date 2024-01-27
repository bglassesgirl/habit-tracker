import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/home_page.dart';

import 'package:habit_tracker/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
        theme: Provider.of<ThemeProvider>(context).themeData,
      );
  }
}
