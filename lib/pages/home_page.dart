import 'package:Speak2Note/providers/recording_page_bloc.dart';
import 'package:Speak2Note/widgets/home_page/custom_search_bar.dart';
import 'package:Speak2Note/widgets/home_page/upload_list.dart';
import 'package:flutter/material.dart';
import 'package:Speak2Note/providers/home_page/home_page_bloc.dart';
import 'package:Speak2Note/widgets/home_page/record_list.dart';
import 'package:Speak2Note/widgets/home_page/custom_table_calendar.dart';

class HomePage extends StatefulWidget {
  final HomePageBloc bloc;
  final RecordingPageBloc recordingPageBloc;
  const HomePage({
    super.key,
    required this.bloc,
    required this.recordingPageBloc,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{
  @override
  final bool wantKeepAlive = true;
  @override
  void initState() {
    super.initState();
    widget.bloc.getEvents();
  }

  @override
  Widget build(BuildContext context) {
    Color scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    super.build(context);
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
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
            //正在上傳的視頻
            UploadList(bloc:widget.recordingPageBloc),
            RecordList(bloc: widget.bloc),
          ],
        ),
      ),
    );
  }
}
