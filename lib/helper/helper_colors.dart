import 'package:emodiary/database/entity.dart';
import 'package:flutter/material.dart';

Color mixColorsFromTag(List<Tag> tags, Color primary) {
  if (tags.isEmpty) return primary;

  // Tổng trọng số
  const double primaryWeight = 0.5;
  double tagWeight = 0.5 / tags.length;

  // Trích xuất màu `primary`
  double r = primary.red * primaryWeight;
  double g = primary.green * primaryWeight;
  double b = primary.blue * primaryWeight;
  double a = primary.alpha * primaryWeight;

  // Thêm màu từ từng Tag
  for (var tag in tags) {
    if (tag.color == null) continue;
    Color tagColor = Color(tag.color!);
    r += tagColor.red * tagWeight;
    g += tagColor.green * tagWeight;
    b += tagColor.blue * tagWeight;
    a += tagColor.alpha * tagWeight;
  }

  // Trả về màu trộn
  return Color.fromARGB(
    a.round(),
    r.round(),
    g.round(),
    b.round(),
  );
}

Color adjustColorForDarkMode(Color color) {
  double lightnessFactor = 0.6;
  // Chuyển đổi màu RGB sang HSL
  final hsl = HSLColor.fromColor(color);
  
  // Giảm độ sáng (lightness)
  final darkened = hsl.withLightness((hsl.lightness * lightnessFactor).clamp(0.0, 1.0));
  
  // Chuyển đổi lại sang RGB
  return darkened.toColor();
}