import 'package:clean_calendar/clean_calendar.dart';
import 'package:flutter/material.dart';

class MyCalendar extends StatelessWidget {
  const MyCalendar({
    super.key, 
    required this.datesForStreaks, 
    required this.selectedDates, 
    required this.onSelectedDates, 
  });

  final List<DateTime> datesForStreaks;
  final List<DateTime> selectedDates;
  final void Function(List<DateTime> value) onSelectedDates;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CleanCalendar(
      // datePickerCalendarView: DatePickerCalendarView.weekView,
      enableDenseViewForDates: true,
      enableDenseSplashForDates: true,
      startWeekday: WeekDay.monday,
      datesForStreaks: datesForStreaks,
      selectedDates: selectedDates,
      dateSelectionMode: DatePickerSelectionMode.singleOrMultiple,
      onSelectedDates: onSelectedDates,
      selectedDatesProperties: DatesProperties(
        datesDecoration: DatesDecoration(
          datesBackgroundColor: theme.colorScheme.secondaryFixedDim,
          datesTextColor: theme.colorScheme.onSecondaryFixed,
        ),
      ),
      currentDateProperties: DatesProperties(
        datesDecoration: DatesDecoration(
          datesBackgroundColor: theme.colorScheme.secondaryFixedDim.withOpacity(0.7),
          datesBorderColor: theme.scaffoldBackgroundColor,
          datesTextColor: theme.colorScheme.onSecondaryFixed,
        ),
      ),
      generalDatesProperties: DatesProperties(
        datesDecoration: DatesDecoration(
          datesBorderColor: theme.colorScheme.onSurface.withOpacity(0.8),
          datesTextColor: theme.colorScheme.onSurface.withOpacity(0.8),
        ),
      ),
      streakDatesProperties: DatesProperties(
        datesDecoration: DatesDecoration(
          datesBorderColor: theme.colorScheme.onPrimaryContainer.withOpacity(0.5),
          datesBackgroundColor: theme.colorScheme.secondaryContainer,
          datesTextColor: theme.colorScheme.onSecondaryContainer,
        ),
      ),
      leadingTrailingDatesProperties: DatesProperties(
        disable: true,
        datesDecoration: DatesDecoration(
          datesBorderColor: theme.colorScheme.onSurface.withOpacity(0.3),
          datesBackgroundColor: theme.colorScheme.surface,
          datesTextColor: theme.colorScheme.onSurface.withOpacity(0.3),
        ),
      ),

    );
  }
}