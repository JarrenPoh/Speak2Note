import 'package:flutter/material.dart';
import 'package:Speak2Note/pages/home_page.dart';
import 'package:Speak2Note/pages/recording_page.dart';
import 'package:Speak2Note/providers/navigation_container_bloc.dart';
import 'package:Speak2Note/widgets/custom_action_button.dart';

class NavigationContainer extends StatefulWidget {
  const NavigationContainer({super.key});

  @override
  State<NavigationContainer> createState() => _NavigationContainerState();
}

class _NavigationContainerState extends State<NavigationContainer> {
  NavigationContainerBloc _bloc = NavigationContainerBloc();

  @override
  Widget build(BuildContext context) {
    _bloc.pages = [
      HomePage(
        bloc: _bloc.homePageBloc,
        recordingPageBloc: _bloc.recordingPageBloc,
      ),
      RecordingPage(bloc: _bloc.recordingPageBloc),
    ];

    return Scaffold(
      body: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        controller: _bloc.pageController,
        itemCount: _bloc.pages.length,
        itemBuilder: (context, index) {
          return _bloc.pages[index];
        },
      ),
      floatingActionButton: CustomActionButton(
        onIconTap: _bloc.onIconTapped,
        recordingPageBloc: _bloc.recordingPageBloc,
      ),
    );
  }
}
