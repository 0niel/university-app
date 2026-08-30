import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/communities/communities.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class NinjaCommunitySectionFilters extends StatelessWidget {
  const NinjaCommunitySectionFilters({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityCatalogCubit, CommunityCatalogState>(
      buildWhen: (previous, current) =>
          previous.catalog != current.catalog ||
          previous.selectedSectionKey != current.selectedSectionKey,
      builder: (context, state) {
        final sections = state.catalog?.sections ?? const [];
        if (sections.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const .only(bottom: 12),
          child: NinjaChipRow(
            children: [
              NinjaChip(
                label: context.l10n.communitiesAll,
                selected: state.selectedSectionKey == null,
                onTap: () =>
                    context.read<CommunityCatalogCubit>().sectionSelected(null),
              ),
              for (final section in sections)
                NinjaChip(
                  label: section.title,
                  selected: state.selectedSectionKey == section.key,
                  onTap: () => context
                      .read<CommunityCatalogCubit>()
                      .sectionSelected(section.key),
                ),
            ],
          ),
        );
      },
    );
  }
}
