import 'package:Speak2Note/globals/dimension.dart';
import 'package:Speak2Note/models/recording_model.dart';
import 'package:Speak2Note/pages/custom_search_page.dart';
import 'package:Speak2Note/providers/home_page/home_page_bloc.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final HomePageBloc bloc;
  const CustomSearchBar({
    super.key,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false, //隱藏drawer預設icon
      backgroundColor: Color.fromARGB(255, 86, 86, 86),
      expandedHeight: Dimensions.height5 * 14,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        background: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.width2 * 8,
          ),
          child: GestureDetector(
            onTap: (() {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  List<RecordingModel> allRecordings = [];
                  bloc.events.values
                      .forEach((list) => allRecordings.addAll(list));
                  return CustomSearchPage(
                    recordings: allRecordings,
                    recordListBloc: bloc.recordListBloc,
                  );
                }),
              );
            }),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: Dimensions.height5 * 2),
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 19.6,
                  vertical: MediaQuery.of(context).size.height / 164),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.height5 * 10),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search_outlined,
                    color: Color.fromARGB(255, 86, 86, 86),
                    size: Dimensions.height5 * 5,
                  ),
                  SizedBox(width: Dimensions.width5 * 3),
                ],
              ),
            ),
          ),
        ),
      ),
      pinned: false,
      floating: true,
      elevation: 0,
    );
  }
}
