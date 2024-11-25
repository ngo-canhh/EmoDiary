import 'dart:io';
import 'package:flutter/material.dart';

class ImageListView extends StatelessWidget {
  final List<String> imagePaths;
  final Function(String imagePath)? onTap;
  final Function(String imagePath)? onDoubleTap;
  final double maxHeight;
  final double? runSpacing;

  const ImageListView({super.key, required this.imagePaths, required this.maxHeight, this.runSpacing, this.onTap, this.onDoubleTap});

  @override
  Widget build(BuildContext context) {
    final margin = EdgeInsets.only(left: runSpacing ?? 5);
    return SizedBox(
      height: maxHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imagePaths.length,
        itemBuilder:(context, index) {
          final imagePath = imagePaths[index];
          return GestureDetector(
                onTap: () {
                  if (onTap != null) {
                    onTap!(imagePath);
                  }
                },
                onDoubleTap: () {
                  if (onDoubleTap != null) {
                    onDoubleTap!(imagePath);
                  }
                },
                child: Container(
                  height: maxHeight,
                  margin: margin,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: imagePath.startsWith('http') 
                        ? Image.network(
                            imagePath,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(child: CircularProgressIndicator());
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.error),
                          )
                        : Image.file(
                            File(imagePath),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              );
        },
      ),
    );
  }


  // @override
  // Widget build(BuildContext context) {
  //   final margin = EdgeInsets.only(left: runSpacing ?? 5);
  //   return SizedBox(
  //     height: maxHeight,
  //     child: SingleChildScrollView(
  //       scrollDirection: Axis.horizontal,
  //       child: Row(
  //         children: [
  //           for (final imagePath in imagePaths) 
  //             GestureDetector(
  //               onTap: () {
  //                 if (onTap != null) {
  //                   onTap!(imagePath);
  //                 }
  //               },
  //               onDoubleTap: () {
  //                 if (onDoubleTap != null) {
  //                   onDoubleTap!(imagePath);
  //                 }
  //               },
  //               child: Container(
  //                 height: maxHeight,
  //                 margin: margin,
  //                 child: ClipRRect(
  //                   borderRadius: BorderRadius.circular(8),
  //                   child: imagePath.startsWith('http') 
  //                       ? Image.network(
  //                           imagePath,
  //                           fit: BoxFit.cover,
  //                           loadingBuilder: (context, child, loadingProgress) {
  //                             if (loadingProgress == null) return child;
  //                             return Center(child: CircularProgressIndicator());
  //                           },
  //                           errorBuilder: (context, error, stackTrace) =>
  //                               const Icon(Icons.error),
  //                         )
  //                       : Image.file(
  //                           File(imagePath),
  //                           fit: BoxFit.cover,
  //                         ),
  //                 ),
  //               ),
  //             ),
  //         ],
  //       ),
  //     )
  //   );
  // }
}
