import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/model.dart';
import '../presentation/util/protocol/string_utils.dart';

enum SaveDataBool {
  success,
  failure
}

class DataSource {
  Future<List<DiaryModel>> fetchData() async {
    String uuids = await StringUtils.getDevideUUID();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final QuerySnapshot snapshot = await firestore
        .collection(uuids)
        .orderBy('today', descending: true)
        .get();

    List<DiaryModel> list =
    snapshot.docs.map((e) => DiaryModel.fromFirestore(doc: e)).toList();
    return list;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamFetchData(String uuids){
    return FirebaseFirestore.instance.collection(uuids).orderBy('today', descending: true).snapshots();
  }

  Future<List<DiaryModel>> chartFetchData() async {
    String uuids = await StringUtils.getDevideUUID();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final QuerySnapshot snapshot = await firestore
        .collection(uuids)
        .orderBy('today', descending: false)
        .get();

    List<DiaryModel> list =
    snapshot.docs.map((e) => DiaryModel.fromFirestore(doc: e)).toList();
    return list;
  }

  Future<bool> saveData(String start, String end, String? memo, String today, BuildContext context) async{
    String uuids = await StringUtils.getDevideUUID();
    try {
      await FirebaseFirestore.instance.collection(uuids)
          .doc(today)
          .set({
        "start": start,
        "end": end,
        "today": today,
        "memo": memo
      });
      return true;
    } catch (e) {
      // Alertable.showDataFailure(context);
      return false;
      print('FireStore에 데이터를 추가하는중 오류발생 :: ${e}');
    }
  }
}