import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rtu_mirea_app/domain/entities/score.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';

class ScoreResultCard extends StatefulWidget {
  const ScoreResultCard({Key? key, required this.score}) : super(key: key);

  final Score score;

  @override
  State<ScoreResultCard> createState() => _ScoreResultCardState();
}

enum ViewType { minify, expanded }

class _ScoreResultCardState extends State<ScoreResultCard> {
  var _viewType = ViewType.minify;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _viewType = _viewType == ViewType.minify
              ? ViewType.expanded
              : ViewType.minify;
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

  Widget _buildCard(bool expand) {
    return Card(
      color: AppTheme.themeMode == ThemeMode.dark
          ? AppTheme.colors.background03
          : AppTheme.colors.background02,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      surfaceTintColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildScore(widget.score.type, widget.score.result),
            const SizedBox(height: 9),
            _buildScoreName(widget.score.subjectName),
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
    );
  }

  Widget _buildScore(String type, String result) {
    return Row(
      children: [
        Text(
          type,
          style: AppTextStyle.body.copyWith(
            color: AppTheme.colors.colorful03,
          ),
        ),
        const SizedBox(width: 10),
        _buildScoreResult(result),
      ],
    );
  }

  Widget _buildScoreName(String name) {
    return Text(name, style: AppTextStyle.titleM);
  }

  Widget _buildScoreResult(String result) {
    final resultColor = getColorByResult(result);
    return Row(
      children: [
        Icon(FontAwesomeIcons.solidStar, size: 12, color: resultColor),
        const SizedBox(width: 6),
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(result,
              style: AppTextStyle.body.copyWith(color: resultColor)),
        ),
      ],
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
        Expanded(child: Text(text, style: AppTextStyle.body)),
      ],
    );
  }
}

Color getColorByResult(String result) {
  final resultLookup = {
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
