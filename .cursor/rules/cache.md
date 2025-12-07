# Cache Application State
- Use `hydrated_bloc` **only for UI/presentation state**. Business/domain persistence should go through repositories/storage (API + secure/shared storage), not through bloc caches.
- Enabled by default via `HydratedBloc.storage` (CustomHydratedStorage) from bootstrap initializers.
- Current hydrated blocs: `FeedBloc` (feed articles list), `ArticleBloc` (article details), `CategoriesBloc` (feed categories), `ThemeModeBloc` (user-selected theme mode).
- Behavior: on launch, cached state is used if present; otherwise data is fetched from API. Pull-to-refresh ensures freshest feed. Errors while fetching surface a network error screen with retry.
- Debug mode: caching is cleared on each restart (`if (kDebugMode) { await HydratedBloc.storage.clear(); }` in bootstrap). Remove that snippet to keep cache in debug.
- When adding new hydrated blocs: keep state small/serializable (`toJson`/`fromJson`), no side effects inside hydration, and only cache data that is safe to show stale until refreshed.
