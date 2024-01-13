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
        backgroundColor: AppTheme.colors.background01,
      ),
      backgroundColor: AppTheme.colors.background01,
      body: SafeArea(
        bottom: false,
        child: _buildUserBlocBuilder(),
      ),
    );
  }

  Widget _buildUserBlocBuilder() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, userState) {
        if (userState.status == UserStatus.authorized &&
            userState.user != null) {
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
    return BlocBuilder<ScoresBloc, ScoresState>(
      builder: (context, state) {
        final user = userStateLoaded.user!;
        final student = UserBloc.getActiveStudent(user);

        if (state is ScoresInitial) {
          context.read<ScoresBloc>().add(LoadScores(studentCode: student.code));
        } else if (state is ScoresLoaded) {
          _tabValueNotifier.value =
              (int.tryParse(state.selectedSemester) ?? 1) - 1;

          return _buildScoresLoadedLayout(state);
        } else if (state is ScoresLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ScoresLoadError) {
          return _buildErrorText();
        }
        return Container();
      },
    );
  }

  Widget _buildScoresLoadedLayout(ScoresLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        _buildSemesterTabs(state),
        _buildChartButtonRow(state),
        Expanded(
          child: _ScoresCardListView(
              scores: state.scores[state.selectedSemester] ?? []),
        ),
      ],
    );
  }

  Widget _buildSemesterTabs(ScoresLoaded state) {
    return SizedBox(
      height: 32,
      width: double.infinity,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final semester = state.scores.keys.elementAt(index);
          return PrimaryTabButton(
            text: '$semester семестр',
            itemIndex: index,
            notifier: _tabValueNotifier,
            onClick: () => _onTabClicked(context, index, semester),
          );
        },
        itemCount: state.scores.length,
      ),
    );
  }

  Widget _buildChartButtonRow(ScoresLoaded state) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 12, top: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Всего предметов: ${state.scores[state.selectedSemester]?.length}",
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
    context
        .read<ScoresBloc>()
        .add(ChangeSelectedScoresSemester(semester: semester));
  }

  void _showScoresChartModal() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      backgroundColor: AppTheme.colors.background02,
      context: context,
      builder: (context) => BlocBuilder<ScoresBloc, ScoresState>(
        builder: (context, state) {
          if (state is ScoresLoaded) {
            return ScoresChartModal(scores: state.scores);
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
  const _ScoresCardListView({Key? key, required this.scores}) : super(key: key);

  final List<Score> scores;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemBuilder: (context, index) {
        final score = scores[index];
        return ScoreResultCard(score: score);
      },
      itemCount: scores.length,
    );
  }
}
