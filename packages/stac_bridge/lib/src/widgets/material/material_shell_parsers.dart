import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/widgets/kit/kit_image_parser.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

class KitAppBar extends StatelessWidget implements PreferredSizeWidget {
  const KitAppBar({
    required this.title,
    super.key,
    this.leading,
    this.actions = const [],
  });

  final String title;
  final Widget? leading;
  final List<Widget> actions;

  @override
  Size get preferredSize => const Size.fromHeight(AppControlSize.bottomBar);

  @override
  Widget build(BuildContext context) {
    final leading = this.leading;
    return SizedBox(
      height: preferredSize.height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
        child: Row(
          children: [
            if (leading != null) ...[
              leading,
              const SizedBox(width: AppSpacing.md),
            ],
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.title.copyWith(color: context.colors.ink),
              ),
            ),
            for (final action in actions) ...[
              const SizedBox(width: AppSpacing.sm),
              action,
            ],
          ],
        ),
      ),
    );
  }
}

class StacAppBarKitParser extends StacParser<KitModel> {
  const StacAppBarKitParser();

  @override
  String get type => 'appBar';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => KitAppBar(
    title: labelOf(model['title']),
    leading: childWidget(context, model['leading']),
    actions: childrenWidgets(context, model['actions']),
  );
}

class StacAlertDialogKitParser extends StacParser<KitModel> {
  const StacAlertDialogKitParser();

  @override
  String get type => 'alertDialog';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final actions = mapListOf(model, 'actions');
    final content = model['content'];
    final message = labelOf(content);
    final confirm = actions.isEmpty ? null : actions.last;
    final cancel = actions.length > 1 ? actions.first : null;
    return NinjaDialog(
      title: labelOf(model['title']),
      message: message.isEmpty ? null : message,
      icon: childWidget(context, model['icon']),
      confirmLabel: confirm == null ? null : labelOf(confirm['child']),
      onConfirm: confirm == null
          ? null
          : actionCallback(context, confirm['onPressed']) ??
                () => Navigator.of(context).maybePop(),
      cancelLabel: cancel == null ? null : labelOf(cancel['child']),
      onCancel: cancel == null
          ? null
          : actionCallback(context, cancel['onPressed']) ??
                () => Navigator.of(context).maybePop(),
      child: message.isEmpty ? childWidget(context, content) : null,
    );
  }
}

class StacCircularProgressKitParser extends StacParser<KitModel> {
  const StacCircularProgressKitParser();

  @override
  String get type => 'circularProgressIndicator';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => NinjaSpinner(
    strokeWidth: doubleOr(model, 'strokeWidth', 3),
    color: colorOf(context, model, 'color'),
    trackColor: colorOf(context, model, 'backgroundColor'),
  );
}

class StacLinearProgressKitParser extends StacParser<KitModel> {
  const StacLinearProgressKitParser();

  @override
  String get type => 'linearProgressIndicator';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final value = doubleOf(model, 'value');
    return NinjaProgressBar(
      value: (value ?? 0).clamp(0, 1),
      indeterminate: value == null,
      height: doubleOr(model, 'minHeight', 6),
      color: colorOf(context, model, 'color'),
      trackColor: colorOf(context, model, 'backgroundColor'),
    );
  }
}

class StacImageKitParser extends StacParser<KitModel> {
  const StacImageKitParser();

  @override
  String get type => 'image';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final imageType = stringOf(model, 'imageType', 'network');
    if (imageType != 'network') {
      return const StacImageParser().parse(
        context,
        StacImage.fromJson(model),
      );
    }
    return KitNetworkImage(
      src: stringOf(model, 'src'),
      width: doubleOf(model, 'width'),
      height: doubleOf(model, 'height'),
      fit: boxFitOf(stringOrNullOf(model, 'fit')),
      radius: 0,
      semanticLabel: stringOrNullOf(model, 'semanticLabel'),
    );
  }
}
