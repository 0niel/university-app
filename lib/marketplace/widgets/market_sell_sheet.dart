import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/marketplace/cubit/market_contact_prefs_cubit.dart';
import 'package:rtu_mirea_app/marketplace/cubit/marketplace_cubit.dart';
import 'package:rtu_mirea_app/marketplace/models/models.dart';
import 'package:rtu_mirea_app/marketplace/utils/utils.dart';
import 'package:rtu_mirea_app/marketplace/widgets/market_media_picker.dart';
import 'package:rtu_mirea_app/marketplace/widgets/marketplace_category_picker.dart';

class MarketSellSheet extends StatefulWidget {
  const MarketSellSheet({super.key, this.editing});

  final MarketListing? editing;

  @override
  State<MarketSellSheet> createState() => _MarketSellSheetState();
}

class _MarketSellSheetState extends State<MarketSellSheet> {
  final _title = TextEditingController();
  final _price = TextEditingController();
  final _description = TextEditingController();
  final _telegram = TextEditingController();
  final _picker = ImagePicker();
  final _media = <MarketMediaDraftItem>[];

  late String _category;
  var _isFree = false;
  var _showContact = false;
  var _showPriceError = false;
  var _showTelegramError = false;

  @override
  void initState() {
    super.initState();
    final editing = widget.editing;
    if (editing != null) {
      _title.text = editing.title;
      _price.text = editing.price == 0 ? '' : '${editing.price}';
      _description.text = editing.description;
      _telegram.text = editing.telegramHandle ?? '';
      _category = editing.category;
      _isFree = editing.isFree;
      _showContact = editing.showContact;
      _media.addAll(
        editing.media.map(MarketMediaDraftItem.uploaded),
      );
    } else {
      _category =
          UniversityConfig.current.marketplaceCategoryKeys.firstOrNull ??
          'other';
      final remembered = context.read<MarketContactPrefsCubit>().state;
      if (remembered.isNotEmpty) _telegram.text = remembered;
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _price.dispose();
    _description.dispose();
    _telegram.dispose();
    super.dispose();
  }

  bool get _isUploading => _media.any((item) => item.uploading);

  Future<void> _pickPhotos() async {
    final room =
        MarketplaceMediaIntake.maxImages -
        _media.where((item) => !item.isVideo).length;
    if (room <= 0) return _showMediaLimitError();
    List<XFile> files;
    try {
      files = await _picker.pickMultiImage(
        limit: room,
        maxWidth: 1600,
        imageQuality: 85,
      );
    } on Exception {
      if (mounted) _showMediaError(context.l10n.marketMediaTypeError);
      return;
    }
    if (!mounted) return;
    for (final file in files.take(room)) {
      unawaited(_addImage(file));
    }
  }

  Future<void> _pickVideo() async {
    if (_media.any((item) => item.isVideo)) return;
    XFile? file;
    try {
      file = await _picker.pickVideo(source: .gallery);
    } on Exception {
      if (mounted) _showMediaError(context.l10n.marketMediaTypeError);
      return;
    }
    if (!mounted || file == null) return;
    unawaited(_addVideo(file));
  }

  Future<void> _addImage(XFile file) async {
    final picked = await MarketplaceMediaIntake.readImage(file);
    if (picked == null) {
      if (mounted) _showMediaError(context.l10n.marketMediaTypeError);
      return;
    }
    final item = MarketMediaDraftItem.uploading(
      key: '${DateTime.now().microsecondsSinceEpoch}-${file.name}',
      bytes: picked.bytes,
      kind: picked.kind,
      width: picked.width,
      height: picked.height,
    );
    if (!mounted) return;
    setState(() => _media.add(item));
    await _upload(item, picked.bytes, picked.contentType, picked.extension);
  }

  Future<void> _addVideo(XFile file) async {
    final picked = await MarketplaceMediaIntake.readVideo(file);
    if (picked == null) {
      if (mounted) {
        _showMediaError(
          context.l10n.marketVideoTooLong,
        );
      }
      return;
    }
    final item = MarketMediaDraftItem.uploading(
      key: '${DateTime.now().microsecondsSinceEpoch}-${file.name}',
      bytes: picked.bytes,
      kind: picked.kind,
      width: picked.width,
      height: picked.height,
      duration: picked.duration,
    );
    if (!mounted) return;
    setState(() => _media.add(item));
    await _upload(item, picked.bytes, picked.contentType, picked.extension);
  }

  Future<void> _upload(
    MarketMediaDraftItem item,
    List<int> bytes,
    String contentType,
    String extension,
  ) async {
    try {
      final path = await context.read<MarketplaceCubit>().uploadMedia(
        bytes: bytes,
        contentType: contentType,
        extension: extension,
      );
      if (!mounted) return;
      setState(() {
        item
          ..uploading = false
          ..path = path;
      });
    } on Exception {
      if (!mounted) return;
      setState(() {
        item
          ..uploading = false
          ..failed = true;
      });
      _showMediaError(context.l10n.marketMediaTypeError);
    }
  }

  void _removeMedia(int index) {
    setState(() => _media.removeAt(index));
  }

  void _reorderMedia(int oldIndex, int newIndex) {
    setState(() {
      final item = _media.removeAt(oldIndex);
      _media.insert(newIndex, item);
    });
  }

  void _showMediaLimitError() => _showMediaError(
    context.l10n.marketMediaLimitError,
  );

  void _showMediaError(String message) {
    ToastManager.showError(context, message: message);
  }

  Future<void> _save() async {
    final price = _isFree ? 0 : int.tryParse(_price.text.trim());
    final invalidPrice =
        price == null ||
        price < 0 ||
        price > 100000000 ||
        (!_isFree && price == 0);
    final telegramValid = marketTelegramPattern.hasMatch(
      _telegram.text.trim().replaceFirst(RegExp('^@'), ''),
    );
    if (invalidPrice || !telegramValid) {
      setState(() {
        _showPriceError = invalidPrice;
        _showTelegramError = !telegramValid;
      });
      return;
    }
    final draft = MarketListingDraft(
      title: _title.text,
      price: price,
      category: _category,
      description: _description.text,
      showContact: _showContact,
      isFree: _isFree,
      telegramHandle: _telegram.text,
      media: [for (final item in _media) ?item.toMediaItem()],
    );
    final cubit = context.read<MarketplaceCubit>();
    final editingId = widget.editing?.id;
    final saved = editingId == null
        ? await cubit.create(draft)
        : await cubit.update(editingId, draft);
    if (!mounted) return;
    if (saved) {
      context.read<MarketContactPrefsCubit>().rememberHandle(_telegram.text);
      Navigator.of(context).pop();
      ToastManager.showSuccess(
        context,
        message: editingId == null
            ? context.l10n.marketCreateSuccess
            : context.l10n.marketUpdateSuccess,
      );
    } else {
      ToastManager.showError(context, message: context.l10n.marketCreateError);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final config = UniversityConfig.current;
    final isEditing = widget.editing != null;
    final saving = context.select<MarketplaceCubit, bool>(
      (cubit) => cubit.state.isSaving,
    );
    final busy = saving || _isUploading;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppInputField(
            controller: _title,
            autofocus: !isEditing,
            enabled: !saving,
            maxLength: 120,
            placeholder: l10n.marketTitleHint,
            leadingIcon: AppLineIcon.tag,
          ),
          const SizedBox(height: AppSpacing.gap),
          AppInputField.multiline(
            controller: _description,
            enabled: !saving,
            maxLength: 4000,
            placeholder: l10n.marketDescriptionHint,
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.sectionGap),
            child: MarketplaceCategoryPicker(
              keys: config.marketplaceCategoryKeys,
              selectedKey: _category,
              onChanged: saving
                  ? null
                  : (value) => setState(() {
                      _category = value;
                      _showPriceError = false;
                    }),
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppInputField(
                  controller: _price,
                  enabled: !saving && !_isFree,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  placeholder: l10n.marketPriceHintWithCurrency(
                    config.marketplaceCurrencyCode,
                  ),
                  leadingIcon: AppLineIcon.card,
                  errorText: _showPriceError ? l10n.marketPriceInvalid : null,
                  onChanged: (_) {
                    if (_showPriceError) {
                      setState(() => _showPriceError = false);
                    }
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: AppToggle(
                  value: _isFree,
                  label: l10n.marketFree,
                  onChanged: saving
                      ? null
                      : (value) => setState(() {
                          _isFree = value;
                          _showPriceError = false;
                        }),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          MarketMediaPicker(
            items: _media,
            onReorder: _reorderMedia,
            onRemove: saving ? (_) {} : _removeMedia,
            onAddPhoto: saving ? null : _pickPhotos,
            onAddVideo: saving ? null : _pickVideo,
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          AppInputField(
            controller: _telegram,
            enabled: !saving,
            label: l10n.marketTelegramLabel,
            placeholder: l10n.marketTelegramHint,
            leadingIcon: AppLineIcon.at,
            errorText: _showTelegramError
                ? (_telegram.text.trim().isEmpty
                      ? l10n.marketTelegramRequired
                      : l10n.marketTelegramInvalid)
                : null,
            onChanged: (_) {
              if (_showTelegramError) {
                setState(() => _showTelegramError = false);
              }
            },
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          AppCard(
            padding: EdgeInsets.zero,
            child: AppSettingsToggleRow(
              title: l10n.marketContactConsent,
              subtitle: l10n.marketContactConsentHint,
              value: _showContact,
              isFirst: true,
              isLast: true,
              onChanged: saving
                  ? null
                  : (value) => setState(() => _showContact = value),
            ),
          ),
          const SizedBox(height: AppSpacing.fieldGap),
          AppButton.primary(
            label: isEditing
                ? (busy ? l10n.marketSaving : l10n.marketSave)
                : (busy ? l10n.marketPublishing : l10n.marketPublish),
            icon: AppLineIconWidget(
              isEditing ? AppLineIcon.check : AppLineIcon.upload,
            ),
            size: .large,
            expanded: true,
            loading: busy,
            onPressed: busy ? null : () => unawaited(_save()),
          ),
        ],
      ),
    );
  }
}
