import 'package:deep_link_client/deep_link_client.dart';
import 'package:rtu_mirea_app/scopes/core_scope.dart';
import 'package:supabase_authentication_client/supabase_authentication_client.dart';
import 'package:user_repository/user_repository.dart';
import 'package:yx_scope/yx_scope.dart';

/// Interface for Auth Scope
/// This scope contains authentication-related dependencies
abstract class AuthScope implements Scope {
  UserRepository get userRepository;
  User get currentUser;
}

/// Auth Scope Container
class AuthScopeContainer extends ScopeContainer implements AuthScope {
  AuthScopeContainer({
    required CoreScope coreScope,
    required User user,
  }) : _coreScope = coreScope,
       _user = user;

  final CoreScope _coreScope;
  final User _user;

  late final _deepLinkServiceDep = dep(
    () => DeepLinkService(deepLinkClient: DeepLinkClient()),
  );

  late final _userStorageDep = dep(
    () => UserStorage(storage: _coreScope.persistentStorage),
  );

  late final _authenticationClientDep = dep(
    () => SupabaseAuthenticationClient(
      tokenStorage: _coreScope.tokenStorage,
      supabaseAuth: _coreScope.supabaseClient.auth,
    ),
  );

  late final _userRepositoryDep = dep(
    () => UserRepository(
      authenticationClient: _authenticationClientDep.get,
      packageInfoClient: _coreScope.packageInfoClient,
      deepLinkService: _deepLinkServiceDep.get,
      storage: _userStorageDep.get,
    ),
  );

  @override
  UserRepository get userRepository => _userRepositoryDep.get;

  @override
  User get currentUser => _user;
}

/// Auth Scope Holder
class AuthScopeHolder extends ScopeHolder<AuthScopeContainer> {
  AuthScopeHolder({required CoreScope coreScope}) : _coreScope = coreScope;

  final CoreScope _coreScope;
  User _currentUser = User.anonymous;

  @override
  AuthScopeContainer createContainer() => AuthScopeContainer(
    coreScope: _coreScope,
    user: _currentUser,
  );

  /// Creates the auth scope with a specific user
  Future<void> createWithUser(User user) async {
    // Drop current scope if exists
    if (scope != null) {
      await drop();
    }
    
    _currentUser = user;
    await create();
  }

  /// Creates the auth scope with anonymous user
  Future<void> createWithAnonymousUser() async {
    await createWithUser(User.anonymous);
  }

  /// Gets the current user
  User? get currentUser => scope?.currentUser;
}
