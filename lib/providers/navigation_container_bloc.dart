import 'package:flutter/material.dart';
import 'package:Speak2Note/providers/home_page/home_page_bloc.dart';
import 'package:Speak2Note/providers/recording_page_bloc.dart';

class NavigationContainerBloc extends ChangeNotifier {
  
  HomePageBloc homePageBloc = HomePageBloc();
  RecordingPageBloc recordingPageBloc = RecordingPageBloc();
  List<Widget> pages = [];
  final PageController pageController = PageController();
  void onIconTapped(int index) {
    pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }
}
