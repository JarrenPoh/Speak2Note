import 'package:Speak2Note/globals/dimension.dart';
import 'package:Speak2Note/providers/recording_page_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UploadList extends StatefulWidget {
  final RecordingPageBloc bloc;
  const UploadList({
    super.key,
    required this.bloc,
  });

  @override
  State<UploadList> createState() => _UploadListState();
}

class _UploadListState extends State<UploadList> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.bloc.uploadListNotifier,
      builder: (context, value, child) {
        value as List;
        return value.isEmpty
            ? Container()
            : Column(
                children: List.generate(
                  value.length,
                  (index) {
                    return CupertinoButton(
                      onPressed: () {},
                      child: Container(
                        width: Dimensions.screenWidth,
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.width5 * 3,
                          vertical: Dimensions.height5 * 3,
                        ),
                        margin: EdgeInsets.symmetric(
                          horizontal: Dimensions.width5 * 0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(31, 75, 75, 75)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  value[index]['time'],
                                  style: TextStyle(
                                    color: Colors.black26,
                                  ),
                                  maxLines: 4,
                                ),
                                SizedBox(height: Dimensions.height5),
                                Text(
                                  value[index]['title'] == ''
                                      ? '無'
                                      : value[index]['title'],
                                  style: TextStyle(
                                      color: Colors.black26, fontSize: 16),
                                ),
                              ],
                            ),
                            Text(
                              '上傳進度${value[index]['uploadProgress'].toInt()}%',
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
      },
    );
  }
}
