import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StringUtils {
  static Future<String> getDevideUUID() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? aa = prefs.getString("UUID");
    return aa!;
  }
}