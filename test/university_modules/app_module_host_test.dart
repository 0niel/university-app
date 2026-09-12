import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/university_modules/app_module_host.dart';
import 'package:rtu_mirea_app/university_modules/module_scoped_storage.dart';
import 'package:storage/storage.dart';

class _Storage extends Mock implements Storage {}

void main() {
  test('device pass removal remains scoped to the active account', () async {
    var active = true;
    var removals = 0;
    final host = AppModuleHost(
      organizationId: 'university-a',
      accountId: 'student-a',
      digitalPassAvailable: true,
      storage: ModuleScopedStorage(
        storage: _Storage(),
        organizationId: 'university-a',
        accountId: 'student-a',
        moduleId: 'campus-services',
        isAccountActive: () => active,
      ),
      clearDigitalPassBinding: () async => removals++,
    );
    await host.clearDigitalPassBinding();
    expect(removals, 1);
    active = false;
    await expectLater(
      host.clearDigitalPassBinding(),
      throwsA(isA<ModuleAccountChangedException>()),
    );
    expect(removals, 1);
  });

  test('unsupported devices do not silently confirm pass removal', () async {
    final host = AppModuleHost(
      organizationId: 'university-a',
      accountId: 'student-a',
      digitalPassAvailable: false,
      storage: ModuleScopedStorage(
        storage: _Storage(),
        organizationId: 'university-a',
        accountId: 'student-a',
        moduleId: 'campus-services',
        isAccountActive: () => true,
      ),
      clearDigitalPassBinding: () async => fail('Unsupported device'),
    );
    await expectLater(
      host.clearDigitalPassBinding(),
      throwsUnsupportedError,
    );
  });

  test('only exposes the digital-pass bridge on supported devices', () {
    final host = AppModuleHost(
      organizationId: 'university-a',
      accountId: 'student-a',
      digitalPassAvailable: false,
      storage: ModuleScopedStorage(
        storage: _Storage(),
        organizationId: 'university-a',
        accountId: 'student-a',
        moduleId: 'campus-services',
        isAccountActive: () => true,
      ),
      setDigitalPassSession: (_) async => fail('Bridge should be unavailable'),
      clearDigitalPassSession: () async => fail('Bridge should be unavailable'),
    );

    expect(host.setDigitalPassSession, isNull);
    expect(host.clearDigitalPassSession, isNull);
    expect(host.institutionLogin, isNull);
  });

  test('institution login runs only for the active account', () async {
    var active = true;
    var logins = 0;
    final host = AppModuleHost(
      organizationId: 'university-a',
      accountId: 'student-a',
      digitalPassAvailable: false,
      storage: ModuleScopedStorage(
        storage: _Storage(),
        organizationId: 'university-a',
        accountId: 'student-a',
        moduleId: 'campus-services',
        isAccountActive: () => active,
      ),
      institutionLogin: () async {
        logins++;
        return '.AspNetCore.Cookies=session';
      },
    );
    final login = host.institutionLogin!;
    expect(await login(), '.AspNetCore.Cookies=session');
    active = false;
    await expectLater(login(), throwsA(isA<ModuleAccountChangedException>()));
    expect(logins, 1);
  });

  test(
    'does not import a session after the module account is closed',
    () async {
      var active = true;
      final acceptedCookies = <String>[];
      final host = AppModuleHost(
        organizationId: 'university-a',
        accountId: 'student-a',
        digitalPassAvailable: true,
        storage: ModuleScopedStorage(
          storage: _Storage(),
          organizationId: 'university-a',
          accountId: 'student-a',
          moduleId: 'campus-services',
          isAccountActive: () => active,
        ),
        setDigitalPassSession: (cookie) async => acceptedCookies.add(cookie),
      );

      final bridge = host.setDigitalPassSession!;
      await bridge('first-session');
      active = false;
      await expectLater(
        bridge('second-session'),
        throwsA(isA<ModuleAccountChangedException>()),
      );
      expect(acceptedCookies, ['first-session']);
    },
  );

  test('an old module cannot clear the current digital-pass session', () async {
    var active = true;
    var clears = 0;
    final host = AppModuleHost(
      organizationId: 'university-a',
      accountId: 'student-a',
      digitalPassAvailable: true,
      storage: ModuleScopedStorage(
        storage: _Storage(),
        organizationId: 'university-a',
        accountId: 'student-a',
        moduleId: 'campus-services',
        isAccountActive: () => active,
      ),
      clearDigitalPassSession: () async => clears++,
    );

    final clear = host.clearDigitalPassSession!;
    await clear();
    expect(clears, 1);
    active = false;
    await expectLater(clear(), throwsA(isA<ModuleAccountChangedException>()));
    expect(clears, 1);
  });
}
