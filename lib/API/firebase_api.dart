import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:Speak2Note/models/recording_model.dart';
import 'package:Speak2Note/models/whisperMap.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Speak2Note/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirebaseAPI {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //上傳recordings
  Future<void> uploadRecordings(
    String title,
    DateTime recordAt,
    String uid,
    String audioUrl,
    String recordingID,
  ) async {
    RecordingModel recording = RecordingModel(
      title: title,
      recordAt: recordAt,
      uid: uid,
      audioUrl: audioUrl,
      whisperSegments: [],
      recordingID: recordingID,
    );
    try {
      await _firestore
          .collection('recordings')
          .doc(recordingID)
          .set(recording.toJson());
      print('成功上傳firebase_recordings');
    } catch (e) {
      throw (e.toString());
    }
  }

  //上傳音檔
  Future<String> uploadAudio(
    String uid,
    String recordFilePath,
    String recordingID,
  ) async {
    try {
      UploadTask uploadTask = _storage
          .ref()
          .child('audio')
          .child(uid)
          .child(recordingID)
          .putFile(File(recordFilePath));
      TaskSnapshot snap = await uploadTask;
      String downloadUrl = await snap.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Firebase 错误：$e');
      return '';
    }
  }

  //上傳whisper文章
  Future<void> updateWhisperSegments(
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
