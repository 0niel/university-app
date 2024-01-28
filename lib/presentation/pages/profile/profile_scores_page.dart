import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/domain/entities/score.dart';
import 'package:rtu_mirea_app/presentation/bloc/scores_bloc/scores_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:rtu_mirea_app/presentation/pages/profile/widgets/score_result_card.dart';
import 'package:rtu_mirea_app/presentation/pages/profile/widgets/scores_chart_modal.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/primary_tab_button.dart';

class ProfileScoresPage extends StatefulWidget {
  const ProfileScoresPage({Key? key}) : super(key: key);

  @override
  State<ProfileScoresPage> createState() => _ProfileScoresPageState();
}

class _ProfileScoresPageState extends State<ProfileScoresPage> {
  final _tabValueNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Зачётная книжка"),
      ),
      body: SafeArea(
        bottom: false,
        child: _buildUserBlocBuilder(),
      ),
    );
  }

  Widget _buildUserBlocBuilder() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, userState) {
        if (userState.status == UserStatus.authorized && userState.user != null) {
          return _buildScoresBloc(userState);
        } else {
          return const Center(
            child: Text("Необходимо авторизоваться"),
          );
        }
      },
    );
  }

  Widget _buildScoresBloc(UserState userStateLoaded) {
    final user = userStateLoaded.user!;
    final student = UserBloc.getActiveStudent(user);

    context.read<ScoresBloc>().add(LoadScores(studentCode: student.code));

    return BlocConsumer<ScoresBloc, ScoresState>(
      bloc: context.read<ScoresBloc>(),
      listener: (context, state) {
        if (state.status == ScoresStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Произошла ошибка при загрузке оценок"),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.scores != null && state.selectedSemester != null) {
          _tabValueNotifier.value = (int.tryParse(state.selectedSemester ?? '') ?? 1) - 1;

          return _buildScoresLoadedLayout(state);
        } else if (state.status == ScoresStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Container();
      },
    );
  }

  Widget _buildScoresLoadedLayout(ScoresState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        _buildSemesterTabs(state),
        _buildChartButtonRow(state),
        Expanded(
          child: _ScoresCardListView(
            scores: state.scores!,
            selectedSemester: state.selectedSemester!,
          ),
        ),
      ],
    );
  }

  Widget _buildSemesterTabs(ScoresState state) {
    return SizedBox(
      height: 32,
      width: double.infinity,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final semester = state.scores!.keys.elementAt(index);
          return PrimaryTabButton(
            text: '$semester семестр',
            itemIndex: index,
            notifier: _tabValueNotifier,
            onClick: () => _onTabClicked(context, index, semester),
          );
        },
        itemCount: state.scores!.length,
      ),
    );
  }

  Widget _buildChartButtonRow(ScoresState state) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 12, top: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Всего предметов: ${state.scores![state.selectedSemester]?.length}",
            style: AppTextStyle.chip,
          ),
          _buildViewTypeToggleButton(),
        ],
      ),
    );
  }

  Widget _buildViewTypeToggleButton() {
    return Row(
      children: [
        IconButton(
          onPressed: _showScoresChartModal,
          icon: const Icon(Icons.bar_chart),
        ),
      ],
    );
  }

  void _onTabClicked(BuildContext context, int index, String semester) {
    _tabValueNotifier.value = index;
    context.read<ScoresBloc>().add(ChangeSelectedScoresSemester(semester: semester));
  }

  void _showScoresChartModal() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      backgroundColor: AppTheme.colorsOf(context).background02,
      context: context,
      builder: (context) => BlocBuilder<ScoresBloc, ScoresState>(
        builder: (context, state) {
          if (state.status == ScoresStatus.loaded) {
            return ScoresChartModal(
              scores: state.scores!,
              averageRating: state.averageRating!,
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildErrorText() {
    return Center(
      child: Text(
        "Произошла ошибка при попытке загрузить оценки. Повторите попытку позже",
        style: AppTextStyle.body,
      ),
    );
  }
}

class _ScoresCardListView extends StatelessWidget {
  const _ScoresCardListView({
    Key? key,
    required this.scores,
    required this.selectedSemester,
  }) : super(key: key);

  final Map<String, List<Score>> scores;
  final String selectedSemester;

  @override
  Widget build(BuildContext context) {
    final scores = this.scores[selectedSemester] ?? [];
    final prevSemesters = List.generate(
      int.parse(selectedSemester) - 1,
      (index) => this.scores[(index + 1).toString()] ?? [],
    );
    final cards = List.generate(
      scores.length,
      (index) {
        final score = scores[index];
        final prevSemestersScores = prevSemesters
            .expand((element) => element)
            .where((element) => element.subjectName == score.subjectName)
            .toList();
        return ScoreResultCard(
          score: score,
          thisSubjectPrevSemestersScores: prevSemestersScores,
        );
      },
    );

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: cards.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return const _AverageRatingCard();
        }
        return cards[index - 1];
      },
    );
  }
}

class _AverageRatingCard extends StatelessWidget {
  const _AverageRatingCard({Key? key}) : super(key: key);

  Color _getAverageRatingColor(double averageRating) {
    if (averageRating >= 4.5) {
      return Colors.green;
    }
    if (averageRating >= 4.0) {
      return AppTheme.colors.colorful05;
    }
    if (averageRating >= 3.0) {
      return AppTheme.colors.colorful06;
    } else {
      return AppTheme.colors.colorful07;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScoresBloc, ScoresState>(
      builder: (context, state) {
        final averageRating = state.averageRating;
        final selectedSemester = int.tryParse(state.selectedSemester ?? '') ?? 1;

        if (state.status == ScoresStatus.loaded) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            color: AppTheme.colorsOf(context).background02,
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: _getAverageRatingColor(
                      averageRating![selectedSemester] ?? 0,
                    ),
                    child: Text(
                      averageRating[selectedSemester].toString(),
                      style: AppTextStyle.h6.copyWith(
                        color: AppTheme.colorsOf(context).background01,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Средний балл",
                          style: AppTextStyle.bodyBold,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "За $selectedSemester семестр",
                          style: AppTextStyle.body,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
