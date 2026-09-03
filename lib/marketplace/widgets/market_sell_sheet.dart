import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/marketplace/cubit/marketplace_cubit.dart';
import 'package:rtu_mirea_app/marketplace/models/models.dart';
import 'package:rtu_mirea_app/marketplace/widgets/marketplace_category_picker.dart';

class MarketSellSheet extends StatefulWidget {
  const MarketSellSheet({super.key});

  @override
  State<MarketSellSheet> createState() => _MarketSellSheetState();
}

class _MarketSellSheetState extends State<MarketSellSheet> {
  final _title = TextEditingController();
  final _price = TextEditingController();
  final _description = TextEditingController();
  late String _category =
      UniversityConfig.current.marketplaceCategoryKeys.firstOrNull ?? 'other';
  var _showContact = false;
  var _showPriceError = false;

  @override
  void dispose() {
    _title.dispose();
    _price.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final price = _category == 'free' ? 0 : int.tryParse(_price.text.trim());
    final invalidPrice =
        price == null ||
        price < 0 ||
        price > 100000000 ||
        (_category != 'free' && price == 0);
    if (invalidPrice) {
      setState(() => _showPriceError = true);
      return;
    }
    final draft = MarketListingDraft(
      title: _title.text,
      price: price,
      category: _category,
      description: _description.text,
      showContact: _showContact,
    );
    final created = await context.read<MarketplaceCubit>().create(draft);
    if (!mounted) return;
    if (created) {
      Navigator.of(context).pop();
    } else {
      NinjaToastHost.maybeOf(context)?.show(
        NinjaToastData(
          message: context.l10n.marketCreateError,
          showCheck: false,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final config = UniversityConfig.current;
    final saving = context.select<MarketplaceCubit, bool>(
      (cubit) => cubit.state.isCreating,
    );
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NinjaInput(
            controller: _title,
            autofocus: true,
            enabled: !saving,
            maxLength: 120,
            placeholder: l10n.marketTitleHint,
            leadingIcon: const AppLineIconWidget(AppLineIcon.tag),
          ),
          if (_category != 'free') ...[
            const SizedBox(height: AppSpacing.gap),
            NinjaInput(
              controller: _price,
              enabled: !saving,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              placeholder: l10n.marketPriceHintWithCurrency(
                config.marketplaceCurrencyCode,
              ),
              leadingIcon: const AppLineIconWidget(AppLineIcon.card),
              errorText: _showPriceError ? l10n.marketPriceInvalid : null,
              onChanged: (_) {
                if (_showPriceError) {
                  setState(() => _showPriceError = false);
                }
              },
            ),
          ],
          const SizedBox(height: AppSpacing.gap),
          NinjaInput.multiline(
            controller: _description,
            enabled: !saving,
            maxLength: 4000,
            placeholder: l10n.marketDescriptionHint,
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(AppRadius.card),
            ),
            child: Padding(
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
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(AppRadius.card),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.marketContactConsent,
                          style: AppText.headline.copyWith(color: colors.ink),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          l10n.marketContactConsentHint,
                          style: AppText.subtext.copyWith(
                            color: colors.muted,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  NinjaSwitch(
                    value: _showContact,
                    onChanged: saving
                        ? null
                        : (value) => setState(() => _showContact = value),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.fieldGap),
          NinjaButton.primary(
            label: saving ? l10n.marketPublishing : l10n.marketPublish,
            icon: const AppLineIconWidget(AppLineIcon.upload),
            size: NinjaButtonSize.large,
            expanded: true,
            loading: saving,
            onPressed: saving ? null : () => unawaited(_save()),
          ),
        ],
      ),
    );
  }
}
