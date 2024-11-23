import 'package:emodiary/database/entity.dart';
import 'package:flutter/material.dart';

class TagCard extends StatelessWidget {
  const TagCard({super.key, required this.tag, this.onTap, this.onDoubleTap});
  
  final Function(Tag tag)? onTap;
  final Function(Tag tag)? onDoubleTap;
  final Tag tag;

  @override
  Widget build(BuildContext context) {
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
      child: Card(
        elevation: 2,
        color: Color(tag.color ?? Colors.grey.value),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text('# ${tag.name}'),
        ),
      ),
    );
  }
}