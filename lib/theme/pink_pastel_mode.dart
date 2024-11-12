import 'package:flutter/material.dart';

ThemeData pinkPastelLightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Color(0xFFFEFBFF),        // tím nhạt sáng
    primary: Color(0xFFF9ECF3),        // hồng pastel nhạt
    secondary: Color(0xFFF2DDE0),      // hồng phấn nhẹ
    inversePrimary: Color(0xFFE3B5BC), // hồng đậm hơn một chút
    onSecondary: Color(0xFFD7A5B2),    // hồng tím nhạt hơn
  ),
  textTheme: ThemeData.light().textTheme.apply(
    bodyColor: Colors.pink[800],
    displayColor: Colors.pink[900],
  ),
);

ThemeData pinkPastelDarkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Color(0xFF4A3A3F),        // tím xám đậm
    primary: Color(0xFF6B4951),        // hồng tím đậm
    secondary: Color(0xFF8B6A74),      // hồng phấn tối
    inversePrimary: Color(0xFFF9ECF3), // hồng pastel nhạt
    onSecondary: Color(0xFFF2DDE0),    // tím nhạt hơn
  ),
  textTheme: ThemeData.dark().textTheme.apply(
    bodyColor: Colors.pink[100],
    displayColor: Colors.white,
  ),
);
