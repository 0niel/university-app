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

enum _TrendlineTypeCustom {
  linear,
  exponential,
  power,
  logarithmic,
  polynomial,
  movingAverage,
  none,
}

class _ScoresChartModalState extends State<ScoresChartModal> {
  late List<_ChartData> chartData;

  TrendlineType _getTrendlineType(_TrendlineTypeCustom type) {
    switch (type) {
      case _TrendlineTypeCustom.linear:
        return TrendlineType.linear;
      case _TrendlineTypeCustom.exponential:
        return TrendlineType.exponential;
      case _TrendlineTypeCustom.power:
        return TrendlineType.power;
      case _TrendlineTypeCustom.logarithmic:
        return TrendlineType.logarithmic;
      case _TrendlineTypeCustom.polynomial:
        return TrendlineType.polynomial;
      case _TrendlineTypeCustom.movingAverage:
        return TrendlineType.movingAverage;
      case _TrendlineTypeCustom.none:
        break;
    }
    return TrendlineType.linear;
  }

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

  _TrendlineTypeCustom _trendlineType = _TrendlineTypeCustom.none;

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
          legendItemBuilder: (legendText, series, point, seriesIndex) =>
              Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: series.color,
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    legendText,
                    style: AppTextStyle.bodyBold.copyWith(
                      color: AppTheme.colors.active.withOpacity(0.8),
                    ),
                  ),
                ]),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _trendlineType = _TrendlineTypeCustom.values[
                          (_TrendlineTypeCustom.values.indexOf(_trendlineType) +
                                  1) %
                              _TrendlineTypeCustom.values.length];
                    });
                  },
                  child: Row(children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppTheme.colors.active.withOpacity(0.1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Icon(
                        Icons.trending_up,
                        size: 16,
                        color: AppTheme.colors.active,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _trendlineType.toString().split('.').last,
                      style: AppTextStyle.bodyBold.copyWith(
                        color: AppTheme.colors.active.withOpacity(0.8),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
        primaryXAxis: NumericAxis(
          labelFormat: '{value} сем.',
          interval: 0.5,
          axisLine: const AxisLine(width: 0),
          labelStyle:
              AppTextStyle.chip.copyWith(color: AppTheme.colors.deactive),
          minimum: 0.5,
          majorTickLines: const MajorTickLines(color: Colors.transparent),
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          majorGridLines: const MajorGridLines(width: 0),
          axisLabelFormatter: (axisLabelRenderArgs) => ChartAxisLabel(
            axisLabelRenderArgs.value % 1 == 0 ? axisLabelRenderArgs.text : '',
            AppTextStyle.chip.copyWith(
              color: AppTheme.colors.deactive,
            ),
          ),
        ),
        primaryYAxis: NumericAxis(
          labelFormat: '{value}',
          axisLine: const AxisLine(width: 0),
          labelStyle:
              AppTextStyle.chip.copyWith(color: AppTheme.colors.deactive),
          maximum: 5,
          majorTickLines: const MajorTickLines(color: Colors.transparent),
        ),
        series: [
          ColumnSeries<_ChartData, num>(
            trendlines: [
              if (_trendlineType != _TrendlineTypeCustom.none)
                Trendline(
                  type: _getTrendlineType(_trendlineType),
                  color: AppTheme.colors.colorful01.withOpacity(0.2),
                  dashArray: [5, 5],
                  width: 2,
                ),
            ],
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
