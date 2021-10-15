import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/schedule_bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class GroupTextFormatter extends TextInputFormatter {
  GroupTextFormatter();

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;

    if (oldValue.text.length == 3 && newValue.text.length == 4) {
      newText += '-';
    } else if (oldValue.text.length == 6 && newValue.text.length == 7) {
      newText += '-';
    }

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class AutocompleteGroupSelector extends StatefulWidget {
  const AutocompleteGroupSelector({Key? key}) : super(key: key);

  @override
  _AutocompleteGroupSelectorState createState() =>
      _AutocompleteGroupSelectorState();
}

class _AutocompleteGroupSelectorState extends State<AutocompleteGroupSelector> {
  final TextInputType _keyboardType = TextInputType.text;
  late TextEditingController _inputController;

  @override
  void initState() {
    _inputController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      buildWhen: (prevState, currentState) => prevState != currentState,
      builder: (context, state) {
        return TypeAheadField(
          hideOnError: false,
          textFieldConfiguration: TextFieldConfiguration(
            focusNode: FocusNode(),
            controller: _inputController,
            autofocus: false,
            style: DarkTextTheme.titleM,
            keyboardType: _keyboardType,
            autocorrect: false,
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              GroupTextFormatter(),
            ],
            decoration: InputDecoration(
              errorText: state is ScheduleGroupNotFound
                  ? 'заданная группа не найдена'
                  : null,
              hintText: 'АБВГ-12-34',
              hintStyle: DarkTextTheme.titleM
                  .copyWith(color: DarkThemeColors.deactive),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: DarkThemeColors.colorful05),
              ),
            ),
          ),
          itemBuilder: (context, suggestion) => Container(
            color: DarkThemeColors.background03,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
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
            return ScheduleBloc.groupsList
                .where((group) =>
                    group.toUpperCase().contains(search.toUpperCase()))
                .toList();
          },
          keepSuggestionsOnSuggestionSelected: true,
          onSuggestionSelected: (String suggestion) {
            _inputController.text = suggestion;
            context.read<ScheduleBloc>().add(
                ScheduleUpdateGroupSuggestionEvent(suggestion: suggestion));
          },
        );
      },
    );
  }
}
