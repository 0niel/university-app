import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

Color promoAccentColor(String hex, Color fallback) {
  final value = int.tryParse(hex.replaceFirst('#', ''), radix: 16);
  if (value == null || hex.length != 7) return fallback;
  return Color(0xFF000000 | value);
}

Uri? promoTelegramUri(String? handle) {
  final normalized = handle?.trim().replaceFirst(RegExp('^@'), '');
  if (normalized == null || normalized.isEmpty) return null;
  return Uri.https('t.me', '/$normalized');
}

Future<void> openPromoLink(BuildContext context, String url) async {
  final uri = Uri.tryParse(url);
  var launched = false;
  if (uri != null) {
    try {
      launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } on Exception {
      launched = false;
    }
  }
  if (!launched && context.mounted) {
    ToastManager.showError(context, message: context.l10n.promoOpenLinkError);
  }
}
