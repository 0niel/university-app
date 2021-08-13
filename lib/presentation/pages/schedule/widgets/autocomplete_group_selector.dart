import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/schedule_bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CaseFormatting extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(text: newValue.text, selection: newValue.selection);
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class AutocompleteGroupSelector extends StatelessWidget {
  const AutocompleteGroupSelector({Key? key, required this.groupsList})
      : super(key: key);

  final List<String> groupsList;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) => TypeAheadField(
        hideOnError: false,
        textFieldConfiguration: TextFieldConfiguration(
          autofocus: false,
          style: DarkTextTheme.titleM,
          autocorrect: false,
          inputFormatters: [
            CaseFormatting(),
            UpperCaseTextFormatter(),
          ],
          decoration: InputDecoration(
            errorText: state is ScheduleGroupNotFound
                ? 'заданная группа не найдена'
                : null,
            hintText: 'АБВГ-12-34',
            hintStyle:
                DarkTextTheme.titleM.copyWith(color: DarkThemeColors.deactive),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: DarkThemeColors.colorful05),
            ),
          ),
        ),
        itemBuilder: (context, suggestion) => Container(
          color: DarkThemeColors.background03,
          child: Padding(
            padding: EdgeInsets.all(4.0),
            child: Text(suggestion.toString()),
          ),
        ),
        noItemsFoundBuilder: (context) => Container(
          alignment: Alignment.center,
          color: DarkThemeColors.background03,
          child: Text('Группы не найдены', style: DarkTextTheme.titleM),
        ),
        suggestionsCallback: (search) async {
          context.read<ScheduleBloc>().add(ScheduleUpdateGroupSuggestionEvent(
              suggestion: search.toUpperCase()));
          return groupsList
              .where(
                  (group) => group.toUpperCase().contains(search.toUpperCase()))
              .toList();
        },
        onSuggestionSelected: (String suggestion) {
          context
              .read<ScheduleBloc>()
              .add(ScheduleUpdateGroupSuggestionEvent(suggestion: suggestion));
        },
      ),
    );
  }
}
