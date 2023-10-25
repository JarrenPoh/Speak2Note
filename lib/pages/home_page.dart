import 'package:Speak2Note/widgets/home_page/custom_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:Speak2Note/providers/home_page/home_page_bloc.dart';
import 'package:Speak2Note/widgets/home_page/record_list.dart';
import 'package:Speak2Note/widgets/home_page/custom_table_calendar.dart';

class HomePage extends StatefulWidget {
  final HomePageBloc bloc;
  const HomePage({
    super.key,
    required this.bloc,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    widget.bloc.getEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            CustomSearchBar(bloc: widget.bloc),
            SliverToBoxAdapter(
              child: CustomTableCalendar(
                bloc: widget.bloc,
              ),
            ),
          ];
        },
        body: ListView(
          children: [
            RecordList(bloc: widget.bloc),
          ],
        ),
      ),
    );
  }
}
