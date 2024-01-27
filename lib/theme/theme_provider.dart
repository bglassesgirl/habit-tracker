import 'package:flutter/material.dart';
import 'dark_theme.dart';  // Corrigido o nome do arquivo
import 'light_theme.dart';


class ThemeProvider extends ChangeNotifier{

  // primeiro light mode
  ThemeData _themeData = lightMode;

  // pegar tema incial
  ThemeData get themeData => _themeData;

  // se o tema for dark
  bool get isDarkMode => _themeData == darkMode;

  // set theme
  set themeData(ThemeData themeData){
    _themeData = themeData;
    notifyListeners();
  }

  // mudar tema
  void toggleTheme(){
    if (_themeData == lightMode) {
        themeData = darkMode;
    } else {
        themeData = lightMode;
    }
  }
}