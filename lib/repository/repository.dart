import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coindiary_flutter/datasource/datasource.dart';
import 'package:flutter/material.dart';
import '../model/model.dart';

class Repository {
  final DataSource _dataSource = DataSource();

  Future<List<DiaryModel>> fetchData() {
    return _dataSource.fetchData();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamFetchData(String uuids) {
    return _dataSource.streamFetchData(uuids);
  }

  Future<List<DiaryModel>> chartFetchData() {
    return _dataSource.chartFetchData();
  }

  Future<bool> saveData(String start, String end, String? memo, String today, String types, String register, BuildContext context) {
    return _dataSource.saveData(start, end, memo, today, types, register, context);
  }

  Future<bool> removeAllData() {
    return _dataSource.removeAllData();
  }

  Future<bool> removeData(String today) {
    return _dataSource.removeData(today);
  }
}