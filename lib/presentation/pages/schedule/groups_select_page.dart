import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/presentation/bloc/schedule_bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';

class GroupsSelectPage extends StatefulWidget {
  const GroupsSelectPage({Key? key}) : super(key: key);

  @override
  State<GroupsSelectPage> createState() => _GroupsSelectPageState();
}

class _GroupTextFormatter extends TextInputFormatter {
  final groupMask = '0000-00-00';

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final result = StringBuffer();
    var text =
        newValue.text.replaceAll('-', '').replaceAll(' ', '').toUpperCase();
    if (text.length > 1 && oldValue.text.length > newValue.text.length) {
      text = text.substring(0, text.length);
    }
    var readPosition = 0;
    for (var i = 0; i < groupMask.length; i++) {
      if (readPosition > text.length - 1) {
        break;
      }
      var curSymbol = groupMask[i];
      if (isZeroSymbol(curSymbol)) {
        curSymbol = text[readPosition];
        readPosition++;
      }
      result.write(curSymbol);
    }
    final textResult = result.toString();
    return TextEditingValue(
      text: textResult,
      selection: TextSelection.collapsed(
        offset: textResult.length,
      ),
    );
  }

  bool isZeroSymbol(String symbol) => symbol == "0";
}

class _GroupsSelectPageState extends State<GroupsSelectPage> {
  String _getInstituteByGroup(
      String group, Map<String, List<String>> groupsByInstitute) {
    final groupNameOnly = group.split('-')[0];

    String institute = '';

    for (final instituteName in groupsByInstitute.keys) {
      for (final groupName in groupsByInstitute[instituteName]!) {
        if (groupName.contains(groupNameOnly)) {
          institute = instituteName;
          break;
        }
      }
    }

    return institute;
  }

  Color _getInstituteColor(
      String group, Map<String, List<String>> groupsByInstitute) {
    switch (_getInstituteByGroup(group, groupsByInstitute)) {
      case 'ИИТ':
        return const Color(0xff697582);
      case 'ИИИ':
        return const Color(0xff36933e);
      case 'ИКБ':
        return const Color(0xFF163c4f);
      case 'ИТУ':
        return const Color(0xffbd5435);
      case 'КПК':
        return const Color(0xffed7f25);
      case 'ИТХТ':
        return const Color(0xffa1448d);
      case 'ИРИ':
        return const Color(0xff490063);
      case 'ИПТИП':
        return const Color(0xFFFFDD72);
      default:
        return const Color(0xff697582);
    }
  }

  bool _isFirstOpen = true;
  List<String> _filteredGroups = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.background01,
      appBar: AppBar(
        backgroundColor: AppTheme.colors.background01,
        title: const Text('Выбор группы'),
      ),
      body: SafeArea(
        child: BlocBuilder<ScheduleBloc, ScheduleState>(
          builder: (context, state) {
            if (state is ScheduleLoaded || state is ScheduleActiveGroupEmpty) {
              final groups = state is ScheduleLoaded
                  ? state.groups
                  : (state as ScheduleActiveGroupEmpty).groups;
              final groupsByInstitute = state is ScheduleLoaded
                  ? state.groupsByInstitute
                  : (state as ScheduleActiveGroupEmpty).groupsByInstitute;

              // On first open, set groups to all groups
              if (groups.isNotEmpty && _isFirstOpen) {
                _filteredGroups = groups;
                _isFirstOpen = false;
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(height: 16),
                    _GroupTextField(onChanged: (value) {
                      setState(() {
                        _filteredGroups = groups
                            .where((group) => group
                                .toUpperCase()
                                .contains(value.toUpperCase()))
                            .toList();
                      });
                    }),
                    const SizedBox(height: 16),
                    if (_filteredGroups.isNotEmpty)
                      Expanded(
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: _filteredGroups.length,
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                          itemBuilder: (context, index) {
                            return _GroupListTile(
                              group: _filteredGroups[index],
                              institute: _getInstituteByGroup(
                                  _filteredGroups[index], groupsByInstitute),
                              color: _getInstituteColor(
                                  _filteredGroups[index], groupsByInstitute),
                              onTap: () {
                                context.read<ScheduleBloc>().add(
                                      ScheduleSetActiveGroupEvent(
                                          group: _filteredGroups[index]),
                                    );
                                context.pop();
                              },
                            );
                          },
                        ),
                      ),
                  ],
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

class _GroupTextField extends StatelessWidget {
  const _GroupTextField({Key? key, required this.onChanged}) : super(key: key);

  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppTheme.colors.background02,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        onChanged: (value) => onChanged(value),
        style: AppTextStyle.titleS.copyWith(
          color: AppTheme.colors.active,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          border: InputBorder.none,
          hintText: 'Поиск',
          hintStyle: AppTextStyle.titleS.copyWith(
            color: AppTheme.colors.deactive,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(right: 8, left: 16),
            child: SvgPicture.asset(
              'assets/icons/search.svg',
              color: AppTheme.colors.active,
              width: 24,
              height: 24,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            maxWidth: 48,
            maxHeight: 48,
          ),
        ),
        inputFormatters: [
          _GroupTextFormatter(),
        ],
      ),
    );
  }
}

class _GroupListTile extends StatelessWidget {
  const _GroupListTile({
    Key? key,
    required this.group,
    required this.color,
    required this.onTap,
    required this.institute,
  }) : super(key: key);

  final String group;
  final String institute;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        //color: AppTheme.colors.background03,
      ),
      child: Card(
        color: AppTheme.colors.background02,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        borderOnForeground: true,
        margin: const EdgeInsets.all(0),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                institute,
                style: AppTextStyle.titleS.copyWith(
                  color: institute == 'ИПТИП'
                      ? Colors.black.withOpacity(0.8)
                      : Colors.white.withOpacity(0.8),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          title: Text(
            group,
            style: AppTextStyle.titleM,
          ),
          trailing: const Icon(
            Icons.chevron_right,
            size: 24,
          ),
          onTap: () {
            context
                .read<ScheduleBloc>()
                .add(ScheduleSetActiveGroupEvent(group: group));
            context.pop();
          },
        ),
      ),
    );
  }
}
