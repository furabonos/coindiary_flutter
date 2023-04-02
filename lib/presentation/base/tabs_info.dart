import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

class TabInfo {
  final IconData icon;
  final String label;

  const TabInfo({
    required this.icon,
    required this.label,
  });
}

const TABS = [
  TabInfo(icon: Icons.edit_note, label: '매매일지'),
  TabInfo(icon: Icons.show_chart, label: '자산그래프'),
];