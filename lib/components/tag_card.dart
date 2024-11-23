import 'package:emodiary/database/entity.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class TagCard extends StatelessWidget {
  final Tag tag;
  final Function(Tag)? onTap;
  final Function(Tag)? onDoubleTap;
  final double? width;
  final double? height;

  const TagCard({
    super.key,
    required this.tag,
    this.onTap,
    this.onDoubleTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final contentColor = ThemeData.estimateBrightnessForColor(Color(tag.color ?? 0xFFBDBDBD)) == Brightness.dark ? Colors.white : Colors.black87;
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!(tag);
        }
      },
      onDoubleTap: () {
        if (onDoubleTap != null) {
          onDoubleTap!(tag);
        }
      },
      child: Container(
        width: width, 
        height: height ?? 40, 
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Color(tag.color ?? 0xFFBDBDBD),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(FontAwesomeIcons.hashtag, color: contentColor, size: 16),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                tag.name,
                style: TextStyle(
                  color: contentColor,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
