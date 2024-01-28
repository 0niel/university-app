// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notes.openapi.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const Settings_NoteMode _$settingsNoteModeEdit = Settings_NoteMode._('edit');
const Settings_NoteMode _$settingsNoteModePreview = Settings_NoteMode._('preview');
const Settings_NoteMode _$settingsNoteModeRich = Settings_NoteMode._('rich');

Settings_NoteMode _$valueOfSettings_NoteMode(String name) {
  switch (name) {
    case 'edit':
      return _$settingsNoteModeEdit;
    case 'preview':
      return _$settingsNoteModePreview;
    case 'rich':
      return _$settingsNoteModeRich;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<Settings_NoteMode> _$settingsNoteModeValues = BuiltSet<Settings_NoteMode>(const <Settings_NoteMode>[
  _$settingsNoteModeEdit,
  _$settingsNoteModePreview,
  _$settingsNoteModeRich,
]);

Serializer<Note> _$noteSerializer = _$NoteSerializer();
Serializer<Settings> _$settingsSerializer = _$SettingsSerializer();
Serializer<Capabilities_Notes> _$capabilitiesNotesSerializer = _$Capabilities_NotesSerializer();
Serializer<Capabilities> _$capabilitiesSerializer = _$CapabilitiesSerializer();
Serializer<OCSMeta> _$oCSMetaSerializer = _$OCSMetaSerializer();
Serializer<EmptyOCS_Ocs> _$emptyOCSOcsSerializer = _$EmptyOCS_OcsSerializer();
Serializer<EmptyOCS> _$emptyOCSSerializer = _$EmptyOCSSerializer();

class _$NoteSerializer implements StructuredSerializer<Note> {
  @override
  final Iterable<Type> types = const [Note, _$Note];
  @override
  final String wireName = 'Note';

  @override
  Iterable<Object?> serialize(Serializers serializers, Note object, {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'etag',
      serializers.serialize(object.etag, specifiedType: const FullType(String)),
      'readonly',
      serializers.serialize(object.readonly, specifiedType: const FullType(bool)),
      'content',
      serializers.serialize(object.content, specifiedType: const FullType(String)),
      'title',
      serializers.serialize(object.title, specifiedType: const FullType(String)),
      'category',
      serializers.serialize(object.category, specifiedType: const FullType(String)),
      'favorite',
      serializers.serialize(object.favorite, specifiedType: const FullType(bool)),
      'modified',
      serializers.serialize(object.modified, specifiedType: const FullType(int)),
      'error',
      serializers.serialize(object.error, specifiedType: const FullType(bool)),
      'errorType',
      serializers.serialize(object.errorType, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  Note deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = NoteBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value, specifiedType: const FullType(int))! as int;
          break;
        case 'etag':
          result.etag = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'readonly':
          result.readonly = serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
        case 'content':
          result.content = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'title':
          result.title = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'category':
          result.category = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'favorite':
          result.favorite = serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
        case 'modified':
          result.modified = serializers.deserialize(value, specifiedType: const FullType(int))! as int;
          break;
        case 'error':
          result.error = serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
        case 'errorType':
          result.errorType = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$SettingsSerializer implements StructuredSerializer<Settings> {
  @override
  final Iterable<Type> types = const [Settings, _$Settings];
  @override
  final String wireName = 'Settings';

  @override
  Iterable<Object?> serialize(Serializers serializers, Settings object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'notesPath',
      serializers.serialize(object.notesPath, specifiedType: const FullType(String)),
      'fileSuffix',
      serializers.serialize(object.fileSuffix, specifiedType: const FullType(String)),
      'noteMode',
      serializers.serialize(object.noteMode, specifiedType: const FullType(Settings_NoteMode)),
    ];

    return result;
  }

  @override
  Settings deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = SettingsBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'notesPath':
          result.notesPath = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'fileSuffix':
          result.fileSuffix = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'noteMode':
          result.noteMode =
              serializers.deserialize(value, specifiedType: const FullType(Settings_NoteMode))! as Settings_NoteMode;
          break;
      }
    }

    return result.build();
  }
}

class _$Capabilities_NotesSerializer implements StructuredSerializer<Capabilities_Notes> {
  @override
  final Iterable<Type> types = const [Capabilities_Notes, _$Capabilities_Notes];
  @override
  final String wireName = 'Capabilities_Notes';

  @override
  Iterable<Object?> serialize(Serializers serializers, Capabilities_Notes object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.apiVersion;
    if (value != null) {
      result
        ..add('api_version')
        ..add(serializers.serialize(value, specifiedType: const FullType(BuiltList, [FullType(String)])));
    }
    value = object.version;
    if (value != null) {
      result
        ..add('version')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  Capabilities_Notes deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = Capabilities_NotesBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'api_version':
          result.apiVersion.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, [FullType(String)]))! as BuiltList<Object?>);
          break;
        case 'version':
          result.version = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$CapabilitiesSerializer implements StructuredSerializer<Capabilities> {
  @override
  final Iterable<Type> types = const [Capabilities, _$Capabilities];
  @override
  final String wireName = 'Capabilities';

  @override
  Iterable<Object?> serialize(Serializers serializers, Capabilities object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'notes',
      serializers.serialize(object.notes, specifiedType: const FullType(Capabilities_Notes)),
    ];

    return result;
  }

  @override
  Capabilities deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = CapabilitiesBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'notes':
          result.notes.replace(
              serializers.deserialize(value, specifiedType: const FullType(Capabilities_Notes))! as Capabilities_Notes);
          break;
      }
    }

    return result.build();
  }
}

class _$OCSMetaSerializer implements StructuredSerializer<OCSMeta> {
  @override
  final Iterable<Type> types = const [OCSMeta, _$OCSMeta];
  @override
  final String wireName = 'OCSMeta';

  @override
  Iterable<Object?> serialize(Serializers serializers, OCSMeta object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'status',
      serializers.serialize(object.status, specifiedType: const FullType(String)),
      'statuscode',
      serializers.serialize(object.statuscode, specifiedType: const FullType(int)),
    ];
    Object? value;
    value = object.message;
    if (value != null) {
      result
        ..add('message')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    value = object.totalitems;
    if (value != null) {
      result
        ..add('totalitems')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    value = object.itemsperpage;
    if (value != null) {
      result
        ..add('itemsperpage')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  OCSMeta deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = OCSMetaBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'status':
          result.status = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'statuscode':
          result.statuscode = serializers.deserialize(value, specifiedType: const FullType(int))! as int;
          break;
        case 'message':
          result.message = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case 'totalitems':
          result.totalitems = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case 'itemsperpage':
          result.itemsperpage = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$EmptyOCS_OcsSerializer implements StructuredSerializer<EmptyOCS_Ocs> {
  @override
  final Iterable<Type> types = const [EmptyOCS_Ocs, _$EmptyOCS_Ocs];
  @override
  final String wireName = 'EmptyOCS_Ocs';

  @override
  Iterable<Object?> serialize(Serializers serializers, EmptyOCS_Ocs object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'meta',
      serializers.serialize(object.meta, specifiedType: const FullType(OCSMeta)),
      'data',
      serializers.serialize(object.data, specifiedType: const FullType(BuiltList, [FullType(JsonObject)])),
    ];

    return result;
  }

  @override
  EmptyOCS_Ocs deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = EmptyOCS_OcsBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'meta':
          result.meta.replace(serializers.deserialize(value, specifiedType: const FullType(OCSMeta))! as OCSMeta);
          break;
        case 'data':
          result.data.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, [FullType(JsonObject)]))! as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$EmptyOCSSerializer implements StructuredSerializer<EmptyOCS> {
  @override
  final Iterable<Type> types = const [EmptyOCS, _$EmptyOCS];
  @override
  final String wireName = 'EmptyOCS';

  @override
  Iterable<Object?> serialize(Serializers serializers, EmptyOCS object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'ocs',
      serializers.serialize(object.ocs, specifiedType: const FullType(EmptyOCS_Ocs)),
    ];

    return result;
  }

  @override
  EmptyOCS deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = EmptyOCSBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'ocs':
          result.ocs
              .replace(serializers.deserialize(value, specifiedType: const FullType(EmptyOCS_Ocs))! as EmptyOCS_Ocs);
          break;
      }
    }

    return result.build();
  }
}

abstract mixin class $NoteInterfaceBuilder {
  void replace($NoteInterface other);
  void update(void Function($NoteInterfaceBuilder) updates);
  int? get id;
  set id(int? id);

  String? get etag;
  set etag(String? etag);

  bool? get readonly;
  set readonly(bool? readonly);

  String? get content;
  set content(String? content);

  String? get title;
  set title(String? title);

  String? get category;
  set category(String? category);

  bool? get favorite;
  set favorite(bool? favorite);

  int? get modified;
  set modified(int? modified);

  bool? get error;
  set error(bool? error);

  String? get errorType;
  set errorType(String? errorType);
}

class _$Note extends Note {
  @override
  final int id;
  @override
  final String etag;
  @override
  final bool readonly;
  @override
  final String content;
  @override
  final String title;
  @override
  final String category;
  @override
  final bool favorite;
  @override
  final int modified;
  @override
  final bool error;
  @override
  final String errorType;

  factory _$Note([void Function(NoteBuilder)? updates]) => (NoteBuilder()..update(updates))._build();

  _$Note._(
      {required this.id,
      required this.etag,
      required this.readonly,
      required this.content,
      required this.title,
      required this.category,
      required this.favorite,
      required this.modified,
      required this.error,
      required this.errorType})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'Note', 'id');
    BuiltValueNullFieldError.checkNotNull(etag, r'Note', 'etag');
    BuiltValueNullFieldError.checkNotNull(readonly, r'Note', 'readonly');
    BuiltValueNullFieldError.checkNotNull(content, r'Note', 'content');
    BuiltValueNullFieldError.checkNotNull(title, r'Note', 'title');
    BuiltValueNullFieldError.checkNotNull(category, r'Note', 'category');
    BuiltValueNullFieldError.checkNotNull(favorite, r'Note', 'favorite');
    BuiltValueNullFieldError.checkNotNull(modified, r'Note', 'modified');
    BuiltValueNullFieldError.checkNotNull(error, r'Note', 'error');
    BuiltValueNullFieldError.checkNotNull(errorType, r'Note', 'errorType');
  }

  @override
  Note rebuild(void Function(NoteBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  NoteBuilder toBuilder() => NoteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Note &&
        id == other.id &&
        etag == other.etag &&
        readonly == other.readonly &&
        content == other.content &&
        title == other.title &&
        category == other.category &&
        favorite == other.favorite &&
        modified == other.modified &&
        error == other.error &&
        errorType == other.errorType;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, etag.hashCode);
    _$hash = $jc(_$hash, readonly.hashCode);
    _$hash = $jc(_$hash, content.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, favorite.hashCode);
    _$hash = $jc(_$hash, modified.hashCode);
    _$hash = $jc(_$hash, error.hashCode);
    _$hash = $jc(_$hash, errorType.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Note')
          ..add('id', id)
          ..add('etag', etag)
          ..add('readonly', readonly)
          ..add('content', content)
          ..add('title', title)
          ..add('category', category)
          ..add('favorite', favorite)
          ..add('modified', modified)
          ..add('error', error)
          ..add('errorType', errorType))
        .toString();
  }
}

class NoteBuilder implements Builder<Note, NoteBuilder>, $NoteInterfaceBuilder {
  _$Note? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(covariant int? id) => _$this._id = id;

  String? _etag;
  String? get etag => _$this._etag;
  set etag(covariant String? etag) => _$this._etag = etag;

  bool? _readonly;
  bool? get readonly => _$this._readonly;
  set readonly(covariant bool? readonly) => _$this._readonly = readonly;

  String? _content;
  String? get content => _$this._content;
  set content(covariant String? content) => _$this._content = content;

  String? _title;
  String? get title => _$this._title;
  set title(covariant String? title) => _$this._title = title;

  String? _category;
  String? get category => _$this._category;
  set category(covariant String? category) => _$this._category = category;

  bool? _favorite;
  bool? get favorite => _$this._favorite;
  set favorite(covariant bool? favorite) => _$this._favorite = favorite;

  int? _modified;
  int? get modified => _$this._modified;
  set modified(covariant int? modified) => _$this._modified = modified;

  bool? _error;
  bool? get error => _$this._error;
  set error(covariant bool? error) => _$this._error = error;

  String? _errorType;
  String? get errorType => _$this._errorType;
  set errorType(covariant String? errorType) => _$this._errorType = errorType;

  NoteBuilder();

  NoteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _etag = $v.etag;
      _readonly = $v.readonly;
      _content = $v.content;
      _title = $v.title;
      _category = $v.category;
      _favorite = $v.favorite;
      _modified = $v.modified;
      _error = $v.error;
      _errorType = $v.errorType;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant Note other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Note;
  }

  @override
  void update(void Function(NoteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Note build() => _build();

  _$Note _build() {
    final _$result = _$v ??
        _$Note._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'Note', 'id'),
            etag: BuiltValueNullFieldError.checkNotNull(etag, r'Note', 'etag'),
            readonly: BuiltValueNullFieldError.checkNotNull(readonly, r'Note', 'readonly'),
            content: BuiltValueNullFieldError.checkNotNull(content, r'Note', 'content'),
            title: BuiltValueNullFieldError.checkNotNull(title, r'Note', 'title'),
            category: BuiltValueNullFieldError.checkNotNull(category, r'Note', 'category'),
            favorite: BuiltValueNullFieldError.checkNotNull(favorite, r'Note', 'favorite'),
            modified: BuiltValueNullFieldError.checkNotNull(modified, r'Note', 'modified'),
            error: BuiltValueNullFieldError.checkNotNull(error, r'Note', 'error'),
            errorType: BuiltValueNullFieldError.checkNotNull(errorType, r'Note', 'errorType'));
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $SettingsInterfaceBuilder {
  void replace($SettingsInterface other);
  void update(void Function($SettingsInterfaceBuilder) updates);
  String? get notesPath;
  set notesPath(String? notesPath);

  String? get fileSuffix;
  set fileSuffix(String? fileSuffix);

  Settings_NoteMode? get noteMode;
  set noteMode(Settings_NoteMode? noteMode);
}

class _$Settings extends Settings {
  @override
  final String notesPath;
  @override
  final String fileSuffix;
  @override
  final Settings_NoteMode noteMode;

  factory _$Settings([void Function(SettingsBuilder)? updates]) => (SettingsBuilder()..update(updates))._build();

  _$Settings._({required this.notesPath, required this.fileSuffix, required this.noteMode}) : super._() {
    BuiltValueNullFieldError.checkNotNull(notesPath, r'Settings', 'notesPath');
    BuiltValueNullFieldError.checkNotNull(fileSuffix, r'Settings', 'fileSuffix');
    BuiltValueNullFieldError.checkNotNull(noteMode, r'Settings', 'noteMode');
  }

  @override
  Settings rebuild(void Function(SettingsBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  SettingsBuilder toBuilder() => SettingsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Settings &&
        notesPath == other.notesPath &&
        fileSuffix == other.fileSuffix &&
        noteMode == other.noteMode;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, notesPath.hashCode);
    _$hash = $jc(_$hash, fileSuffix.hashCode);
    _$hash = $jc(_$hash, noteMode.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Settings')
          ..add('notesPath', notesPath)
          ..add('fileSuffix', fileSuffix)
          ..add('noteMode', noteMode))
        .toString();
  }
}

class SettingsBuilder implements Builder<Settings, SettingsBuilder>, $SettingsInterfaceBuilder {
  _$Settings? _$v;

  String? _notesPath;
  String? get notesPath => _$this._notesPath;
  set notesPath(covariant String? notesPath) => _$this._notesPath = notesPath;

  String? _fileSuffix;
  String? get fileSuffix => _$this._fileSuffix;
  set fileSuffix(covariant String? fileSuffix) => _$this._fileSuffix = fileSuffix;

  Settings_NoteMode? _noteMode;
  Settings_NoteMode? get noteMode => _$this._noteMode;
  set noteMode(covariant Settings_NoteMode? noteMode) => _$this._noteMode = noteMode;

  SettingsBuilder();

  SettingsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _notesPath = $v.notesPath;
      _fileSuffix = $v.fileSuffix;
      _noteMode = $v.noteMode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant Settings other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Settings;
  }

  @override
  void update(void Function(SettingsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Settings build() => _build();

  _$Settings _build() {
    final _$result = _$v ??
        _$Settings._(
            notesPath: BuiltValueNullFieldError.checkNotNull(notesPath, r'Settings', 'notesPath'),
            fileSuffix: BuiltValueNullFieldError.checkNotNull(fileSuffix, r'Settings', 'fileSuffix'),
            noteMode: BuiltValueNullFieldError.checkNotNull(noteMode, r'Settings', 'noteMode'));
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $Capabilities_NotesInterfaceBuilder {
  void replace($Capabilities_NotesInterface other);
  void update(void Function($Capabilities_NotesInterfaceBuilder) updates);
  ListBuilder<String> get apiVersion;
  set apiVersion(ListBuilder<String>? apiVersion);

  String? get version;
  set version(String? version);
}

class _$Capabilities_Notes extends Capabilities_Notes {
  @override
  final BuiltList<String>? apiVersion;
  @override
  final String? version;

  factory _$Capabilities_Notes([void Function(Capabilities_NotesBuilder)? updates]) =>
      (Capabilities_NotesBuilder()..update(updates))._build();

  _$Capabilities_Notes._({this.apiVersion, this.version}) : super._();

  @override
  Capabilities_Notes rebuild(void Function(Capabilities_NotesBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  Capabilities_NotesBuilder toBuilder() => Capabilities_NotesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Capabilities_Notes && apiVersion == other.apiVersion && version == other.version;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, apiVersion.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Capabilities_Notes')
          ..add('apiVersion', apiVersion)
          ..add('version', version))
        .toString();
  }
}

class Capabilities_NotesBuilder
    implements Builder<Capabilities_Notes, Capabilities_NotesBuilder>, $Capabilities_NotesInterfaceBuilder {
  _$Capabilities_Notes? _$v;

  ListBuilder<String>? _apiVersion;
  ListBuilder<String> get apiVersion => _$this._apiVersion ??= ListBuilder<String>();
  set apiVersion(covariant ListBuilder<String>? apiVersion) => _$this._apiVersion = apiVersion;

  String? _version;
  String? get version => _$this._version;
  set version(covariant String? version) => _$this._version = version;

  Capabilities_NotesBuilder();

  Capabilities_NotesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _apiVersion = $v.apiVersion?.toBuilder();
      _version = $v.version;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant Capabilities_Notes other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Capabilities_Notes;
  }

  @override
  void update(void Function(Capabilities_NotesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Capabilities_Notes build() => _build();

  _$Capabilities_Notes _build() {
    _$Capabilities_Notes _$result;
    try {
      _$result = _$v ?? _$Capabilities_Notes._(apiVersion: _apiVersion?.build(), version: version);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'apiVersion';
        _apiVersion?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'Capabilities_Notes', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $CapabilitiesInterfaceBuilder {
  void replace($CapabilitiesInterface other);
  void update(void Function($CapabilitiesInterfaceBuilder) updates);
  Capabilities_NotesBuilder get notes;
  set notes(Capabilities_NotesBuilder? notes);
}

class _$Capabilities extends Capabilities {
  @override
  final Capabilities_Notes notes;

  factory _$Capabilities([void Function(CapabilitiesBuilder)? updates]) =>
      (CapabilitiesBuilder()..update(updates))._build();

  _$Capabilities._({required this.notes}) : super._() {
    BuiltValueNullFieldError.checkNotNull(notes, r'Capabilities', 'notes');
  }

  @override
  Capabilities rebuild(void Function(CapabilitiesBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  CapabilitiesBuilder toBuilder() => CapabilitiesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Capabilities && notes == other.notes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, notes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Capabilities')..add('notes', notes)).toString();
  }
}

class CapabilitiesBuilder implements Builder<Capabilities, CapabilitiesBuilder>, $CapabilitiesInterfaceBuilder {
  _$Capabilities? _$v;

  Capabilities_NotesBuilder? _notes;
  Capabilities_NotesBuilder get notes => _$this._notes ??= Capabilities_NotesBuilder();
  set notes(covariant Capabilities_NotesBuilder? notes) => _$this._notes = notes;

  CapabilitiesBuilder();

  CapabilitiesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _notes = $v.notes.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant Capabilities other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Capabilities;
  }

  @override
  void update(void Function(CapabilitiesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Capabilities build() => _build();

  _$Capabilities _build() {
    _$Capabilities _$result;
    try {
      _$result = _$v ?? _$Capabilities._(notes: notes.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'notes';
        notes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'Capabilities', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $OCSMetaInterfaceBuilder {
  void replace($OCSMetaInterface other);
  void update(void Function($OCSMetaInterfaceBuilder) updates);
  String? get status;
  set status(String? status);

  int? get statuscode;
  set statuscode(int? statuscode);

  String? get message;
  set message(String? message);

  String? get totalitems;
  set totalitems(String? totalitems);

  String? get itemsperpage;
  set itemsperpage(String? itemsperpage);
}

class _$OCSMeta extends OCSMeta {
  @override
  final String status;
  @override
  final int statuscode;
  @override
  final String? message;
  @override
  final String? totalitems;
  @override
  final String? itemsperpage;

  factory _$OCSMeta([void Function(OCSMetaBuilder)? updates]) => (OCSMetaBuilder()..update(updates))._build();

  _$OCSMeta._({required this.status, required this.statuscode, this.message, this.totalitems, this.itemsperpage})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(status, r'OCSMeta', 'status');
    BuiltValueNullFieldError.checkNotNull(statuscode, r'OCSMeta', 'statuscode');
  }

  @override
  OCSMeta rebuild(void Function(OCSMetaBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  OCSMetaBuilder toBuilder() => OCSMetaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OCSMeta &&
        status == other.status &&
        statuscode == other.statuscode &&
        message == other.message &&
        totalitems == other.totalitems &&
        itemsperpage == other.itemsperpage;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, statuscode.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, totalitems.hashCode);
    _$hash = $jc(_$hash, itemsperpage.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OCSMeta')
          ..add('status', status)
          ..add('statuscode', statuscode)
          ..add('message', message)
          ..add('totalitems', totalitems)
          ..add('itemsperpage', itemsperpage))
        .toString();
  }
}

class OCSMetaBuilder implements Builder<OCSMeta, OCSMetaBuilder>, $OCSMetaInterfaceBuilder {
  _$OCSMeta? _$v;

  String? _status;
  String? get status => _$this._status;
  set status(covariant String? status) => _$this._status = status;

  int? _statuscode;
  int? get statuscode => _$this._statuscode;
  set statuscode(covariant int? statuscode) => _$this._statuscode = statuscode;

  String? _message;
  String? get message => _$this._message;
  set message(covariant String? message) => _$this._message = message;

  String? _totalitems;
  String? get totalitems => _$this._totalitems;
  set totalitems(covariant String? totalitems) => _$this._totalitems = totalitems;

  String? _itemsperpage;
  String? get itemsperpage => _$this._itemsperpage;
  set itemsperpage(covariant String? itemsperpage) => _$this._itemsperpage = itemsperpage;

  OCSMetaBuilder();

  OCSMetaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _statuscode = $v.statuscode;
      _message = $v.message;
      _totalitems = $v.totalitems;
      _itemsperpage = $v.itemsperpage;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant OCSMeta other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$OCSMeta;
  }

  @override
  void update(void Function(OCSMetaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OCSMeta build() => _build();

  _$OCSMeta _build() {
    final _$result = _$v ??
        _$OCSMeta._(
            status: BuiltValueNullFieldError.checkNotNull(status, r'OCSMeta', 'status'),
            statuscode: BuiltValueNullFieldError.checkNotNull(statuscode, r'OCSMeta', 'statuscode'),
            message: message,
            totalitems: totalitems,
            itemsperpage: itemsperpage);
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $EmptyOCS_OcsInterfaceBuilder {
  void replace($EmptyOCS_OcsInterface other);
  void update(void Function($EmptyOCS_OcsInterfaceBuilder) updates);
  OCSMetaBuilder get meta;
  set meta(OCSMetaBuilder? meta);

  ListBuilder<JsonObject> get data;
  set data(ListBuilder<JsonObject>? data);
}

class _$EmptyOCS_Ocs extends EmptyOCS_Ocs {
  @override
  final OCSMeta meta;
  @override
  final BuiltList<JsonObject> data;

  factory _$EmptyOCS_Ocs([void Function(EmptyOCS_OcsBuilder)? updates]) =>
      (EmptyOCS_OcsBuilder()..update(updates))._build();

  _$EmptyOCS_Ocs._({required this.meta, required this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(meta, r'EmptyOCS_Ocs', 'meta');
    BuiltValueNullFieldError.checkNotNull(data, r'EmptyOCS_Ocs', 'data');
  }

  @override
  EmptyOCS_Ocs rebuild(void Function(EmptyOCS_OcsBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  EmptyOCS_OcsBuilder toBuilder() => EmptyOCS_OcsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmptyOCS_Ocs && meta == other.meta && data == other.data;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, meta.hashCode);
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EmptyOCS_Ocs')
          ..add('meta', meta)
          ..add('data', data))
        .toString();
  }
}

class EmptyOCS_OcsBuilder implements Builder<EmptyOCS_Ocs, EmptyOCS_OcsBuilder>, $EmptyOCS_OcsInterfaceBuilder {
  _$EmptyOCS_Ocs? _$v;

  OCSMetaBuilder? _meta;
  OCSMetaBuilder get meta => _$this._meta ??= OCSMetaBuilder();
  set meta(covariant OCSMetaBuilder? meta) => _$this._meta = meta;

  ListBuilder<JsonObject>? _data;
  ListBuilder<JsonObject> get data => _$this._data ??= ListBuilder<JsonObject>();
  set data(covariant ListBuilder<JsonObject>? data) => _$this._data = data;

  EmptyOCS_OcsBuilder();

  EmptyOCS_OcsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _meta = $v.meta.toBuilder();
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant EmptyOCS_Ocs other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$EmptyOCS_Ocs;
  }

  @override
  void update(void Function(EmptyOCS_OcsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmptyOCS_Ocs build() => _build();

  _$EmptyOCS_Ocs _build() {
    _$EmptyOCS_Ocs _$result;
    try {
      _$result = _$v ?? _$EmptyOCS_Ocs._(meta: meta.build(), data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'meta';
        meta.build();
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'EmptyOCS_Ocs', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $EmptyOCSInterfaceBuilder {
  void replace($EmptyOCSInterface other);
  void update(void Function($EmptyOCSInterfaceBuilder) updates);
  EmptyOCS_OcsBuilder get ocs;
  set ocs(EmptyOCS_OcsBuilder? ocs);
}

class _$EmptyOCS extends EmptyOCS {
  @override
  final EmptyOCS_Ocs ocs;

  factory _$EmptyOCS([void Function(EmptyOCSBuilder)? updates]) => (EmptyOCSBuilder()..update(updates))._build();

  _$EmptyOCS._({required this.ocs}) : super._() {
    BuiltValueNullFieldError.checkNotNull(ocs, r'EmptyOCS', 'ocs');
  }

  @override
  EmptyOCS rebuild(void Function(EmptyOCSBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  EmptyOCSBuilder toBuilder() => EmptyOCSBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmptyOCS && ocs == other.ocs;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ocs.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EmptyOCS')..add('ocs', ocs)).toString();
  }
}

class EmptyOCSBuilder implements Builder<EmptyOCS, EmptyOCSBuilder>, $EmptyOCSInterfaceBuilder {
  _$EmptyOCS? _$v;

  EmptyOCS_OcsBuilder? _ocs;
  EmptyOCS_OcsBuilder get ocs => _$this._ocs ??= EmptyOCS_OcsBuilder();
  set ocs(covariant EmptyOCS_OcsBuilder? ocs) => _$this._ocs = ocs;

  EmptyOCSBuilder();

  EmptyOCSBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ocs = $v.ocs.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant EmptyOCS other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$EmptyOCS;
  }

  @override
  void update(void Function(EmptyOCSBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmptyOCS build() => _build();

  _$EmptyOCS _build() {
    _$EmptyOCS _$result;
    try {
      _$result = _$v ?? _$EmptyOCS._(ocs: ocs.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ocs';
        ocs.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'EmptyOCS', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
