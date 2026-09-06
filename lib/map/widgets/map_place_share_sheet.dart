import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rtu_mirea_app/navigation/deep_links.dart';
import 'package:share_plus/share_plus.dart';

class MapPlaceShareSheet extends StatefulWidget {
  const MapPlaceShareSheet({
    required this.campusId,
    required this.roomId,
    required this.title,
    super.key,
  });

  final String campusId;
  final String roomId;
  final String title;

  @override
  State<MapPlaceShareSheet> createState() => _MapPlaceShareSheetState();
}

class _MapPlaceShareSheetState extends State<MapPlaceShareSheet> {
  String? _notice;
  bool _failed = false;

  Uri get _link => mapPlaceShareLink(widget.campusId, widget.roomId);

  Future<void> _copy() async {
    try {
      await Clipboard.setData(ClipboardData(text: _link.toString()));
      if (mounted) {
        setState(() {
          _notice = 'Ссылка скопирована';
          _failed = false;
        });
      }
    } on Object {
      _showError();
    }
  }

  Future<void> _share(BuildContext buttonContext) async {
    final box = buttonContext.findRenderObject() as RenderBox?;
    try {
      await SharePlus.instance.share(
        ShareParams(
          text: '${widget.title}\n$_link',
          sharePositionOrigin: box == null
              ? null
              : box.localToGlobal(Offset.zero) & box.size,
        ),
      );
    } on Object {
      _showError();
    }
  }

  void _showError() {
    if (!mounted) return;
    setState(() {
      _notice = 'Не удалось поделиться. Скопируйте ссылку ниже.';
      _failed = true;
    });
  }

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 264),
          child: AppCard(
            color: context.colors.white,
            child: LayoutBuilder(
              builder: (context, constraints) => Semantics(
                label: 'QR-код места ${widget.title}',
                image: true,
                child: QrImageView(
                  data: _link.toString(),
                  size: constraints.maxWidth,
                ),
              ),
            ),
          ),
        ),
      ),
      const SizedBox(height: AppSpacing.lg),
      const Text(
        'Сканируйте код, чтобы открыть это место на карте.',
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: AppSpacing.lg),
      Builder(
        builder: (context) => AppButton.primary(
          label: 'Поделиться',
          expanded: true,
          onPressed: () => _share(context),
        ),
      ),
      const SizedBox(height: AppSpacing.sm),
      AppButton.secondary(
        label: 'Копировать',
        expanded: true,
        onPressed: _copy,
      ),
      const SizedBox(height: AppSpacing.lg),
      SelectableText(_link.toString(), style: AppText.subtext),
      if (_notice != null) ...[
        const SizedBox(height: AppSpacing.lg),
        AppBanner(
          message: _notice!,
          tone: _failed ? AppBannerTone.warn : AppBannerTone.success,
        ),
      ],
    ],
  );
}

Uri mapPlaceShareLink(String campusId, String roomId) => DeepLinks.shareLink(
  Uri(
    path: '/services/map',
    queryParameters: {'campus': campusId, 'room': roomId},
  ).toString(),
);
