import 'package:Speak2Note/globals/dimension.dart';
import 'package:Speak2Note/models/recording_model.dart';
import 'package:flutter/material.dart';
import 'package:Speak2Note/providers/home_page/home_page_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomTableCalendar extends StatefulWidget {
  final HomePageBloc bloc;
  const CustomTableCalendar({
    super.key,
    required this.bloc,
  });

  @override
  State<CustomTableCalendar> createState() => _CustomTableCalendarState();
}

class _CustomTableCalendarState extends State<CustomTableCalendar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color hintColor = Theme.of(context).hintColor;
    Color onSecondaryColor = Theme.of(context).colorScheme.onSecondary;
    Color firstColor = Theme.of(context).colorScheme.primary;
    Color secondColor = Theme.of(context).colorScheme.secondary;
    Color thirdColor = Theme.of(context).colorScheme.tertiary;
    Color containerColor = Theme.of(context).colorScheme.primaryContainer;
    return ValueListenableBuilder(
      valueListenable: widget.bloc.eventValueNotifier,
      builder: (context, value, child) {
        value as Map<DateTime, List<RecordingModel>>?;
        return TableCalendar(
          eventLoader: (day) => value?[day] ?? [],
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            leftChevronIcon: Icon(
              Icons.chevron_left_rounded,
              color: hintColor,
            ),
            titleTextStyle: TextStyle(color: onSecondaryColor),
            rightChevronIcon: Icon(
              Icons.chevron_right_rounded,
              color: hintColor,
            ),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            decoration: BoxDecoration(),
            weekdayStyle: TextStyle(color: firstColor),
            weekendStyle: TextStyle(color: secondColor),
          ),
          daysOfWeekHeight: Dimensions.height2*25,
          calendarStyle: CalendarStyle(
              cellAlignment: Alignment.topCenter,
              cellMargin: EdgeInsets.all(Dimensions.height2 / 2),
              cellPadding: EdgeInsets.all(Dimensions.height2 * 2),
              // outsideTextStyle: TextStyle(color: onSecondaryColor),
              todayDecoration: BoxDecoration(
                color: secondColor,
                borderRadius: BorderRadius.circular(50),
              ),
              todayTextStyle: TextStyle(),
              selectedDecoration: BoxDecoration(
                color: firstColor,
              ),
              selectedTextStyle: TextStyle(),
              weekendDecoration: BoxDecoration(
                color: thirdColor,
                border: Border.all(color: firstColor, width: 0.5),
              ),
              weekendTextStyle: TextStyle(),
              defaultDecoration: BoxDecoration(
                border: Border.all(color: firstColor, width: 0.5),
              ),
              defaultTextStyle: TextStyle(color: onSecondaryColor)),
          availableGestures: AvailableGestures.all,
          selectedDayPredicate: (day) => isSameDay(day, widget.bloc.focusedDay),
          focusedDay: widget.bloc.focusedDay,
          firstDay: DateTime.utc(2002, 09, 15),
          lastDay: DateTime.utc(2030, 09, 15),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              widget.bloc.focusedDay = selectedDay;
              widget.bloc.recordListBloc.onDaySelected(
                  widget.bloc.eventValueNotifier.value[selectedDay], true);
            });
          },
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, day, events) {
              return events.isNotEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.width2,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: containerColor,
                          ),
                          child: Text(
                            '(${events.length})',
                            style: TextStyle(color: hintColor),
                          ),
                        ),
                      ],
                    )
                  : null;
            },
          ),
        );
      },
    );
  }
}
