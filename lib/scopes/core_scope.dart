import 'package:package_info_client/package_info_client.dart';
import 'package:persistent_storage/persistent_storage.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:token_storage/token_storage.dart';
import 'package:yx_scope/yx_scope.dart';

/// Interface for Core Scope
/// This scope contains the basic dependencies needed by other scopes
abstract class CoreScope implements Scope {
  PersistentStorage get persistentStorage;
  SecureStorage get secureStorage;
  SupabaseClient get supabaseClient;
  PackageInfoClient get packageInfoClient;
  TokenStorage get tokenStorage;
}

/// Core Scope Container
class CoreScopeContainer extends ScopeContainer implements CoreScope {
  CoreScopeContainer({
    required PersistentStorage persistentStorage,
    required SecureStorage secureStorage,
    required SupabaseClient supabaseClient,
    required PackageInfoClient packageInfoClient,
  }) : _persistentStorage = persistentStorage,
       _secureStorage = secureStorage,
       _supabaseClient = supabaseClient,
       _packageInfoClient = packageInfoClient;

  final PersistentStorage _persistentStorage;
  final SecureStorage _secureStorage;
  final SupabaseClient _supabaseClient;
  final PackageInfoClient _packageInfoClient;

  @override
  PersistentStorage get persistentStorage => _persistentStorage;

  @override
  SecureStorage get secureStorage => _secureStorage;

  @override
  SupabaseClient get supabaseClient => _supabaseClient;

  @override
  PackageInfoClient get packageInfoClient => _packageInfoClient;

  late final _tokenStorageDep = dep(() => InMemoryTokenStorage());

  @override
  TokenStorage get tokenStorage => _tokenStorageDep.get;
}

/// Core Scope Holder
class CoreScopeHolder extends ScopeHolder<CoreScopeContainer> {
  CoreScopeHolder({
    required PersistentStorage persistentStorage,
    required SecureStorage secureStorage,
    required SupabaseClient supabaseClient,
    required PackageInfoClient packageInfoClient,
  }) : _persistentStorage = persistentStorage,
       _secureStorage = secureStorage,
       _supabaseClient = supabaseClient,
       _packageInfoClient = packageInfoClient;

  final PersistentStorage _persistentStorage;
  final SecureStorage _secureStorage;
  final SupabaseClient _supabaseClient;
  final PackageInfoClient _packageInfoClient;

  @override
  CoreScopeContainer createContainer() => CoreScopeContainer(
    persistentStorage: _persistentStorage,
    secureStorage: _secureStorage,
    supabaseClient: _supabaseClient,
    packageInfoClient: _packageInfoClient,
  );
}
