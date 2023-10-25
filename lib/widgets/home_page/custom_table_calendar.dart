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
    return ValueListenableBuilder(
      valueListenable: widget.bloc.eventValueNotifier,
      builder: (context, value, child) {
        value as Map<DateTime, List<RecordingModel>>?;
        return TableCalendar(
          eventLoader: (day) => value?[day] ?? [],
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            leftChevronIcon: Icon(
              Icons.chevron_left_rounded,
              color: Colors.blueAccent,
            ),
            rightChevronIcon: Icon(
              Icons.chevron_right_rounded,
              color: Colors.blueAccent,
            ),
          ),
          calendarStyle: CalendarStyle(
            cellAlignment: Alignment.topCenter,
            cellMargin: EdgeInsets.all(Dimensions.height2 / 2),
            cellPadding: EdgeInsets.all(Dimensions.height2 * 2),
            todayDecoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(50),
            ),
            selectedDecoration: BoxDecoration(
              color: Colors.black45,
            ),
            weekendDecoration: BoxDecoration(
              color: Colors.black12,
              border: Border.all(color: Colors.black54, width: 0.5),
            ),
            defaultDecoration: BoxDecoration(
              border: Border.all(color: Colors.black54, width: 0.5),
            ),
          ),
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
                            color: Colors.white60,
                          ),
                          child: Text(
                            '(${events.length})',
                            style: const TextStyle(color: Colors.blueAccent),
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
