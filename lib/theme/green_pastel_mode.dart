import 'package:flutter/material.dart';

ThemeData greenPastelLightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Color(0xFFD0F0E8),        // xanh pastel nhạt
    primary: Color(0xFFA0E4D0),        // xanh pastel nhạt hơn
    secondary: Color(0xFF85CEC7),      // xanh ngọc sáng
    inversePrimary: Color(0xFF4AA4A6), // xanh ngọc vừa phải
    onSecondary: Color(0xFF3A8587),    // xanh ngọc đậm
  ),
  textTheme: ThemeData.light().textTheme.apply(
    bodyColor: Colors.teal[800],       // Chữ tối hơn cho dễ đọc
    displayColor: Colors.teal[900],
  ),
);

ThemeData greenPastelDarkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Color(0xFF2E4F4F),        // xanh đậm tối
    primary: Color(0xFF3A6B6B),        // xanh đậm
    secondary: Color(0xFF518989),      // xanh ngọc tối
    inversePrimary: Color(0xFFA0E4D0), // xanh nhạt hơn
    onSecondary: Color(0xFF85CEC7),    // xanh xám nhạt
  ),
  textTheme: ThemeData.dark().textTheme.apply(
    bodyColor: Colors.teal[100],       // Chữ sáng cho dễ đọc
    displayColor: Colors.white,
  ),
);
