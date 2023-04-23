import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coindiary_flutter/repository/repository.dart';
import 'package:flutter/material.dart';

import '../../../model/model.dart';
import '../../util/protocol/string_utils.dart';

class ChartViewModel extends ChangeNotifier {

  late final Repository _repository;
  ChartViewModel() {
    _repository = Repository();
  }

  Future<List<DiaryModel>> fetchData() async {
    return _repository.chartFetchData();
  }
}