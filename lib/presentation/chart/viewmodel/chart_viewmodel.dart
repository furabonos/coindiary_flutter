import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../model/model.dart';
import '../../util/protocol/string_utils.dart';

class ChartViewModel extends ChangeNotifier {
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
}