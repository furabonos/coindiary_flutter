import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../model/model.dart';
import '../../../repository/repository.dart';

class DiaryViewModel extends ChangeNotifier {

  late final Repository _repository;

  DiaryViewModel() {
    _repository = Repository();
  }

  Future<List<DiaryModel>> fetchData() async {
    return _repository.fetchData();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>streamFetchData(String uuids) {
    return _repository.streamFetchData(uuids);
  }

  Future<bool> removeAllData() {
    return _repository.removeAllData();
  }
}