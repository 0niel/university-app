import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:university_app_server_api/client.dart';

class LostFoundItemCard extends StatelessWidget {
  final LostFoundItem item;
  final VoidCallback onTap;

  const LostFoundItemCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final isLost = item.status == LostFoundItemStatus.lost;
    final hasImage = item.images != null && item.images!.isNotEmpty;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: appColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: appColors.cardShadowLight, blurRadius: 6, offset: const Offset(0, 2))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: appColors.primary.withOpacity(0.1),
          highlightColor: appColors.background03.withOpacity(0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasImage) _buildImageHeader(context, isLost),
              Padding(
                padding: EdgeInsets.fromLTRB(16, hasImage ? 12 : 16, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title row with status badge if no image
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title & Description
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.itemName,
                                style: AppTextStyle.titleS.copyWith(
                                  color: appColors.active,
                                  fontWeight: FontWeight.w600,
                                  height: 1.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (item.description != null && item.description!.isNotEmpty) ...[
                                const SizedBox(height: 6),
                                Text(
                                  item.description!,
                                  style: AppTextStyle.body.copyWith(color: appColors.deactive, height: 1.4),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),

                        if (!hasImage) ...[const SizedBox(width: 12), _buildStatusBadge(context, isLost)],
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Footer with date, contact info
                    Row(
                      children: [
                        // Date chip
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: appColors.background03.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.access_time_rounded, size: 14, color: appColors.deactive),
                              const SizedBox(width: 4),
                              Text(
                                _formatDate(item.createdAt),
                                style: AppTextStyle.captionL.copyWith(color: appColors.deactive),
                              ),
                            ],
                          ),
                        ),

                        const Spacer(),

                        // Contact info
                        if (item.telegramContactInfo != null && item.telegramContactInfo!.isNotEmpty)
                          _buildContactChip(context, item.telegramContactInfo!, Icons.telegram),
                        if (item.phoneNumberContactInfo != null && item.phoneNumberContactInfo!.isNotEmpty)
                          _buildContactChip(context, "Телефон", Icons.phone),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageHeader(BuildContext context, bool isLost) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return SizedBox(
      height: 180,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image with shimmer loading effect
          Image.network(
            item.images!.first,
            fit: BoxFit.cover,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded || frame != null) {
                return child;
              }
              return Shimmer.fromColors(
                baseColor: appColors.shimmerBase,
                highlightColor: appColors.shimmerHighlight,
                child: Container(color: appColors.background03),
              );
            },
            errorBuilder:
                (context, error, stackTrace) => Container(
                  color: appColors.background03,
                  child: Center(child: Icon(Icons.broken_image_rounded, color: appColors.deactive, size: 42)),
                ),
          ),

          // Gradient overlay for better visibility of badge & date
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.4)],
                  stops: const [0.7, 1.0],
                ),
              ),
            ),
          ),

          // Status badge (top-right)
          Positioned(top: 12, right: 12, child: _buildStatusBadge(context, isLost)),

          // Date badge (bottom-left)
          Positioned(
            bottom: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_rounded, size: 12, color: Colors.white),
                  const SizedBox(width: 5),
                  Text(
                    _formatDate(item.createdAt),
                    style: AppTextStyle.captionL.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, bool isLost) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final statusColor = isLost ? appColors.colorful06 : appColors.colorful05;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isLost ? Icons.search : Icons.check_circle_outline, color: Colors.white, size: 14),
          const SizedBox(width: 4),
          Text(
            isLost ? 'Потеряно' : 'Найдено',
            style: AppTextStyle.captionL.copyWith(color: Colors.white, fontWeight: FontWeight.w600, letterSpacing: 0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildContactChip(BuildContext context, String label, IconData icon) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(color: appColors.surfaceLow, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: icon == Icons.telegram ? appColors.colorful03 : appColors.colorful04),
          const SizedBox(width: 4),
          Text(
            icon == Icons.telegram ? label : "Телефон",
            style: AppTextStyle.captionL.copyWith(color: appColors.active, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inDays == 0) {
      return 'Сегодня';
    } else if (diff.inDays == 1) {
      return 'Вчера';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} ${_getDaysText(diff.inDays)} назад';
    } else {
      return DateFormat('d MMM', 'ru_RU').format(dateTime);
    }
  }

  String _getDaysText(int days) {
    if (days == 1) return 'день';
    if (days >= 2 && days <= 4) return 'дня';
    return 'дней';
  }
}
