import 'package:flutter/material.dart';

class MeTile extends StatelessWidget {
  const MeTile(
      {super.key,
      required this.child,
      this.leading,
      this.onTap});

  final Widget child;
  final String? leading;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 4,
          child: Column(
            children: [
              if (leading != null)
                Container(
                  // alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 10),
                  child: Text(
                    leading!,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              Padding(
                padding: EdgeInsets.all(10),
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
