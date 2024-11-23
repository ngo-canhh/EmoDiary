import 'package:emodiary/components/tag_card.dart';
import 'package:emodiary/database/entity.dart';
import 'package:emodiary/helper/helper_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({super.key, required this.note, required this.tags, this.onTap});

  final Note note;
  final List<Tag> tags;
  final Function(Note note)? onTap;

  static final dateFormatter = DateFormat('dd-MM-yyyy HH:mm');


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final noteColor = mixColorsFromTag(tags, theme.colorScheme.primaryContainer);


    return Container(
      margin: EdgeInsets.fromLTRB(10, 8, 10, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: noteColor.withOpacity(0.6),
            blurRadius: 8,
            offset: Offset(-4, 6),
          )
        ]
      ),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        color: noteColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (onTap != null) {
              onTap!(note);
            }  
          },
          splashColor: theme.splashColor,
          highlightColor: theme.highlightColor,
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.title!.trim().length <= 10 ? note.title!.trim() : '${note.title!.trim().substring(0, 10)} ...',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  child: Text(
                    note.body!.trim().split("\n").first.length <= 25 ? note.body!.trim().split("\n").first : '${note.body!.trim().split("\n").first.substring(0, 25)} ...',
                    style: TextStyle(
                      fontSize: 14
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 12),
                  alignment: Alignment.centerLeft,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final tag in tags) 
                          TagCard(tag: tag),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5),
                  alignment: Alignment.centerRight,
                  child: Text(
                    dateFormatter.format(DateTime.parse(note.createdAt)),
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );

    // return TapToExpandLetter(
    //   title: Text(note.title!), 
    //   content: Column(
    //     children: [
    //       Wrap(
    //         children: [
    //           for (final tag in tags) 
    //             TagCard(tag: tag),
    //         ],
    //       ),
    //       ElevatedButton(
    //         onPressed: () {
    //           if (onTap != null) {
    //             onTap!(note);
    //           }
    //         }, 
    //         child: Icon(Icons.delete)
    //       ),
    //     ],
    //   ), 
    //   centerWidget: Center(child: FaIcon(FontAwesomeIcons.chevronUp, size: 20,)),
    //   color: theme.colorScheme.surfaceContainerHigh,
    //   backgroundColor: theme.colorScheme.primary,
    //   height: 100,
    //   // width: 70,
    // );
  }
}
