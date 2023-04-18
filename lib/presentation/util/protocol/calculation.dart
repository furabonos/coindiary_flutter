import 'package:flutter/material.dart';

class Calculation {
  static String yieldCalculation(String start, String end) {
    double startAmount = double.tryParse(start) ?? 0.0;
    double endAmount = double.tryParse(end) ?? 0.0;
    double returnRate = (endAmount - startAmount) / startAmount * 100;
    return returnRate.toStringAsFixed(1) + "%";
  }
}