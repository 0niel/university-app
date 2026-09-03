import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/main/bootstrap/supabase_initializer.dart';

void main() {
  test('SDK callbacks cannot bypass the guarded application handler', () {
    expect(SupabaseInitializer.authOptions.detectSessionInUri, isFalse);
  });
}
