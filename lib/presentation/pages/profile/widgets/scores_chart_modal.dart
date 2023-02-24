import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/domain/entities/score.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

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
      case "зачтено":
        return -1;
      default:
        return 0;
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
      rating[semester] = double.parse(average.toStringAsFixed(2));
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
    // Add border radius to top left and top right. Container decoration does not work
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: SfCartesianChart(
        backgroundColor: AppTheme.colors.background02,
        plotAreaBorderWidth: 0,
        title: ChartTitle(
          text: 'Успеваемость',
          textStyle: AppTextStyle.titleS,
          alignment: ChartAlignment.center,
        ),
        plotAreaBorderColor: AppTheme.colors.active.withOpacity(0.05),
        borderWidth: 0,
        legend: Legend(
          isVisible: true,
          overflowMode: LegendItemOverflowMode.wrap,
          borderColor: Colors.transparent,
          position: LegendPosition.bottom,
          textStyle: AppTextStyle.bodyBold,
          iconHeight: 10,
          iconWidth: 10,
        ),
        primaryXAxis: NumericAxis(
          labelFormat: '{value} сем.',
          interval: 1,
          axisLine: const AxisLine(width: 0),
          labelStyle:
              AppTextStyle.chip.copyWith(color: AppTheme.colors.deactive),
          minimum: 1,
          majorTickLines: const MajorTickLines(color: Colors.transparent),
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
            labelFormat: '{value}',
            axisLine: const AxisLine(width: 0),
            labelStyle:
                AppTextStyle.chip.copyWith(color: AppTheme.colors.deactive),
            minimum: 2,
            maximum: 5,
            majorTickLines: const MajorTickLines(color: Colors.transparent)),
        series: [
          ColumnSeries<_ChartData, num>(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            animationDuration: 1500,
            dataSource: chartData,
            xValueMapper: (_ChartData sales, _) => sales.x,
            yValueMapper: (_ChartData sales, _) => sales.y,
            width: 0.08,
            color: AppTheme.colors.colorful01,
            name: 'Средний балл',
            markerSettings: const MarkerSettings(isVisible: false),
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              textStyle: AppTextStyle.bodyBold.copyWith(
                color: AppTheme.colors.active.withOpacity(0.8),
              ),
            ),
          ),
        ],
        tooltipBehavior: TooltipBehavior(enable: true),
      ),
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
