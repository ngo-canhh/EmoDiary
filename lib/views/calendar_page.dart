import 'package:clean_calendar/clean_calendar.dart';
import 'package:emodiary/database/db_provider.dart';
import 'package:emodiary/database/entity.dart';
import 'package:emodiary/views/note_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  List<DateTime> selectedDates = <DateTime>[DateTime.now()];
  DateTime currentMonth = DateTime.now();
  DbProvider? dbProvider;
  ThemeData? theme;

  void _onSelectedDates(value) {
    if (!selectedDates.contains(value.first)) {
      selectedDates.clear();
      selectedDates.add(value.first);
      setState(() {});
    }
  }



  @override
  Widget build(BuildContext context) {


    dbProvider ??= Provider.of<DbProvider>(context);
    theme ??= Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar"),
        backgroundColor: theme!.colorScheme.primary,
      ),
      backgroundColor: theme!.colorScheme.surface,
      body: Column(
        children: [
          CleanCalendar(
            enableDenseViewForDates: true,
            enableDenseSplashForDates: true,
            startWeekday: WeekDay.monday,
            
            datesForStreaks: dbProvider!.datesForStreaks,
            
            selectedDates: selectedDates,
            dateSelectionMode: DatePickerSelectionMode.singleOrMultiple,
            onSelectedDates: _onSelectedDates,
            selectedDatesProperties: DatesProperties(
              datesDecoration: DatesDecoration(
                datesBackgroundColor: theme!.colorScheme.secondary,
                datesBorderColor: theme!.textTheme.displayMedium!.color,
                datesTextColor: theme!.textTheme.displayMedium!.color,
              )
            ),
          
            currentDateProperties: DatesProperties(
              datesDecoration: DatesDecoration(
                datesBackgroundColor: theme!.colorScheme.secondary,
                datesTextColor: theme!.textTheme.bodySmall!.color,
              )
            ),
            
            generalDatesProperties: DatesProperties(
              datesDecoration: DatesDecoration(
                datesBorderColor: Colors.black45,
                datesTextColor: Colors.black87
              )
            ),
            
            streakDatesProperties: DatesProperties(
              datesDecoration: DatesDecoration(
                datesBorderColor: theme!.colorScheme.inversePrimary,
                datesBackgroundColor: theme!.colorScheme.primary,
                datesTextColor: theme!.textTheme.bodySmall!.color,
              )
            ),
            
            leadingTrailingDatesProperties: DatesProperties(
              disable: true,
              datesDecoration: DatesDecoration(
                datesBorderColor: theme!.colorScheme.primary,
                datesBackgroundColor: theme!.colorScheme.surface,
              )
            ),
            
          ),
          Expanded(
            child: FutureBuilder<List<Note>>(
              future: dbProvider!.getNotesByDate(selectedDates.first),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No notes available'));
                } else {
                  List<Note> allNotes = snapshot.data!;
                  return ListView.builder(
                    itemCount: allNotes.length,
                    itemBuilder: (context, index) {
                      final note = allNotes[index];
                      return ListTile(
                        title: Text(note.toString()),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ]
      ),
    
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
          Navigator.push(context, MaterialPageRoute(builder:(context) => NotePage(date: selectedDates.first.toIso8601String().substring(0, 10) == DateTime.now().toIso8601String().substring(0, 10) ? null : selectedDates.first,),));
        },
      ),
    );
  }



  
}
