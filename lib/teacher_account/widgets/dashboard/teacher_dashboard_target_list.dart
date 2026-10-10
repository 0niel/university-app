import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/widgets/rows/settings_rows.dart';

enum _TeacherDashboardTargetMode { preview, all }

class TeacherDashboardTargetList<T> extends StatefulWidget {
  const TeacherDashboardTargetList({
    required this.title,
    required this.items,
    required this.labelFor,
    required this.iconFor,
    required this.onOpen,
    super.key,
  });

  final String title;
  final List<T> items;
  final String Function(T) labelFor;
  final AppLineIcon Function(T) iconFor;
  final ValueChanged<T> onOpen;

  @override
  State<TeacherDashboardTargetList<T>> createState() =>
      _TeacherDashboardTargetListState<T>();
}

class _TeacherDashboardTargetListState<T>
    extends State<TeacherDashboardTargetList<T>> {
  _TeacherDashboardTargetMode _mode = _TeacherDashboardTargetMode.preview;

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();
    final visible = switch (_mode) {
      _TeacherDashboardTargetMode.preview => widget.items.take(8),
      _TeacherDashboardTargetMode.all => widget.items,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppOverline(widget.title),
        AppListGroup(
          children: [
            for (final item in visible)
              ProfileLinkRow(
                icon: widget.iconFor(item),
                title: widget.labelFor(item),
                onTap: () => widget.onOpen(item),
              ),
          ],
        ),
        if (_mode == _TeacherDashboardTargetMode.preview &&
            widget.items.length > 8)
          AppButton.text(
            label: context.l10n.all,
            expanded: true,
            onPressed: () => setState(() {
              _mode = _TeacherDashboardTargetMode.all;
            }),
          ),
      ],
    );
  }
}
