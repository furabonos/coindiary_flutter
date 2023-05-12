import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DiaryModel {
  // public let imageURL: String?
  final String today;
  final String start;
  final String end;
  final String? memo;
  final String type;
  final String register;

  DiaryModel.fromFirestore({required DocumentSnapshot doc}):
      today = doc['today'].toString(),
      start = doc['start'].toString(),
      end = doc['end'].toString(),
      memo = doc['memo'].toString() ?? "",
      type = doc['type'].toString(),
      register = doc['register'].toString();
}
