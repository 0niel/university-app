import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meta/meta.dart';
import 'package:neon_framework/l10n/localizations.dart';
import 'package:neon_framework/src/bloc/result.dart';
import 'package:neon_framework/src/blocs/accounts.dart';
import 'package:neon_framework/src/blocs/unified_search.dart';
import 'package:neon_framework/src/models/account.dart';
import 'package:neon_framework/src/theme/sizes.dart';
import 'package:neon_framework/src/utils/provider.dart';
import 'package:neon_framework/src/widgets/adaptive_widgets/list_tile.dart';
import 'package:neon_framework/src/widgets/error.dart';
import 'package:neon_framework/src/widgets/image.dart';
import 'package:neon_framework/src/widgets/linear_progress_indicator.dart';
import 'package:neon_framework/src/widgets/list_view.dart';
import 'package:neon_framework/src/widgets/server_icon.dart';
import 'package:nextcloud/core.dart' as core;

@internal
class NeonUnifiedSearchResults extends StatelessWidget {
  const NeonUnifiedSearchResults({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final accountsBloc = NeonProvider.of<AccountsBloc>(context);
    final bloc = accountsBloc.activeUnifiedSearchBloc;
    return ResultBuilder.behaviorSubject(
      subject: bloc.results,
      builder: (context, results) {
        final values = results.data?.entries.toList();

        return NeonListView(
          scrollKey: 'unified-search',
          isLoading: results.isLoading,
          error: results.error,
          onRefresh: bloc.refresh,
          itemCount: values?.length ?? 0,
          itemBuilder: (context, index) {
            final snapshot = values![index];

            return AnimatedSize(
              duration: const Duration(milliseconds: 100),
              child: _buildProvider(
                context,
                accountsBloc,
                bloc,
                snapshot.key,
                snapshot.value,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProvider(
    BuildContext context,
    AccountsBloc accountsBloc,
    UnifiedSearchBloc bloc,
    core.UnifiedSearchProvider provider,
    Result<core.UnifiedSearchResult> result,
  ) {
    final entries = result.data?.entries ?? <core.UnifiedSearchResultEntry>[];
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              provider.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            NeonError(
              result.error,
              onRetry: bloc.refresh,
            ),
            NeonLinearProgressIndicator(
              visible: result.isLoading,
            ),
            if (entries.isEmpty) ...[
              AdaptiveListTile(
                leading: const Icon(
                  Icons.close,
                  size: largeIconSize,
                ),
                title: Text(NeonLocalizations.of(context).searchNoResults),
              ),
            ],
            for (final entry in entries) ...[
              AdaptiveListTile(
                leading: NeonImageWrapper(
                  size: const Size.square(largeIconSize),
                  child: _buildThumbnail(context, accountsBloc.activeAccount.value!, entry),
                ),
                title: Text(entry.title),
                subtitle: Text(entry.subline),
                onTap: () async {
                  context.go(entry.resourceUrl);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context, Account account, core.UnifiedSearchResultEntry entry) {
    if (entry.thumbnailUrl.isNotEmpty) {
      return NeonUrlImage.withAccount(
        size: const Size.square(largeIconSize),
        uri: Uri.parse(entry.thumbnailUrl),
        account: account,
        // The thumbnail URL might be set but a 404 is returned because there is no preview available
        errorBuilder: (context, _) => _buildFallbackIcon(context, account, entry),
      );
    }

    return _buildFallbackIcon(context, account, entry) ?? const SizedBox.shrink();
  }

  Widget? _buildFallbackIcon(
    BuildContext context,
    Account account,
    core.UnifiedSearchResultEntry entry,
  ) {
    if (entry.icon.startsWith('/')) {
      return NeonUrlImage.withAccount(
        size: Size.square(IconTheme.of(context).size!),
        uri: Uri.parse(entry.icon),
        account: account,
      );
    }

    if (entry.icon.startsWith('icon-')) {
      return NeonServerIcon(
        colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.primary, BlendMode.srcIn),
        icon: entry.icon,
      );
    }

    return null;
  }
}
