import 'package:emodiary/components/tag_card.dart';
import 'package:emodiary/database/entity.dart';
import 'package:emodiary/helper/helper_colors.dart';
import 'package:emodiary/views/note/image_list_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteCard extends StatelessWidget {
  const NoteCard(
      {super.key, required this.note, required this.tags, this.onTap});

  final Note note;
  final List<Tag> tags;
  final Function(Note note)? onTap;

  static final dateFormatter = DateFormat('dd-MM-yyyy HH:mm');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final noteColor =
        mixColorsFromTag(tags, theme.colorScheme.primaryContainer);
    final contentColor =
        ThemeData.estimateBrightnessForColor(noteColor) == Brightness.dark
            ? Colors.white
            : Colors.black87;

    if (note.isPrivate) {
      return Container(
        margin: EdgeInsets.fromLTRB(10, 8, 10, 8),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(16), boxShadow: [
          BoxShadow(
            color: noteColor.withOpacity(0.6),
            blurRadius: 8,
            offset: Offset(-4, 6),
          )
        ]),
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
                    note.title!.trim().length <= 10
                        ? note.title!.trim()
                        : '${note.title!.trim().substring(0, 10)} ...',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: contentColor,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    child: Text(
                      'Private note',
                      style: TextStyle(
                        fontSize: 16,
                        color: contentColor,
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
                        color: contentColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.fromLTRB(10, 8, 10, 8),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(16), boxShadow: [
        BoxShadow(
          color: noteColor.withOpacity(0.6),
          blurRadius: 8,
          offset: Offset(-4, 6),
        )
      ]),
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
                  note.title!.trim().length <= 10
                      ? note.title!.trim()
                      : '${note.title!.trim().substring(0, 10)} ...',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: contentColor,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  child: Text(
                    note.body!.trim().split("\n").first.length <= 25
                        ? note.body!.trim().split("\n").first
                        : '${note.body!.trim().split("\n").first.substring(0, 25)} ...',
                    style: TextStyle(
                      fontSize: 14,
                      color: contentColor,
                    ),
                  ),
                ),
                if (note.mediaUrls != null && note.mediaUrls! != '')
                  Container(
                      margin: EdgeInsets.only(top: 5),
                      child: ImageListView(
                          imagePaths: note.mediaUrls!.trim().split(' '),
                          maxHeight: 50)),
                Container(
                  margin: EdgeInsets.only(top: 12),
                  alignment: Alignment.centerLeft,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final tag in tags)
                          Container(
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: TagCard(
                                tag: tag,
                                height: 32,
                              )),
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
                      color: contentColor,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
