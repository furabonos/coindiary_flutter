import 'package:coindiary_flutter/presentation/chart/viewmodel/chart_viewmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import '../../model/model.dart';
import '../util/protocol/string_utils.dart';

class ChartViewController extends StatefulWidget {
  ChartViewController({Key? key}) : super(key: key);

  @override
  State<ChartViewController> createState() => _ChartViewControllerState();
}

class _ChartViewControllerState extends State<ChartViewController> {

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<ChartViewModel>();

    return Scaffold(
        appBar: AppBar(
          title: const Text('자산 그래프'),
        ),
        body: renderChart(viewModel),
    );
  }

  FutureBuilder<List<DiaryModel>> renderChart(ChartViewModel viewModel) {
    return FutureBuilder<List<DiaryModel>>(
      future: viewModel.fetchData(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("error :: ${snapshot.error}");
          return Scaffold(
            body: Center(
              child: Text('에러있음'),
            ),
          );
        }

        if (!snapshot.hasData) {
          //로딩
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Column(
            children: [
              //Initialize the chart widget
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  //Initialize the spark charts widget
                  child: SfSparkLineChart.custom(
                    //Enable the trackball
                    trackball: SparkChartTrackball(
                        activationMode: SparkChartActivationMode.tap),
                    //Enable marker
                    marker: SparkChartMarker(
                        displayMode: SparkChartMarkerDisplayMode.all),
                    //Enable data label
                    labelDisplayMode: SparkChartLabelDisplayMode.all,
                    xValueMapper: (int index) => snapshot.data![index].today,
                    yValueMapper: (int index) => int.parse(snapshot.data![index].end),
                    dataCount: snapshot.data!.length,
                  ),
                ),
              )
            ]);
      },
    );
  }
}
