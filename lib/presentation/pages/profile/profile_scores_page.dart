import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/domain/entities/score.dart';
import 'package:rtu_mirea_app/presentation/bloc/scores_bloc/scores_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:rtu_mirea_app/presentation/pages/profile/widgets/scores_chart_modal.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/primary_tab_button.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

Color getColorByResult(String result) {
  result = result.toLowerCase();

  if (result.contains("неуваж")) {
    return AppTheme.colors.colorful07;
  }

  if (result.contains("зач")) {
    return Colors.green;
  } else if (result.contains("отл")) {
    return Colors.green;
  } else if (result.contains("хор")) {
    return AppTheme.colors.colorful05;
  } else if (result.contains("удовл")) {
    return AppTheme.colors.colorful06;
  } else {
    return Colors.white;
  }
}

enum ViewType { table, cards }

class ProfileScoresPage extends StatefulWidget {
  const ProfileScoresPage({Key? key}) : super(key: key);

  @override
  State<ProfileScoresPage> createState() => _ProfileScoresPageState();
}

class _ProfileScoresPageState extends State<ProfileScoresPage> {
  final ValueNotifier<int> _tabValueNotifier = ValueNotifier(0);

  ViewType _viewType = ViewType.cards;

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
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, userState) {
            return userState.maybeMap(
              logInSuccess: (userStateLoaded) =>
                  BlocBuilder<ScoresBloc, ScoresState>(
                builder: (context, state) {
                  final user = userStateLoaded.user;
                  var student = UserBloc.getActiveStudent(user);

                  if (state is ScoresInitial) {
                    context
                        .read<ScoresBloc>()
                        .add(LoadScores(studentCode: student.code));
                  } else if (state is ScoresLoaded) {
                    _tabValueNotifier.value = state.scores.keys
                        .toList()
                        .indexOf(state.selectedSemester);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                  text: '$semester семестр',
                                  itemIndex: index,
                                  notifier: _tabValueNotifier,
                                  onClick: () {
                                    _tabValueNotifier.value = index;
                                    context.read<ScoresBloc>().add(
                                        ChangeSelectedScoresSemester(
                                            semester: semester));
                                  },
                                );
                              },
                              itemCount: state.scores.keys.length),
                        ),
                        // Небольшая кнопка с иконкой для открытия модального окна с графиком
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Всего предметов: ${state.scores[state.selectedSemester]!.length}",
                                style: AppTextStyle.body,
                              ),
                              Row(children: [
                                IconButton(
                                  onPressed: () => showModalBottomSheet(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                    backgroundColor:
                                        AppTheme.colors.background02,
                                    context: context,
                                    builder: (BuildContext context) =>
                                        ScoresChartModal(scores: state.scores),
                                  ),
                                  icon: const Icon(Icons.bar_chart),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _viewType = _viewType == ViewType.table
                                          ? ViewType.cards
                                          : ViewType.table;
                                    });
                                  },
                                  icon: Icon(_viewType == ViewType.cards
                                      ? Icons.view_list
                                      : Icons.view_module),
                                ),
                              ]),
                            ],
                          ),
                        ),

                        Expanded(
                          child: _viewType == ViewType.table
                              ? _ScoresDataGrid(
                                  dataGridSource: _ScoresDataGridSource(
                                      state.scores[state.selectedSemester]!))
                              : _ScoresCardListView(
                                  scores:
                                      state.scores[state.selectedSemester]!),
                        ),
                      ],
                    );
                  } else if (state is ScoresLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ScoresLoadError) {
                    return Center(
                      child: Text(
                          "Произошла ошибка при попытке загрузить посещаемость. Повторите попытку позже",
                          style: AppTextStyle.body),
                    );
                  }
                  return Container();
                },
              ),
              orElse: () => Container(),
            );
          },
        ),
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
      itemBuilder: (context, index) {
        final Score score = scores[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Card(
            color: AppTheme.colors.background02,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    score.type,
                    style: AppTextStyle.body.copyWith(
                        color: score.type.toLowerCase() == "экзамен"
                            ? AppTheme.colors.colorful04
                            : AppTheme.colors.colorful02),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    score.subjectName,
                    style: AppTextStyle.titleM,
                  ),
                  Divider(
                    color: AppTheme.colors.deactiveDarker,
                    height: 30,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star_border_outlined,
                        color: getColorByResult(score.result),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        score.result,
                        style: AppTextStyle.body
                            .copyWith(color: getColorByResult(score.result)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.person_sharp,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          score.comission ?? "",
                          style: AppTextStyle.body,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month,
                      ),
                      const SizedBox(width: 10),
                      Text(score.year, style: AppTextStyle.body),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month,
                      ),
                      const SizedBox(width: 10),
                      Text(score.date, style: AppTextStyle.body),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      itemCount: scores.length,
    );
  }
}

class _ScoresDataGrid extends StatelessWidget {
  const _ScoresDataGrid({Key? key, required this.dataGridSource})
      : super(key: key);

  final _ScoresDataGridSource dataGridSource;

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      source: dataGridSource,
      columnWidthMode: ColumnWidthMode.auto,
      rowHeight: 80,
      columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
      columns: <GridColumn>[
        GridColumn(
          columnName: 'date',
          width: 90,
          label: const Center(child: Text('Дата')),
        ),
        GridColumn(
          columnWidthMode: ColumnWidthMode.fitByColumnName,
          columnName: 'name',
          width: 180,
          label: Container(
            alignment: Alignment.centerLeft,
            child: const Text('Название'),
          ),
        ),
        GridColumn(
          maximumWidth: 180,
          columnName: 'score',
          columnWidthMode: ColumnWidthMode.fitByCellValue,
          label: const Center(
            child: Text('Оценка'),
          ),
        ),
        GridColumn(
            columnWidthMode: ColumnWidthMode.fitByCellValue,
            columnName: 'type',
            label: const Center(
              child: Text('Тип'),
            )),
        GridColumn(
          columnWidthMode: ColumnWidthMode.fitByCellValue,
          columnName: 'teacher',
          label: Container(
            alignment: Alignment.centerLeft,
            child: const Text('Преподаватель'),
          ),
        ),
      ],
    );
  }
}

/// Set team's data collection to data grid source.
class _ScoresDataGridSource extends DataGridSource {
  /// Creates the team data source class with required details.
  _ScoresDataGridSource(List<Score> scores) {
    _scores = scores
        .map((e) => e.copyWith(result: _shortenResult(e.result)))
        .toList();
    buildDataGridRows();
  }

  List<Score> _scores = <Score>[];

  List<DataGridRow> _dataGridRows = <DataGridRow>[];

  /// Building DataGridRows
  void buildDataGridRows() {
    _dataGridRows = _scores.map<DataGridRow>((Score score) {
      return DataGridRow(cells: <DataGridCell>[
        DataGridCell<String>(columnName: 'date', value: score.date),
        DataGridCell<String>(columnName: 'name', value: score.subjectName),
        DataGridCell<String>(columnName: 'score', value: score.result),
        DataGridCell<String>(columnName: 'type', value: score.type),
        DataGridCell<String>(
            columnName: 'teacher', value: score.comission ?? ""),
      ]);
    }).toList();
  }

  String _shortenResult(String score) {
    switch (score.toLowerCase()) {
      case 'зачтено':
        return "Зач.";
      case 'отлично':
        return "Отл.";
      case 'хорошо':
        return "Хор.";
      case 'удовлетворительно':
        return "Удовл.";
      default:
        return score;
    }
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: <Widget>[
      Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Text(
          row.getCells()[0].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.centerLeft,
        child: Text(
          row.getCells()[1].value.toString(),
          softWrap: true,
        ),
      ),
      Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Text(
          row.getCells()[2].value.toString(),
          style: TextStyle(
              color: getColorByResult(row.getCells()[2].value.toString())),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Text(
          row.getCells()[3].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.centerLeft,
        child: Text(
          row.getCells()[4].value.toString(),
          softWrap: true,
        ),
      ),
    ]);
  }
}
