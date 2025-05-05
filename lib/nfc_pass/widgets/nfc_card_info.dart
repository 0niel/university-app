import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:app_ui/app_ui.dart';

class NfcCardInfo extends StatelessWidget {
  final String? deviceId;

  const NfcCardInfo({super.key, required this.deviceId});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    if (deviceId == null) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(color: colors.background02, borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: colors.active, size: 22),
              const SizedBox(width: 12),
              Text('Информация о пропуске', style: AppTextStyle.bodyL.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 16),

          _InfoRow(icon: Icons.credit_card_outlined, label: 'ID пропуска', value: _getObfuscatedId(deviceId!)),

          const SizedBox(height: 12),

          _InfoRow(icon: Icons.security_outlined, label: 'Статус', value: 'Активен', valueColor: colors.colorful02),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  String _getObfuscatedId(String id) {
    if (id.length <= 6) return id;

    final firstPart = id.substring(0, 3);
    final lastPart = id.substring(id.length - 3);
    return '$firstPart•••$lastPart';
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({required this.icon, required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Row(
      children: [
        Container(
          height: 36,
          width: 36,
          decoration: BoxDecoration(color: colors.background03, borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 18, color: colors.deactive),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyle.captionL.copyWith(color: colors.deactive)),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTextStyle.body.copyWith(fontWeight: FontWeight.w600, color: valueColor ?? colors.active),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
