import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rtu_mirea_app/domain/entities/score.dart';
import 'package:rtu_mirea_app/presentation/bloc/scores_bloc/scores_bloc.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';

class ScoreResultCard extends StatefulWidget {
  const ScoreResultCard({
    Key? key,
    required this.score,
    required this.thisSubjectPrevSemestersScores,
  }) : super(key: key);

  final Score score;
  final List<Score> thisSubjectPrevSemestersScores;

  @override
  State<ScoreResultCard> createState() => _ScoreResultCardState();
}

enum ViewType { minify, expanded }

enum ScoreTrend { decrease, increase, none }

class _ScoreResultCardState extends State<ScoreResultCard> {
  var _viewType = ViewType.minify;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _viewType = _viewType == ViewType.minify ? ViewType.expanded : ViewType.minify;
        });
      },
      child: _buildCard(
        _viewType == ViewType.expanded,
      )
          .animate(
        target: _viewType == ViewType.expanded ? 1.0 : 0.0,
        autoPlay: false,
      )
          .toggle(builder: (context, value, child) {
        return AnimatedSize(
          key: ValueKey('score-${widget.score.hashCode}'),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          duration: 200.ms,
          child: child,
        );
      }),
    );
  }

  ScoreTrend _getScoreTrend() {
    final thisScore = widget.score.result;
    final prevScores = widget.thisSubjectPrevSemestersScores;

    if (prevScores.isEmpty) return ScoreTrend.none;

    final prevScore = prevScores.first.result;

    if (thisScore.equalsIgnoreCase(prevScore)) return ScoreTrend.none;

    final thisScoreValue = ScoresBloc.getScoreByName(thisScore);
    final prevScoreValue = ScoresBloc.getScoreByName(prevScore);

    if (thisScoreValue == -1 || prevScoreValue == -1) return ScoreTrend.none;

    if (thisScoreValue > prevScoreValue) return ScoreTrend.increase;
    if (thisScoreValue < prevScoreValue) return ScoreTrend.decrease;

    return ScoreTrend.none;
  }

  Widget _buildCard(bool expand) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      surfaceTintColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildScore(widget.score.type, widget.score.result),
                  const SizedBox(height: 9),
                  _buildSubjectName(widget.score.subjectName),
                  if (expand) ...[
                    const Divider(height: 24),
                    const SizedBox(height: 4),
                    _buildTeacherName(widget.score.comission),
                    const SizedBox(height: 12),
                    _buildYear(widget.score.year),
                    const SizedBox(height: 12),
                    _buildDate(widget.score.date),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreTrendIcon() {
    final trend = _getScoreTrend();
    final icon = trend == ScoreTrend.increase
        ? Icons.arrow_upward_rounded
        : trend == ScoreTrend.decrease
            ? Icons.arrow_downward_rounded
            : null;

    if (icon == null) return const SizedBox();

    return Icon(
      icon,
      color: trend == ScoreTrend.increase
          ? Colors.green
          : trend == ScoreTrend.decrease
              ? AppTheme.colorsOf(context).colorful07
              : Colors.transparent,
    );
  }

  Widget _buildScore(String type, String result) {
    return Row(
      children: [
        Text(
          type,
          style: AppTextStyle.body.copyWith(
            color: AppTheme.colorsOf(context).colorful03,
          ),
        ),
        const SizedBox(width: 10),
        _buildScoreResult(result),
      ],
    );
  }

  Widget _buildSubjectName(String name) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            name,
            style: AppTextStyle.titleM,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        _buildScoreTrendIcon(),
      ],
    );
  }

  Widget _buildScoreResult(String result) {
    final resultColor = getColorByResult(result);
    return Expanded(
      child: Row(
        children: [
          Icon(FontAwesomeIcons.solidStar, size: 12, color: resultColor),
          const SizedBox(width: 6),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                result,
                style: AppTextStyle.body.copyWith(color: resultColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherName(String? teacherName) {
    return _buildLineWithIcon(Icons.person_sharp, teacherName ?? "");
  }

  Widget _buildYear(String year) {
    return _buildLineWithIcon(Icons.calendar_month, year);
  }

  Widget _buildDate(String date) {
    return _buildLineWithIcon(Icons.calendar_month, date);
  }

  Widget _buildLineWithIcon(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 10),
        text.isNotEmpty ? Expanded(child: Text(text, style: AppTextStyle.body)) : _buildEmtyDataLine(context),
      ],
    );
  }
}

Widget _buildEmtyDataLine(BuildContext context) {
  return Container(
    height: 1,
    width: 48,
    color: AppTheme.colorsOf(context).deactiveDarker,
  );
}

Color getColorByResult(String result) {
  final resultLookup = {
    "не зачтено": AppTheme.colors.colorful07,
    "неуваж": AppTheme.colors.colorful07,
    "зач": Colors.green,
    "зачет": Colors.green,
    "отл": Colors.green,
    "отлично": Colors.green,
    "хор": AppTheme.colors.colorful05,
    "хорошо": AppTheme.colors.colorful05,
    "удовл": AppTheme.colors.colorful06,
    "удовлетворительно": AppTheme.colors.colorful06,
  };

  for (var entry in resultLookup.entries) {
    if (result.toLowerCase().contains(entry.key)) return entry.value;
  }
  return Colors.white;
}

extension on String {
  bool equalsIgnoreCase(String other) => toLowerCase() == other.toLowerCase();
}
