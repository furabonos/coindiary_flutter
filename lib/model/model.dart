import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DiaryModel {
  // public let imageURL: String?
  final String today;
  final String start;
  final String end;
  final String? memo;

  DiaryModel.fromFirestore({required DocumentSnapshot doc}):
      today = doc['today'].toString(),
      start = doc['start'].toString(),
      end = doc['end'].toString(),
      memo = doc['memo'].toString() ?? "";

//   DiaryModel({
//     required this.today,
//     required this.start,
//     required this.end,
//     this.memo
// });
//   StatModel.fromJSON({required Map<String, dynamic> json}):
//         daegu = double.parse(json['daegu'] ?? '0'),


}
