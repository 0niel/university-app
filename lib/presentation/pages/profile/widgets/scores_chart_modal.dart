import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/domain/entities/score.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ScoresChartModal extends StatefulWidget {
  const ScoresChartModal({Key? key, required this.scores}) : super(key: key);

  final Map<String, List<Score>> scores;

  @override
  State<ScoresChartModal> createState() => _ScoresChartModalState();
}

class _ScoresChartModalState extends State<ScoresChartModal> {
  late List<_ChartData> chartData;

  int _getScoreByName(String name) {
    switch (name.toLowerCase()) {
      case "отлично":
        return 5;
      case "хорошо":
        return 4;
      case "удовлетворительно":
        return 3;
      default:
        return -1;
    }
  }

  Map<int, double> _getAverageRating(Map<String, List<Score>> fullScores) {
    Map<int, double> rating = {};

    for (final scoresKey in fullScores.keys.toList()) {
      final scores = fullScores[scoresKey]!;
      final semester = int.parse(scoresKey.split(' ')[0]);

      int count = 0;
      double average = 0;
      for (final score in scores) {
        final scoreValue = _getScoreByName(score.result);

        if (scoreValue != -1) {
          count++;
          average += scoreValue;
        }
      }

      average = average / count;
      rating[semester] = average;
    }

    return rating;
  }

  @override
  void initState() {
    final Map<int, double> averageRating = _getAverageRating(widget.scores);
    chartData = [];
    for (final key in averageRating.keys.toList()) {
      chartData.add(_ChartData(key, averageRating[key]!));
    }
    super.initState();
  }

  @override
  void dispose() {
    chartData.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      backgroundColor: DarkThemeColors.background02,
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: 'Средний балл успеваемости'),
      legend:
          Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
      primaryXAxis: NumericAxis(
          labelFormat: '{value} семестр',
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          interval: 1,
          majorGridLines: const MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
          labelFormat: '{value}',
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(color: Colors.transparent)),
      series: [
        LineSeries<_ChartData, num>(
            animationDuration: 2500,
            dataSource: chartData,
            xValueMapper: (_ChartData sales, _) => sales.x,
            yValueMapper: (_ChartData sales, _) => sales.y,
            width: 2,
            name: 'Средний балл',
            markerSettings: const MarkerSettings(isVisible: true)),
      ],
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  /// Semester
  final int x;

  /// Average rating
  final double y;
}
