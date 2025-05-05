import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lost_and_found_repository/lost_and_found_repository.dart';
import 'package:rtu_mirea_app/app/app.dart';
import 'package:rtu_mirea_app/lost_and_found/lost_and_found.dart';
import 'package:rtu_mirea_app/lost_and_found/widgets/widgets.dart';
import 'package:share_plus/share_plus.dart';
import 'package:university_app_server_api/client.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class LostFoundDetailPage extends StatelessWidget {
  final LostFoundItem item;

  const LostFoundDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final isCurrentUserAuthor = context.select<AppBloc, bool>((bloc) => bloc.state.user.id == item.authorId);
    final hasImages = item.images != null && item.images!.isNotEmpty;

    return Scaffold(
      backgroundColor: appColors.background01,
      extendBodyBehindAppBar: hasImages,
      appBar: AppBar(
        backgroundColor: hasImages ? Colors.transparent : appColors.surface,
        elevation: 0,
        systemOverlayStyle: hasImages ? SystemUiOverlayStyle.light : null,
        iconTheme: IconThemeData(color: hasImages ? Colors.white : appColors.active),
        actions: [
          if (isCurrentUserAuthor)
            IconButton(
              icon: Icon(Icons.edit, color: hasImages ? Colors.white : appColors.active),
              tooltip: 'Редактировать',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CreateLostFoundItemPage(item: item)),
                ).then((_) => context.read<LostFoundBloc>().add(LoadLostFoundItems()));
              },
            ),
          IconButton(
            icon: Icon(Icons.share_rounded, color: hasImages ? Colors.white : appColors.active),
            tooltip: 'Поделиться',
            onPressed: () => _shareItem(context),
          ),
        ],
      ),
      body: _DetailPageContent(item: item, isAuthor: isCurrentUserAuthor),
      floatingActionButton:
          isCurrentUserAuthor
              ? null
              : FloatingActionButton.extended(
                onPressed: () => _contactOwner(context),
                backgroundColor: appColors.primary,
                foregroundColor: Colors.white,
                icon: const Icon(Icons.contact_phone),
                label: const Text('Связаться'),
              ),
    );
  }

  void _shareItem(BuildContext context) {
    final status = item.status == LostFoundItemStatus.lost ? 'Потеряно' : 'Найдено';
    final message =
        '$status: ${item.itemName}\n\n'
        '${item.description ?? ""}\n\n'
        'Контакты: ${item.telegramContactInfo ?? item.phoneNumberContactInfo ?? item.authorEmail}';
    Share.share(message);
  }

  void _contactOwner(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    showModalBottomSheet(
      context: context,
      backgroundColor: appColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Связаться с автором',
                  style: AppTextStyle.titleM.copyWith(fontWeight: FontWeight.w600, color: appColors.active),
                ),
                const SizedBox(height: 24),
                if (item.telegramContactInfo != null && item.telegramContactInfo!.isNotEmpty)
                  _buildContactButton(
                    context,
                    icon: Icons.telegram,
                    label: 'Telegram: ${item.telegramContactInfo}',
                    color: appColors.colorful03,
                    onTap: () => _launchUrl('https://t.me/${item.telegramContactInfo!.replaceAll('@', '')}'),
                  ),
                if (item.phoneNumberContactInfo != null && item.phoneNumberContactInfo!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _buildContactButton(
                    context,
                    icon: Icons.phone,
                    label: 'Телефон: ${item.phoneNumberContactInfo}',
                    color: appColors.colorful04,
                    onTap: () => _launchUrl('tel:${item.phoneNumberContactInfo!}'),
                  ),
                ],
                const SizedBox(height: 12),
                _buildContactButton(
                  context,
                  icon: Icons.email,
                  label: 'Email: ${item.authorEmail}',
                  color: appColors.colorful07,
                  onTap: () => _launchUrl('mailto:${item.authorEmail}'),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
    );
  }

  Widget _buildContactButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        width: double.infinity,
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: AppTextStyle.body.copyWith(color: appColors.active, fontWeight: FontWeight.w500),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _DetailPageContent extends StatelessWidget {
  final LostFoundItem item;
  final bool isAuthor;

  const _DetailPageContent({required this.item, required this.isAuthor});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final hasImages = item.images != null && item.images!.isNotEmpty;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Image gallery or placeholder
        if (hasImages)
          SliverAppBar(
            expandedHeight: 300,
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(background: ImageGallery(images: item.images!)),
            automaticallyImplyLeading: false,
          )
        else
          SliverToBoxAdapter(child: SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight)),

        // Content
        SliverToBoxAdapter(
          child: Container(
            decoration: BoxDecoration(
              color: appColors.surface,
              borderRadius: hasImages ? const BorderRadius.vertical(top: Radius.circular(24)) : null,
            ),
            margin: hasImages ? const EdgeInsets.only(top: -20) : EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header section with status and title
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [_buildStatusRow(context), const SizedBox(height: 16), _buildTitleSection(context)],
                  ),
                ),

                // Description section
                if (item.description != null && item.description!.isNotEmpty)
                  Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 24), child: _buildDescriptionSection(context)),

                // Contact information section
                Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 24), child: _buildContactInfoSection(context)),

                // Management section for authors
                if (isAuthor)
                  Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 32), child: _buildManagementSection(context)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusRow(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final isLost = item.status == LostFoundItemStatus.lost;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Status indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isLost ? appColors.colorful06 : appColors.colorful05,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(isLost ? Icons.search : Icons.check_circle, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text(isLost ? 'Потеряно' : 'Найдено', style: AppTextStyle.bodyBold.copyWith(color: Colors.white)),
            ],
          ),
        ),

        // Date indicator
        Row(
          children: [
            Icon(Icons.access_time, size: 14, color: appColors.deactive),
            const SizedBox(width: 6),
            Text(_formatDate(item.createdAt), style: AppTextStyle.captionL.copyWith(color: appColors.deactive)),
          ],
        ),
      ],
    );
  }

  Widget _buildTitleSection(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(item.itemName, style: AppTextStyle.h5.copyWith(color: appColors.active, fontWeight: FontWeight.bold)),
        if (item.authorEmail.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.person, size: 16, color: appColors.deactive),
              const SizedBox(width: 6),
              Text('Автор: ${item.authorEmail}', style: AppTextStyle.body.copyWith(color: appColors.deactive)),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildDescriptionSection(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: appColors.surfaceHigh, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.description, size: 18, color: appColors.primary),
              const SizedBox(width: 8),
              Text(
                'Описание',
                style: AppTextStyle.titleS.copyWith(fontWeight: FontWeight.w600, color: appColors.active),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(item.description!, style: AppTextStyle.bodyL.copyWith(color: appColors.active, height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildContactInfoSection(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: appColors.surfaceLow,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: appColors.cardShadowLight, blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: appColors.primary.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(Icons.contact_mail, color: appColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Контактная информация',
                style: AppTextStyle.titleM.copyWith(fontWeight: FontWeight.w600, color: appColors.active),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Telegram contact
          if (item.telegramContactInfo != null && item.telegramContactInfo!.isNotEmpty)
            _buildContactItem(context, 'Telegram', item.telegramContactInfo!, Icons.telegram, appColors.colorful03),

          // Phone number contact
          if (item.phoneNumberContactInfo != null && item.phoneNumberContactInfo!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildContactItem(context, 'Телефон', item.phoneNumberContactInfo!, Icons.phone, appColors.colorful04),
          ],

          // Email contact
          const SizedBox(height: 12),
          _buildContactItem(context, 'Email', item.authorEmail, Icons.email, appColors.colorful07),
        ],
      ),
    );
  }

  Widget _buildContactItem(BuildContext context, String title, String value, IconData icon, Color color) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: appColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: appColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyle.captionL.copyWith(color: appColors.deactive)),
                Text(value, style: AppTextStyle.bodyL.copyWith(color: appColors.active, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.content_copy, size: 20),
            color: appColors.deactive,
            onPressed: () {
              Clipboard.setData(ClipboardData(text: value));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$title скопирован в буфер обмена'),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            tooltip: 'Копировать',
          ),
        ],
      ),
    );
  }

  Widget _buildManagementSection(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final isLost = item.status == LostFoundItemStatus.lost;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Text(
            'Управление объявлением',
            style: AppTextStyle.titleS.copyWith(fontWeight: FontWeight.w600, color: appColors.active),
          ),
        ),
        const SizedBox(height: 8),

        // Change status button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _changeItemStatus(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: isLost ? appColors.colorful05 : appColors.colorful06,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            icon: Icon(isLost ? Icons.check_circle : Icons.search),
            label: Text(isLost ? 'Отметить как найденное' : 'Отметить как потерянное', style: AppTextStyle.bodyBold),
          ),
        ),
        const SizedBox(height: 12),

        // Delete button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _showDeleteConfirmation(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: appColors.colorful07,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            icon: const Icon(Icons.delete_outline),
            label: Text('Удалить объявление', style: AppTextStyle.bodyBold),
          ),
        ),
      ],
    );
  }

  void _changeItemStatus(BuildContext context) {
    final bloc = context.read<LostFoundBloc>();
    final isLost = item.status == LostFoundItemStatus.lost;
    final newStatus = isLost ? LostFoundItemStatus.found : LostFoundItemStatus.lost;

    // Use the UpdateLostFoundItemStatus event with correct parameters
    bloc.add(UpdateLostFoundItemStatus(item: item, newStatus: newStatus));

    Navigator.pop(context);
  }

  void _showDeleteConfirmation(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final bloc = context.read<LostFoundBloc>();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Удаление объявления',
              style: AppTextStyle.titleM.copyWith(color: appColors.active, fontWeight: FontWeight.w600),
            ),
            content: Text(
              'Вы действительно хотите удалить объявление "${item.itemName}"? Это действие нельзя будет отменить.',
              style: AppTextStyle.body.copyWith(color: appColors.deactive),
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Отмена', style: TextStyle(color: appColors.deactive)),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  bloc.add(DeleteLostFoundItem(item));
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Return to list page
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: appColors.colorful07,
                  foregroundColor: Colors.white,
                  elevation: 0,
                ),
                icon: const Icon(Icons.delete, size: 18),
                label: const Text('Удалить'),
              ),
            ],
          ),
    );
  }

  String _formatDate(DateTime date) {
    final formatter = DateFormat('d MMMM yyyy г.', 'ru_RU');
    return formatter.format(date);
  }
}
