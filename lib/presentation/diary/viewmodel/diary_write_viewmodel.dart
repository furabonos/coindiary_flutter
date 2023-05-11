import 'package:flutter/material.dart';

import '../../../datasource/datasource.dart';
import '../../../repository/repository.dart';

class DiaryWriteViewModel extends ChangeNotifier {

  late final Repository _repository;

  DiaryWriteViewModel() {
    _repository = Repository();
  }

  Future<bool> saveData(String start, String end, String? memo, String today, String types, String register, BuildContext context) async {
    notifyListeners();
    return _repository.saveData(start, end, memo, today, types, register, context);
  }

}