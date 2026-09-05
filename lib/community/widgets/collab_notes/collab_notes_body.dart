import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/community/cubit/collab_notes/collab_notes.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/collab_note_card.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/collab_notes_failure.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/collab_notes_skeleton.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/note_actions_sheet.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class CollabNotesBody extends StatefulWidget {
  const CollabNotesBody({super.key, this.onOpen, this.onCreate, this.header});

  final ValueChanged<CollabNote>? onOpen;
  final VoidCallback? onCreate;
  final Widget? header;

  @override
  State<CollabNotesBody> createState() => _CollabNotesBodyState();
}

class _CollabNotesBodyState extends State<CollabNotesBody> {
  String _filter = 'all';
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CollabNotesCubit>().state;
    final l10n = context.l10n;
    return RefreshIndicator(
      color: context.colors.ink,
      onRefresh: context.read<CollabNotesCubit>().load,
      child: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                if (widget.header != null) widget.header!,
                const SizedBox(height: AppSpacing.screen),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screen,
                  ),
                  child: AppSearchField(
                    controller: _searchController,
                    hintText: l10n.collabNotesSearchHint,
                    onChanged: (value) => setState(() => _query = value.trim()),
                    onClear: () => setState(() => _query = ''),
                  ),
                ),
                const SizedBox(height: AppSpacing.sectionGap),
                AppChipRow<String>(
                  value: _filter,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screen,
                  ),
                  items: [
                    AppChipRowItem(
                      value: 'all',
                      label: l10n.collabNotesFilterAll,
                    ),
                    AppChipRowItem(
                      value: 'new',
                      label: l10n.collabNotesFilterNew,
                    ),
                    AppChipRowItem(
                      value: 'mine',
                      label: l10n.collabNotesFilterMine,
                    ),
                    AppChipRowItem(
                      value: 'group',
                      label: l10n.collabNotesFilterGroup,
                    ),
                    AppChipRowItem(
                      value: 'personal',
                      label: l10n.collabNotesFilterPersonal,
                    ),
                  ],
                  onChanged: (value) => setState(() => _filter = value),
                ),
                const SizedBox(height: AppSpacing.sectionGap),
              ],
            ),
          ),
          _content(context, state),
        ],
      ),
    );
  }

  Widget _content(BuildContext context, CollabNotesState state) {
    if (state.status == .loading && state.notes.isEmpty) {
      return const SliverToBoxAdapter(
        child: CollabNotesSkeleton(key: ValueKey('notes-loading')),
      );
    }
    if (state.status == .failure && state.notes.isEmpty) {
      return SliverToBoxAdapter(
        child: CollabNotesFailure(
          key: const ValueKey('notes-failure'),
          onRetry: context.read<CollabNotesCubit>().load,
        ),
      );
    }
    final cutoff = DateTime.now().subtract(const Duration(days: 7));
    final query = _query.toLowerCase();
    final notes = state.notes
        .where(
          (note) => switch (_filter) {
            'mine' => note.isMine,
            'group' => !note.isPersonal,
            'personal' => note.isPersonal,
            'new' => note.createdAt?.isAfter(cutoff) ?? false,
            _ => true,
          },
        )
        .where(
          (note) =>
              query.isEmpty ||
              note.title.toLowerCase().contains(query) ||
              note.content.toLowerCase().contains(query),
        )
        .toList(growable: false);
    if (notes.isEmpty) {
      return SliverList.list(
        key: const ValueKey('notes-empty'),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              AppSpacing.xxxlg,
              AppSpacing.screen,
              AppSpacing.zero,
            ),
            child: AppEmptyState(
              lineIcon: AppLineIcon.pencil,
              title: context.l10n.collabNotesEmptyTitle,
              subtitle: context.l10n.collabNotesEmptySubtitle,
              actionLabel: context.l10n.collabNotesCreateTitle,
              onAction: widget.onCreate,
            ),
          ),
        ],
      );
    }
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.zero,
        AppSpacing.screen,
        ninjaBottomInset(context) + AppSpacing.lg,
      ),
      sliver: SliverList.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: AppListGroup(
              children: [
                CollabNoteCard(
                  key: ValueKey(note.id),
                  note: note,
                  onTap: () => widget.onOpen?.call(note),
                  onLongPress: () => unawaited(
                    showNoteActionsSheet(context, note),
                  ),
                ),
              ],
            ),
          ).animateListItem(key: ValueKey(note.id), index: index);
        },
      ),
    );
  }
}
