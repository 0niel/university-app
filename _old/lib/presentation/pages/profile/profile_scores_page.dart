import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/domain/entities/score.dart';
import 'package:rtu_mirea_app/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/scores_bloc/scores_bloc.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/pages/profile/widgets/scores_chart_modal.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/text_outlined_button.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/primary_tab_button.dart';

class ProfileScoresPage extends StatefulWidget {
  const ProfileScoresPage({Key? key}) : super(key: key);

  @override
  State<ProfileScoresPage> createState() => _ProfileScoresPageState();
}

class _ProfileScoresPageState extends State<ProfileScoresPage> {
  final ValueNotifier<int> _tabValueNotifier = ValueNotifier(0);

  SfDataGrid _buildDataGridForMobile(_ScoresDataGridSource dateGridSource) {
    return SfDataGrid(
      source: dateGridSource,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Зачётная книжка"),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          child: TextOutlinedButton(
                              content: 'Средний балл',
                              width: 230,
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        ScoresChartModal(scores: state.scores));
                              }),
                        ),
                        Expanded(
                          child: _buildDataGridForMobile(_ScoresDataGridSource(
                              state.scores[state.selectedSemester]!)),
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

/// Set team's data collection to data grid source.
class _ScoresDataGridSource extends DataGridSource {
  /// Creates the team data source class with required details.
  _ScoresDataGridSource(List<Score> scores) {
    _scores = scores;
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

  Color _getColorByResult(String result) {
    if (result.contains("неуваж")) {
      return DarkThemeColors.colorful07;
    }

    switch (result.toLowerCase()) {
      case 'зачтено':
      case 'отлично':
        return Colors.green;
      case 'хорошо':
        return DarkThemeColors.colorful05;
      case 'удовлетворительно':
        return DarkThemeColors.colorful06;
      default:
        return Colors.white;
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
              color: _getColorByResult(row.getCells()[2].value.toString())),
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
