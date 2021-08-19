import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/schedule_bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class GroupTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.toUpperCase();
    // if (oldValue.text.length == 3 && newValue.text.length == 4) {
    //   newValue.text += '-';
    // } else if (oldValue.text.length == 6 && newValue.text.length == 7) {
    //   newText += '-';
    // }

    return TextEditingValue(
      text: newText,
      selection: newText.length != newValue.text.length
          ? TextSelection.collapsed(offset: newText.length)
          : newValue.selection,
    );
  }
}

TextEditingController inputController = TextEditingController();

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
          controller: inputController,
          autofocus: false,
          style: DarkTextTheme.titleM,
          autocorrect: false,
          keyboardType: TextInputType.text,
          inputFormatters: [
            GroupTextFormatter(),
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
          inputController.text = suggestion;
          context
              .read<ScheduleBloc>()
              .add(ScheduleUpdateGroupSuggestionEvent(suggestion: suggestion));
        },
      ),
    );
  }
}
