import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:Speak2Note/models/recording_model.dart';
import 'package:Speak2Note/models/whisperMap.dart';
import 'package:Speak2Note/valueNotifier/var_value_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Speak2Note/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:Speak2Note/globals/global_key.dart' as globals;

class FirebaseAPI {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //上傳recordings
  Future<void> uploadRecordings(
    String title,
    String time,
    DateTime recordAt,
    String uid,
    String recordFilePath,
    String recordingID,
    VarValueNotifier uploadListNotifier,
    int duration,
  ) async {
    try {
      String audioUrl = await uploadAudio(
        uid,
        recordFilePath,
        recordingID,
        uploadListNotifier,
        title,
        time,
      );
      RecordingModel recording = RecordingModel(
        title: title,
        time: time,
        recordAt: recordAt,
        uid: uid,
        audioUrl: audioUrl,
        whisperSegments: [],
        recordingID: recordingID,
        duration: duration,
      );
      await _firestore
          .collection('recordings')
          .doc(recordingID)
          .set(recording.toJson());
      print('成功上傳firebase_recordings');
      final file = File(recordFilePath);

      if (await file.exists()) {
        await file.delete();
        print('刪除錄音史時的file: $recordFilePath');
      } else {
        print('File does not exist: $recordFilePath');
      }
    } catch (e) {
      throw (e.toString());
    }

    //刪掉uploadList完成的那個
    uploadListNotifier.value.removeWhere(
      (e) => e['recordingID'] == recordingID,
    );
    uploadListNotifier.varChange(uploadListNotifier.value);
    //搜尋剛上傳到firestore的recording
    globals.globalRecordList!.currentState!.widget.bloc
        .updateEvent(recordingID);
    Get.snackbar(
      "上傳成功",
      "錄音文件已成功上傳完成～",
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(
        seconds: 2,
      ),
    );
  }

  //上傳音檔
  Future<String> uploadAudio(
    String uid,
    String recordFilePath,
    String recordingID,
    VarValueNotifier uploadListNotifier,
    String title,
    String time,
  ) async {
    try {
      UploadTask uploadTask = _storage
          .ref()
          .child('audio')
          .child(uid)
          .child(recordingID)
          .putFile(File(recordFilePath));
      // 监听上传进度
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress =
            (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        (uploadListNotifier.value as List).last['uploadProgress'] = progress;
        uploadListNotifier.varChange(uploadListNotifier.value);
      });
      TaskSnapshot snap = await uploadTask;
      String downloadUrl = await snap.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Firebase 错误：$e');
      return '';
    }
  }

  //上傳whisper文章
  Future<void> uploadWhisperSegments(
      String recordingID, List<WhisperSegment> whisperSegments) async {
    List<Map> list = [];
    for (var i in whisperSegments) {
      list.add(WhisperSegment.toMap(i));
    }
    try {
      await _firestore.collection('recordings').doc(recordingID).update(
        {
          'whisperSegments': FieldValue.arrayUnion(list),
        },
      );
      print('成功上傳firebase_whisperSegments');
    } catch (e) {
      throw (e.toString());
    }
  }

  //獲取該user的recordings
  Future<List> fetchAllRecodings() async {
    QuerySnapshot snapshot;
    try {
      snapshot = await _firestore
          .collection('recordings')
          .where(
            'uid',
            isEqualTo: _auth.currentUser!.uid,
          )
          .get();
    } catch (e) {
      throw (e.toString());
    }
    //排成時間順序
    List<QueryDocumentSnapshot> records = snapshot.docs.toList();

    // 对数据列表按照recordAt字段进行排序
    records.sort((a, b) {
      Timestamp aTime = a['recordAt'];
      Timestamp bTime = b['recordAt'];
      return aTime.compareTo(bTime);
    });
    print('請求firebase_recordings: ${records.length}個');
    return records;
  }

  //獲取特定的recording
  Future<List> fetchRecording(
    String recordingID,
    List list,
  ) async {
    QuerySnapshot snapshot;
    try {
      snapshot = await _firestore
          .collection('recordings')
          .where('recordingID', isEqualTo: recordingID)
          .get();
    } catch (e) {
      throw (e.toString());
    }
    //如果原本就有recordingID就更新，沒有就插入到最後
    int index = list.indexWhere(
      (element) => element['recordingID'] == recordingID,
    );
    if (index == -1) {
      list.add(snapshot.docs.first);
    } else {
      list[index] = snapshot.docs.first;
    }

    return list;
  }

  //更改特定的recording標題
  Future<void> updateTitle(String recordingID, String title) async {
    try {
      await _firestore
          .collection('recordings')
          .doc(recordingID)
          .update({'title': title});
      Get.snackbar(
        '更改成功',
        '成功更改標題',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(
          seconds: 2,
        ),
      );
      globals.globalRecordList!.currentState!.widget.bloc
          .updateEvent(recordingID);
    } catch (e) {
      print(e.toString());
    }
  }

  //刪除特定的recording
  Future<void> deleteRecording(String recordingID) async {
    try {
      await _firestore.collection('recordings').doc(recordingID).delete();
      await _storage
          .ref()
          .child('audio')
          .child(_auth.currentUser!.uid)
          .child(recordingID)
          .delete();
      globals.globalRecordList!.currentState!.widget.bloc
          .deleteEvent(recordingID);
      Get.snackbar(
        '刪除成功',
        '刪除檔案成功',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(
          seconds: 2,
        ),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  //使用者登出
  Future<void> signOut() async {
    await _auth.signOut();
  }

  //使用者登入
  Future<void> signInWithApple() async {
    String generateNonce([int length = 32]) {
      const charset =
          '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
      final random = Random.secure();
      return List.generate(
          length, (_) => charset[random.nextInt(charset.length)]).join();
    }

    String sha256ofString(String input) {
      final bytes = utf8.encode(input);
      final digest = sha256.convert(bytes);
      return digest.toString();
    }

    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );
      UserCredential userCredential =
          await _auth.signInWithCredential(oauthCredential);
      print(userCredential.user!);

      //寫入firestore
      await _firestore.collection('users').doc(_auth.currentUser!.uid).set(
            UserModel(
              email: _auth.currentUser!.email!,
              uid: _auth.currentUser!.uid,
            ).toJson(),
          );
    } catch (e) {
      print(e);
    }
  }
}
