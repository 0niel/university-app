import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'contact.g.dart';

abstract class Contact implements Built<Contact, ContactBuilder> {
  factory Contact([void Function(ContactBuilder) updates]) = _$Contact;

  const Contact._();

  static Serializer<Contact> get serializer => _$contactSerializer;

  String? get name;
  String? get url;
  String? get email;

  String? formattedDescription() {
    final name = this.name;
    final url = this.url;
    final email = this.email;

    if (name == null || (url ?? email) == null) {
      return null;
    }

    final buffer = StringBuffer('You can contact the $name team under:');
    if (email != null) {
      buffer
        ..write('\n')
        ..write('  Email: `$email`');
    }
    if (url != null) {
      buffer
        ..write('\n')
        ..write('  Website: `$url`');
    }

    return buffer.toString();
  }
}
