import 'package:emodiary/components/note_card.dart';
import 'package:emodiary/database/db_provider.dart';
import 'package:emodiary/database/entity.dart';
import 'package:emodiary/helper/helper_function.dart';
import 'package:emodiary/components/my_calendar.dart';
import 'package:emodiary/views/note/create_or_edit_note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  List<DateTime> selectedDates = <DateTime>[DateTime.now()];
  // DateTime currentMonth = DateTime.now();
  DbProvider? dbProvider;

  void _onSelectedDates(value) async {
    if (!selectedDates.contains(value.first)) {
      selectedDates.clear();
      selectedDates.add(value.first);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    dbProvider ??= Provider.of<DbProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(children: [
          MyCalendar(
              datesForStreaks: dbProvider!.datesForStreaks,
              selectedDates: selectedDates,
              onSelectedDates: _onSelectedDates,
          ),
          Expanded(
            child: FutureBuilder<Map<Note, List<Tag>>>(
              future: dbProvider!.dbService.getNotesByDate(selectedDates.first),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No notes available'));
                } else {
                  final noteTags =
                      snapshot.data!.entries.toList().reversed.toList();
                  
                  return MasonryGridView.count(
                    itemCount: noteTags.length,
                    crossAxisCount: 2,
                    itemBuilder: (context, index) {
                      final note = noteTags[index].key;
                      final tags = noteTags[index].value;
                      return NoteCard(
                        note: note,
                        tags: tags,
                        onTap: (value) {
                          
                          Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (context) {
                                return CreateOrEditNote(existNote: note, existTags: tags,);
                              },
                            )
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ]),
      ),
      floatingActionButton: (selectedDates.first.isBefore(DateTime.now()))
          ? FloatingActionButton(
              child: FaIcon(FontAwesomeIcons.notesMedical),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateOrEditNote(
                        selectDate: isSameDay(selectedDates.first, DateTime.now())
                            ? null
                            : selectedDates.first,
                      ),
                    ));
              },
            )
          : null,
    );
  }
}
