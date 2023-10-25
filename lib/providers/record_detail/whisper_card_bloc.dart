import 'package:Speak2Note/widgets/record_detail/whisper_card.dart';
import 'package:flutter/cupertino.dart';

class WhisperCardBloc extends ChangeNotifier {
  List<double> heightList = [];
  List<GlobalObjectKey<WhisperCardState>> cardKeyList = [];

  // void catchRenderBox(int index) {
  //   if (index > heightList.length - 1) {
  //     final BuildContext context = cardKeyList[index].currentContext!;
  //     RenderBox renderBox = context.findRenderObject() as RenderBox;
  //     double height = renderBox.size.height;
  //     heightList.add(height);
  //   }
  // }

  // void createKey(int postLength) {
  //   cardKeyList = List.generate(
  //       postLength, (index) => GlobalObjectKey<WhisperCardState>('str$index'));
  // }

}
