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
        .orderBy('register', descending: true)
        .get();

    List<DiaryModel> list =
    snapshot.docs.map((e) => DiaryModel.fromFirestore(doc: e)).toList();
    return list;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamFetchData(String uuids){
    return FirebaseFirestore.instance.collection(StringUtils.encrypt(uuids)).orderBy('register', descending: true).snapshots();
  }

  Future<List<DiaryModel>> chartFetchData() async {
    String uuids = await StringUtils.getDevideUUID();

    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final QuerySnapshot snapshot = await firestore
        .collection(StringUtils.encrypt(uuids))
        .orderBy('register', descending: false)
        .limit(1)
        .get();

    List<DiaryModel> list =
    snapshot.docs.map((e) => DiaryModel.fromFirestore(doc: e)).toList();
    return list;
  }

  Future<bool> saveData(String start, String end, String? memo, String today, String type, String register, BuildContext context) async {
    String uuids = await StringUtils.getDevideUUID();
    try {
      await FirebaseFirestore.instance.collection(StringUtils.encrypt(uuids))
          .doc(register)
          .set({
        "start": start,
        "end": end,
        "today": today,
        "memo": memo,
        "type": type,
        "register": register
      });
      return true;
    } catch (e) {
      // Alertable.showDataFailure(context);
      print('FireStore에 데이터를 추가하는중 오류발생 :: ${e}');
      return false;

    }
  }

  Future<bool> removeAllData() async {
    String uuids = await StringUtils.getDevideUUID();
    var collection = FirebaseFirestore.instance.collection(StringUtils.encrypt(uuids));
    var snapshots = await collection.get();
    try {
      for (var doc in snapshots.docs) {
        await doc.reference.delete();
      }
      return true;
    } catch (e) {
      // Alertable.showDataFailure(context);
      return false;
      print('FireStore에 데이터를 추가하는중 오류발생 :: ${e}');
    }
  }

  Future<bool> removeData(String today) async {
    String uuids = await StringUtils.getDevideUUID();
    var collection = FirebaseFirestore.instance.collection(StringUtils.encrypt(uuids)).doc(today);
    try {
      collection.delete();
      return true;
    }catch (e) {
      return false;
    }
  }
}