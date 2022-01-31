import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/scores_bloc/scores_bloc.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/primary_tab_button.dart';

class ProfileScoresPage extends StatefulWidget {
  const ProfileScoresPage({Key? key}) : super(key: key);

  @override
  State<ProfileScoresPage> createState() => _ProfileScoresPageState();
}

class _ProfileScoresPageState extends State<ProfileScoresPage> {
  final ValueNotifier<int> _tabValueNotifier = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Детали профиля"),
        backgroundColor: DarkThemeColors.background01,
      ),
      backgroundColor: DarkThemeColors.background01,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            if (authState is LogInSuccess) {
              return BlocBuilder<ScoresBloc, ScoresState>(
                builder: (context, state) {
                  if (state is ScoresInitial) {
                    context
                        .read<ScoresBloc>()
                        .add(LoadScores(token: authState.token));
                  } else if (state is ScoresLoaded) {
                    _tabValueNotifier.value = state.scores.keys
                        .toList()
                        .indexOf(state.selectedSemester);
                    return Column(
                      children: [
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 32,
                          width: double.infinity,
                          child: ListView.builder(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final String semester =
                                    state.scores.keys.toList()[index];
                                return PrimaryTabButton(
                                    text: semester + ' семестр',
                                    itemIndex: index,
                                    notifier: _tabValueNotifier,
                                    onClick: () {
                                      _tabValueNotifier.value = index;
                                      context.read<ScoresBloc>().add(
                                          ChangeSelectedScoresSemester(
                                              semester: semester));
                                    });
                              },
                              itemCount: state.scores.keys.length),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            itemBuilder: (context, index) {
                              final scores =
                                  state.scores[state.selectedSemester]!;

                              if (scores[index].exam != null &&
                                  scores[index].credit != null) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(scores[index].subjectName,
                                        style: DarkTextTheme.bodyBold),
                                    Text("Тип: " + scores[index].type,
                                        style: DarkTextTheme.bodyRegular),
                                    Text(
                                        "Оценка за курсовую: " +
                                            scores[index].credit!,
                                        style: DarkTextTheme.bodyRegular),
                                    Text(
                                        "Оценка за экзамен: " +
                                            scores[index].exam!,
                                        style: DarkTextTheme.bodyRegular),
                                    if (scores[index].comission != null)
                                      Text(
                                          "Преподаватель: " +
                                              scores[index].comission!,
                                          style: DarkTextTheme.bodyRegular),
                                    Text("Год: " + scores[index].year,
                                        style: DarkTextTheme.bodyRegular),
                                    Text("Дата: " + scores[index].date,
                                        style: DarkTextTheme.bodyRegular),
                                  ],
                                );
                              }
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(scores[index].subjectName,
                                      style: DarkTextTheme.bodyBold),
                                  Text("Тип: " + scores[index].type,
                                      style: DarkTextTheme.bodyRegular),
                                  Text("Оценка: " + scores[index].result,
                                      style: DarkTextTheme.bodyRegular),
                                  if (scores[index].comission != null)
                                    Text(
                                        "Преподаватель: " +
                                            scores[index].comission!,
                                        style: DarkTextTheme.bodyRegular),
                                  Text("Год: " + scores[index].year,
                                      style: DarkTextTheme.bodyRegular),
                                  Text("Дата: " + scores[index].date,
                                      style: DarkTextTheme.bodyRegular),
                                ],
                              );
                            },
                            separatorBuilder: (context, index) => index !=
                                    state.scores[state.selectedSemester]!
                                            .length -
                                        1
                                ? const Divider()
                                : const SizedBox(height: 16),
                            itemCount:
                                state.scores[state.selectedSemester]!.length,
                          ),
                        ),
                      ],
                    );
                  } else if (state is ScoresLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ScoresLoadError) {
                    return Center(
                      child: Text(
                          "Произошла ошибка при попытке загрузить посещаемость. Повторите попытку позже",
                          style: DarkTextTheme.body),
                    );
                  }
                  return Container();
                },
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
