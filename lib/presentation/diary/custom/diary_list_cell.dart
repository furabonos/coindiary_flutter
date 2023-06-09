import 'package:coindiary_flutter/presentation/util/protocol/calculation.dart';
import 'package:flutter/material.dart';

import '../../../model/model.dart';

class DiaryListCell extends StatelessWidget {
  final DiaryModel data;
  const DiaryListCell({required this.data, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool yield =
        Calculation.yieldCalculation(data.start, data.end).contains("-");
    final double width = MediaQuery.of(context).size.width / 5;
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: renderRow(width, yield),
    );
  }

  Widget renderRow(double widths, bool yield) {
    return Row(
      children: [
        Container(
            width: widths,
            child: Text(data.today, textAlign: TextAlign.center)),
        Container(
            width: widths,
            child: Text("${data.start}USDT", textAlign: TextAlign.center)),
        Container(
            width: widths,
            child: Text("${data.end}USDT", textAlign: TextAlign.center)),
        Container(
            width: widths,
            child: data.type == "매매" ? renderDafaultYield(widths, yield) : renderOtherYield(data.type, widths),
        ),
        Container(
            width: widths,
            child: Text(data.memo ?? "", textAlign: TextAlign.center)),
      ],
    );
  }

  Widget renderDafaultYield(double widths, bool yield) {
    return Text(
      data.type == "매매" ? Calculation.yieldCalculation(data.start, data.end) : data.type,
      textAlign: TextAlign.center,
      style: TextStyle(color: yield ? Colors.red : Colors.blue),
    );
  }

  Widget renderOtherYield(String types, double widths) {
    return Text(
      types,
      textAlign: TextAlign.center,
      style: TextStyle(color: types == "출금" ? Colors.red : Colors.blue),
    );
  }
}
