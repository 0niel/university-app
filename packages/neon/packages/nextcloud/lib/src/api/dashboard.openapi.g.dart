// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard.openapi.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<OCSMeta> _$oCSMetaSerializer = _$OCSMetaSerializer();
Serializer<Widget_Buttons> _$widgetButtonsSerializer = _$Widget_ButtonsSerializer();
Serializer<Widget> _$widgetSerializer = _$WidgetSerializer();
Serializer<DashboardApiGetWidgetsResponseApplicationJson_Ocs>
    _$dashboardApiGetWidgetsResponseApplicationJsonOcsSerializer =
    _$DashboardApiGetWidgetsResponseApplicationJson_OcsSerializer();
Serializer<DashboardApiGetWidgetsResponseApplicationJson> _$dashboardApiGetWidgetsResponseApplicationJsonSerializer =
    _$DashboardApiGetWidgetsResponseApplicationJsonSerializer();
Serializer<WidgetItem> _$widgetItemSerializer = _$WidgetItemSerializer();
Serializer<DashboardApiGetWidgetItemsResponseApplicationJson_Ocs>
    _$dashboardApiGetWidgetItemsResponseApplicationJsonOcsSerializer =
    _$DashboardApiGetWidgetItemsResponseApplicationJson_OcsSerializer();
Serializer<DashboardApiGetWidgetItemsResponseApplicationJson>
    _$dashboardApiGetWidgetItemsResponseApplicationJsonSerializer =
    _$DashboardApiGetWidgetItemsResponseApplicationJsonSerializer();
Serializer<WidgetItems> _$widgetItemsSerializer = _$WidgetItemsSerializer();
Serializer<DashboardApiGetWidgetItemsV2ResponseApplicationJson_Ocs>
    _$dashboardApiGetWidgetItemsV2ResponseApplicationJsonOcsSerializer =
    _$DashboardApiGetWidgetItemsV2ResponseApplicationJson_OcsSerializer();
Serializer<DashboardApiGetWidgetItemsV2ResponseApplicationJson>
    _$dashboardApiGetWidgetItemsV2ResponseApplicationJsonSerializer =
    _$DashboardApiGetWidgetItemsV2ResponseApplicationJsonSerializer();

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

class _$Widget_ButtonsSerializer implements StructuredSerializer<Widget_Buttons> {
  @override
  final Iterable<Type> types = const [Widget_Buttons, _$Widget_Buttons];
  @override
  final String wireName = 'Widget_Buttons';

  @override
  Iterable<Object?> serialize(Serializers serializers, Widget_Buttons object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'type',
      serializers.serialize(object.type, specifiedType: const FullType(String)),
      'text',
      serializers.serialize(object.text, specifiedType: const FullType(String)),
      'link',
      serializers.serialize(object.link, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  Widget_Buttons deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = Widget_ButtonsBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'type':
          result.type = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'text':
          result.text = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'link':
          result.link = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$WidgetSerializer implements StructuredSerializer<Widget> {
  @override
  final Iterable<Type> types = const [Widget, _$Widget];
  @override
  final String wireName = 'Widget';

  @override
  Iterable<Object?> serialize(Serializers serializers, Widget object, {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'title',
      serializers.serialize(object.title, specifiedType: const FullType(String)),
      'order',
      serializers.serialize(object.order, specifiedType: const FullType(int)),
      'icon_class',
      serializers.serialize(object.iconClass, specifiedType: const FullType(String)),
      'icon_url',
      serializers.serialize(object.iconUrl, specifiedType: const FullType(String)),
      'item_icons_round',
      serializers.serialize(object.itemIconsRound, specifiedType: const FullType(bool)),
    ];
    Object? value;
    value = object.widgetUrl;
    if (value != null) {
      result
        ..add('widget_url')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    value = object.itemApiVersions;
    if (value != null) {
      result
        ..add('item_api_versions')
        ..add(serializers.serialize(value, specifiedType: const FullType(BuiltList, [FullType(int)])));
    }
    value = object.reloadInterval;
    if (value != null) {
      result
        ..add('reload_interval')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.buttons;
    if (value != null) {
      result
        ..add('buttons')
        ..add(serializers.serialize(value, specifiedType: const FullType(BuiltList, [FullType(Widget_Buttons)])));
    }
    return result;
  }

  @override
  Widget deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = WidgetBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'title':
          result.title = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'order':
          result.order = serializers.deserialize(value, specifiedType: const FullType(int))! as int;
          break;
        case 'icon_class':
          result.iconClass = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'icon_url':
          result.iconUrl = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'widget_url':
          result.widgetUrl = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case 'item_icons_round':
          result.itemIconsRound = serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
        case 'item_api_versions':
          result.itemApiVersions.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, [FullType(int)]))! as BuiltList<Object?>);
          break;
        case 'reload_interval':
          result.reloadInterval = serializers.deserialize(value, specifiedType: const FullType(int)) as int?;
          break;
        case 'buttons':
          result.buttons.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, [FullType(Widget_Buttons)]))! as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$DashboardApiGetWidgetsResponseApplicationJson_OcsSerializer
    implements StructuredSerializer<DashboardApiGetWidgetsResponseApplicationJson_Ocs> {
  @override
  final Iterable<Type> types = const [
    DashboardApiGetWidgetsResponseApplicationJson_Ocs,
    _$DashboardApiGetWidgetsResponseApplicationJson_Ocs
  ];
  @override
  final String wireName = 'DashboardApiGetWidgetsResponseApplicationJson_Ocs';

  @override
  Iterable<Object?> serialize(Serializers serializers, DashboardApiGetWidgetsResponseApplicationJson_Ocs object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'meta',
      serializers.serialize(object.meta, specifiedType: const FullType(OCSMeta)),
      'data',
      serializers.serialize(object.data, specifiedType: const FullType(BuiltMap, [FullType(String), FullType(Widget)])),
    ];

    return result;
  }

  @override
  DashboardApiGetWidgetsResponseApplicationJson_Ocs deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = DashboardApiGetWidgetsResponseApplicationJson_OcsBuilder();

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
              specifiedType: const FullType(BuiltMap, [FullType(String), FullType(Widget)]))!);
          break;
      }
    }

    return result.build();
  }
}

class _$DashboardApiGetWidgetsResponseApplicationJsonSerializer
    implements StructuredSerializer<DashboardApiGetWidgetsResponseApplicationJson> {
  @override
  final Iterable<Type> types = const [
    DashboardApiGetWidgetsResponseApplicationJson,
    _$DashboardApiGetWidgetsResponseApplicationJson
  ];
  @override
  final String wireName = 'DashboardApiGetWidgetsResponseApplicationJson';

  @override
  Iterable<Object?> serialize(Serializers serializers, DashboardApiGetWidgetsResponseApplicationJson object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'ocs',
      serializers.serialize(object.ocs,
          specifiedType: const FullType(DashboardApiGetWidgetsResponseApplicationJson_Ocs)),
    ];

    return result;
  }

  @override
  DashboardApiGetWidgetsResponseApplicationJson deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = DashboardApiGetWidgetsResponseApplicationJsonBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'ocs':
          result.ocs.replace(serializers.deserialize(value,
                  specifiedType: const FullType(DashboardApiGetWidgetsResponseApplicationJson_Ocs))!
              as DashboardApiGetWidgetsResponseApplicationJson_Ocs);
          break;
      }
    }

    return result.build();
  }
}

class _$WidgetItemSerializer implements StructuredSerializer<WidgetItem> {
  @override
  final Iterable<Type> types = const [WidgetItem, _$WidgetItem];
  @override
  final String wireName = 'WidgetItem';

  @override
  Iterable<Object?> serialize(Serializers serializers, WidgetItem object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'subtitle',
      serializers.serialize(object.subtitle, specifiedType: const FullType(String)),
      'title',
      serializers.serialize(object.title, specifiedType: const FullType(String)),
      'link',
      serializers.serialize(object.link, specifiedType: const FullType(String)),
      'iconUrl',
      serializers.serialize(object.iconUrl, specifiedType: const FullType(String)),
      'sinceId',
      serializers.serialize(object.sinceId, specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.overlayIconUrl;
    if (value != null) {
      result
        ..add('overlayIconUrl')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  WidgetItem deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = WidgetItemBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'subtitle':
          result.subtitle = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'title':
          result.title = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'link':
          result.link = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'iconUrl':
          result.iconUrl = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'overlayIconUrl':
          result.overlayIconUrl = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case 'sinceId':
          result.sinceId = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$DashboardApiGetWidgetItemsResponseApplicationJson_OcsSerializer
    implements StructuredSerializer<DashboardApiGetWidgetItemsResponseApplicationJson_Ocs> {
  @override
  final Iterable<Type> types = const [
    DashboardApiGetWidgetItemsResponseApplicationJson_Ocs,
    _$DashboardApiGetWidgetItemsResponseApplicationJson_Ocs
  ];
  @override
  final String wireName = 'DashboardApiGetWidgetItemsResponseApplicationJson_Ocs';

  @override
  Iterable<Object?> serialize(Serializers serializers, DashboardApiGetWidgetItemsResponseApplicationJson_Ocs object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'meta',
      serializers.serialize(object.meta, specifiedType: const FullType(OCSMeta)),
      'data',
      serializers.serialize(object.data,
          specifiedType: const FullType(BuiltMap, [
            FullType(String),
            FullType(BuiltList, [FullType(WidgetItem)])
          ])),
    ];

    return result;
  }

  @override
  DashboardApiGetWidgetItemsResponseApplicationJson_Ocs deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = DashboardApiGetWidgetItemsResponseApplicationJson_OcsBuilder();

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
              specifiedType: const FullType(BuiltMap, [
                FullType(String),
                FullType(BuiltList, [FullType(WidgetItem)])
              ]))!);
          break;
      }
    }

    return result.build();
  }
}

class _$DashboardApiGetWidgetItemsResponseApplicationJsonSerializer
    implements StructuredSerializer<DashboardApiGetWidgetItemsResponseApplicationJson> {
  @override
  final Iterable<Type> types = const [
    DashboardApiGetWidgetItemsResponseApplicationJson,
    _$DashboardApiGetWidgetItemsResponseApplicationJson
  ];
  @override
  final String wireName = 'DashboardApiGetWidgetItemsResponseApplicationJson';

  @override
  Iterable<Object?> serialize(Serializers serializers, DashboardApiGetWidgetItemsResponseApplicationJson object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'ocs',
      serializers.serialize(object.ocs,
          specifiedType: const FullType(DashboardApiGetWidgetItemsResponseApplicationJson_Ocs)),
    ];

    return result;
  }

  @override
  DashboardApiGetWidgetItemsResponseApplicationJson deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = DashboardApiGetWidgetItemsResponseApplicationJsonBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'ocs':
          result.ocs.replace(serializers.deserialize(value,
                  specifiedType: const FullType(DashboardApiGetWidgetItemsResponseApplicationJson_Ocs))!
              as DashboardApiGetWidgetItemsResponseApplicationJson_Ocs);
          break;
      }
    }

    return result.build();
  }
}

class _$WidgetItemsSerializer implements StructuredSerializer<WidgetItems> {
  @override
  final Iterable<Type> types = const [WidgetItems, _$WidgetItems];
  @override
  final String wireName = 'WidgetItems';

  @override
  Iterable<Object?> serialize(Serializers serializers, WidgetItems object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'items',
      serializers.serialize(object.items, specifiedType: const FullType(BuiltList, [FullType(WidgetItem)])),
      'emptyContentMessage',
      serializers.serialize(object.emptyContentMessage, specifiedType: const FullType(String)),
      'halfEmptyContentMessage',
      serializers.serialize(object.halfEmptyContentMessage, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  WidgetItems deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = WidgetItemsBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'items':
          result.items.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, [FullType(WidgetItem)]))! as BuiltList<Object?>);
          break;
        case 'emptyContentMessage':
          result.emptyContentMessage = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'halfEmptyContentMessage':
          result.halfEmptyContentMessage =
              serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$DashboardApiGetWidgetItemsV2ResponseApplicationJson_OcsSerializer
    implements StructuredSerializer<DashboardApiGetWidgetItemsV2ResponseApplicationJson_Ocs> {
  @override
  final Iterable<Type> types = const [
    DashboardApiGetWidgetItemsV2ResponseApplicationJson_Ocs,
    _$DashboardApiGetWidgetItemsV2ResponseApplicationJson_Ocs
  ];
  @override
  final String wireName = 'DashboardApiGetWidgetItemsV2ResponseApplicationJson_Ocs';

  @override
  Iterable<Object?> serialize(Serializers serializers, DashboardApiGetWidgetItemsV2ResponseApplicationJson_Ocs object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'meta',
      serializers.serialize(object.meta, specifiedType: const FullType(OCSMeta)),
      'data',
      serializers.serialize(object.data,
          specifiedType: const FullType(BuiltMap, [FullType(String), FullType(WidgetItems)])),
    ];

    return result;
  }

  @override
  DashboardApiGetWidgetItemsV2ResponseApplicationJson_Ocs deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = DashboardApiGetWidgetItemsV2ResponseApplicationJson_OcsBuilder();

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
              specifiedType: const FullType(BuiltMap, [FullType(String), FullType(WidgetItems)]))!);
          break;
      }
    }

    return result.build();
  }
}

class _$DashboardApiGetWidgetItemsV2ResponseApplicationJsonSerializer
    implements StructuredSerializer<DashboardApiGetWidgetItemsV2ResponseApplicationJson> {
  @override
  final Iterable<Type> types = const [
    DashboardApiGetWidgetItemsV2ResponseApplicationJson,
    _$DashboardApiGetWidgetItemsV2ResponseApplicationJson
  ];
  @override
  final String wireName = 'DashboardApiGetWidgetItemsV2ResponseApplicationJson';

  @override
  Iterable<Object?> serialize(Serializers serializers, DashboardApiGetWidgetItemsV2ResponseApplicationJson object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'ocs',
      serializers.serialize(object.ocs,
          specifiedType: const FullType(DashboardApiGetWidgetItemsV2ResponseApplicationJson_Ocs)),
    ];

    return result;
  }

  @override
  DashboardApiGetWidgetItemsV2ResponseApplicationJson deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = DashboardApiGetWidgetItemsV2ResponseApplicationJsonBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'ocs':
          result.ocs.replace(serializers.deserialize(value,
                  specifiedType: const FullType(DashboardApiGetWidgetItemsV2ResponseApplicationJson_Ocs))!
              as DashboardApiGetWidgetItemsV2ResponseApplicationJson_Ocs);
          break;
      }
    }

    return result.build();
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

abstract mixin class $Widget_ButtonsInterfaceBuilder {
  void replace($Widget_ButtonsInterface other);
  void update(void Function($Widget_ButtonsInterfaceBuilder) updates);
  String? get type;
  set type(String? type);

  String? get text;
  set text(String? text);

  String? get link;
  set link(String? link);
}

class _$Widget_Buttons extends Widget_Buttons {
  @override
  final String type;
  @override
  final String text;
  @override
  final String link;

  factory _$Widget_Buttons([void Function(Widget_ButtonsBuilder)? updates]) =>
      (Widget_ButtonsBuilder()..update(updates))._build();

  _$Widget_Buttons._({required this.type, required this.text, required this.link}) : super._() {
    BuiltValueNullFieldError.checkNotNull(type, r'Widget_Buttons', 'type');
    BuiltValueNullFieldError.checkNotNull(text, r'Widget_Buttons', 'text');
    BuiltValueNullFieldError.checkNotNull(link, r'Widget_Buttons', 'link');
  }

  @override
  Widget_Buttons rebuild(void Function(Widget_ButtonsBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  Widget_ButtonsBuilder toBuilder() => Widget_ButtonsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Widget_Buttons && type == other.type && text == other.text && link == other.link;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jc(_$hash, link.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Widget_Buttons')
          ..add('type', type)
          ..add('text', text)
          ..add('link', link))
        .toString();
  }
}

class Widget_ButtonsBuilder implements Builder<Widget_Buttons, Widget_ButtonsBuilder>, $Widget_ButtonsInterfaceBuilder {
  _$Widget_Buttons? _$v;

  String? _type;
  String? get type => _$this._type;
  set type(covariant String? type) => _$this._type = type;

  String? _text;
  String? get text => _$this._text;
  set text(covariant String? text) => _$this._text = text;

  String? _link;
  String? get link => _$this._link;
  set link(covariant String? link) => _$this._link = link;

  Widget_ButtonsBuilder();

  Widget_ButtonsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _text = $v.text;
      _link = $v.link;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant Widget_Buttons other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Widget_Buttons;
  }

  @override
  void update(void Function(Widget_ButtonsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Widget_Buttons build() => _build();

  _$Widget_Buttons _build() {
    final _$result = _$v ??
        _$Widget_Buttons._(
            type: BuiltValueNullFieldError.checkNotNull(type, r'Widget_Buttons', 'type'),
            text: BuiltValueNullFieldError.checkNotNull(text, r'Widget_Buttons', 'text'),
            link: BuiltValueNullFieldError.checkNotNull(link, r'Widget_Buttons', 'link'));
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $WidgetInterfaceBuilder {
  void replace($WidgetInterface other);
  void update(void Function($WidgetInterfaceBuilder) updates);
  String? get id;
  set id(String? id);

  String? get title;
  set title(String? title);

  int? get order;
  set order(int? order);

  String? get iconClass;
  set iconClass(String? iconClass);

  String? get iconUrl;
  set iconUrl(String? iconUrl);

  String? get widgetUrl;
  set widgetUrl(String? widgetUrl);

  bool? get itemIconsRound;
  set itemIconsRound(bool? itemIconsRound);

  ListBuilder<int> get itemApiVersions;
  set itemApiVersions(ListBuilder<int>? itemApiVersions);

  int? get reloadInterval;
  set reloadInterval(int? reloadInterval);

  ListBuilder<Widget_Buttons> get buttons;
  set buttons(ListBuilder<Widget_Buttons>? buttons);
}

class _$Widget extends Widget {
  @override
  final String id;
  @override
  final String title;
  @override
  final int order;
  @override
  final String iconClass;
  @override
  final String iconUrl;
  @override
  final String? widgetUrl;
  @override
  final bool itemIconsRound;
  @override
  final BuiltList<int>? itemApiVersions;
  @override
  final int? reloadInterval;
  @override
  final BuiltList<Widget_Buttons>? buttons;

  factory _$Widget([void Function(WidgetBuilder)? updates]) => (WidgetBuilder()..update(updates))._build();

  _$Widget._(
      {required this.id,
      required this.title,
      required this.order,
      required this.iconClass,
      required this.iconUrl,
      this.widgetUrl,
      required this.itemIconsRound,
      this.itemApiVersions,
      this.reloadInterval,
      this.buttons})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'Widget', 'id');
    BuiltValueNullFieldError.checkNotNull(title, r'Widget', 'title');
    BuiltValueNullFieldError.checkNotNull(order, r'Widget', 'order');
    BuiltValueNullFieldError.checkNotNull(iconClass, r'Widget', 'iconClass');
    BuiltValueNullFieldError.checkNotNull(iconUrl, r'Widget', 'iconUrl');
    BuiltValueNullFieldError.checkNotNull(itemIconsRound, r'Widget', 'itemIconsRound');
  }

  @override
  Widget rebuild(void Function(WidgetBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  WidgetBuilder toBuilder() => WidgetBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Widget &&
        id == other.id &&
        title == other.title &&
        order == other.order &&
        iconClass == other.iconClass &&
        iconUrl == other.iconUrl &&
        widgetUrl == other.widgetUrl &&
        itemIconsRound == other.itemIconsRound &&
        itemApiVersions == other.itemApiVersions &&
        reloadInterval == other.reloadInterval &&
        buttons == other.buttons;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, order.hashCode);
    _$hash = $jc(_$hash, iconClass.hashCode);
    _$hash = $jc(_$hash, iconUrl.hashCode);
    _$hash = $jc(_$hash, widgetUrl.hashCode);
    _$hash = $jc(_$hash, itemIconsRound.hashCode);
    _$hash = $jc(_$hash, itemApiVersions.hashCode);
    _$hash = $jc(_$hash, reloadInterval.hashCode);
    _$hash = $jc(_$hash, buttons.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Widget')
          ..add('id', id)
          ..add('title', title)
          ..add('order', order)
          ..add('iconClass', iconClass)
          ..add('iconUrl', iconUrl)
          ..add('widgetUrl', widgetUrl)
          ..add('itemIconsRound', itemIconsRound)
          ..add('itemApiVersions', itemApiVersions)
          ..add('reloadInterval', reloadInterval)
          ..add('buttons', buttons))
        .toString();
  }
}

class WidgetBuilder implements Builder<Widget, WidgetBuilder>, $WidgetInterfaceBuilder {
  _$Widget? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(covariant String? id) => _$this._id = id;

  String? _title;
  String? get title => _$this._title;
  set title(covariant String? title) => _$this._title = title;

  int? _order;
  int? get order => _$this._order;
  set order(covariant int? order) => _$this._order = order;

  String? _iconClass;
  String? get iconClass => _$this._iconClass;
  set iconClass(covariant String? iconClass) => _$this._iconClass = iconClass;

  String? _iconUrl;
  String? get iconUrl => _$this._iconUrl;
  set iconUrl(covariant String? iconUrl) => _$this._iconUrl = iconUrl;

  String? _widgetUrl;
  String? get widgetUrl => _$this._widgetUrl;
  set widgetUrl(covariant String? widgetUrl) => _$this._widgetUrl = widgetUrl;

  bool? _itemIconsRound;
  bool? get itemIconsRound => _$this._itemIconsRound;
  set itemIconsRound(covariant bool? itemIconsRound) => _$this._itemIconsRound = itemIconsRound;

  ListBuilder<int>? _itemApiVersions;
  ListBuilder<int> get itemApiVersions => _$this._itemApiVersions ??= ListBuilder<int>();
  set itemApiVersions(covariant ListBuilder<int>? itemApiVersions) => _$this._itemApiVersions = itemApiVersions;

  int? _reloadInterval;
  int? get reloadInterval => _$this._reloadInterval;
  set reloadInterval(covariant int? reloadInterval) => _$this._reloadInterval = reloadInterval;

  ListBuilder<Widget_Buttons>? _buttons;
  ListBuilder<Widget_Buttons> get buttons => _$this._buttons ??= ListBuilder<Widget_Buttons>();
  set buttons(covariant ListBuilder<Widget_Buttons>? buttons) => _$this._buttons = buttons;

  WidgetBuilder();

  WidgetBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _title = $v.title;
      _order = $v.order;
      _iconClass = $v.iconClass;
      _iconUrl = $v.iconUrl;
      _widgetUrl = $v.widgetUrl;
      _itemIconsRound = $v.itemIconsRound;
      _itemApiVersions = $v.itemApiVersions?.toBuilder();
      _reloadInterval = $v.reloadInterval;
      _buttons = $v.buttons?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant Widget other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Widget;
  }

  @override
  void update(void Function(WidgetBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Widget build() => _build();

  _$Widget _build() {
    _$Widget _$result;
    try {
      _$result = _$v ??
          _$Widget._(
              id: BuiltValueNullFieldError.checkNotNull(id, r'Widget', 'id'),
              title: BuiltValueNullFieldError.checkNotNull(title, r'Widget', 'title'),
              order: BuiltValueNullFieldError.checkNotNull(order, r'Widget', 'order'),
              iconClass: BuiltValueNullFieldError.checkNotNull(iconClass, r'Widget', 'iconClass'),
              iconUrl: BuiltValueNullFieldError.checkNotNull(iconUrl, r'Widget', 'iconUrl'),
              widgetUrl: widgetUrl,
              itemIconsRound: BuiltValueNullFieldError.checkNotNull(itemIconsRound, r'Widget', 'itemIconsRound'),
              itemApiVersions: _itemApiVersions?.build(),
              reloadInterval: reloadInterval,
              buttons: _buttons?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'itemApiVersions';
        _itemApiVersions?.build();

        _$failedField = 'buttons';
        _buttons?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'Widget', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $DashboardApiGetWidgetsResponseApplicationJson_OcsInterfaceBuilder {
  void replace($DashboardApiGetWidgetsResponseApplicationJson_OcsInterface other);
  void update(void Function($DashboardApiGetWidgetsResponseApplicationJson_OcsInterfaceBuilder) updates);
  OCSMetaBuilder get meta;
  set meta(OCSMetaBuilder? meta);

  MapBuilder<String, Widget> get data;
  set data(MapBuilder<String, Widget>? data);
}

class _$DashboardApiGetWidgetsResponseApplicationJson_Ocs extends DashboardApiGetWidgetsResponseApplicationJson_Ocs {
  @override
  final OCSMeta meta;
  @override
  final BuiltMap<String, Widget> data;

  factory _$DashboardApiGetWidgetsResponseApplicationJson_Ocs(
          [void Function(DashboardApiGetWidgetsResponseApplicationJson_OcsBuilder)? updates]) =>
      (DashboardApiGetWidgetsResponseApplicationJson_OcsBuilder()..update(updates))._build();

  _$DashboardApiGetWidgetsResponseApplicationJson_Ocs._({required this.meta, required this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(meta, r'DashboardApiGetWidgetsResponseApplicationJson_Ocs', 'meta');
    BuiltValueNullFieldError.checkNotNull(data, r'DashboardApiGetWidgetsResponseApplicationJson_Ocs', 'data');
  }

  @override
  DashboardApiGetWidgetsResponseApplicationJson_Ocs rebuild(
          void Function(DashboardApiGetWidgetsResponseApplicationJson_OcsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DashboardApiGetWidgetsResponseApplicationJson_OcsBuilder toBuilder() =>
      DashboardApiGetWidgetsResponseApplicationJson_OcsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DashboardApiGetWidgetsResponseApplicationJson_Ocs && meta == other.meta && data == other.data;
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
    return (newBuiltValueToStringHelper(r'DashboardApiGetWidgetsResponseApplicationJson_Ocs')
          ..add('meta', meta)
          ..add('data', data))
        .toString();
  }
}

class DashboardApiGetWidgetsResponseApplicationJson_OcsBuilder
    implements
        Builder<DashboardApiGetWidgetsResponseApplicationJson_Ocs,
            DashboardApiGetWidgetsResponseApplicationJson_OcsBuilder>,
        $DashboardApiGetWidgetsResponseApplicationJson_OcsInterfaceBuilder {
  _$DashboardApiGetWidgetsResponseApplicationJson_Ocs? _$v;

  OCSMetaBuilder? _meta;
  OCSMetaBuilder get meta => _$this._meta ??= OCSMetaBuilder();
  set meta(covariant OCSMetaBuilder? meta) => _$this._meta = meta;

  MapBuilder<String, Widget>? _data;
  MapBuilder<String, Widget> get data => _$this._data ??= MapBuilder<String, Widget>();
  set data(covariant MapBuilder<String, Widget>? data) => _$this._data = data;

  DashboardApiGetWidgetsResponseApplicationJson_OcsBuilder();

  DashboardApiGetWidgetsResponseApplicationJson_OcsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _meta = $v.meta.toBuilder();
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant DashboardApiGetWidgetsResponseApplicationJson_Ocs other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DashboardApiGetWidgetsResponseApplicationJson_Ocs;
  }

  @override
  void update(void Function(DashboardApiGetWidgetsResponseApplicationJson_OcsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DashboardApiGetWidgetsResponseApplicationJson_Ocs build() => _build();

  _$DashboardApiGetWidgetsResponseApplicationJson_Ocs _build() {
    _$DashboardApiGetWidgetsResponseApplicationJson_Ocs _$result;
    try {
      _$result = _$v ?? _$DashboardApiGetWidgetsResponseApplicationJson_Ocs._(meta: meta.build(), data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'meta';
        meta.build();
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DashboardApiGetWidgetsResponseApplicationJson_Ocs', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $DashboardApiGetWidgetsResponseApplicationJsonInterfaceBuilder {
  void replace($DashboardApiGetWidgetsResponseApplicationJsonInterface other);
  void update(void Function($DashboardApiGetWidgetsResponseApplicationJsonInterfaceBuilder) updates);
  DashboardApiGetWidgetsResponseApplicationJson_OcsBuilder get ocs;
  set ocs(DashboardApiGetWidgetsResponseApplicationJson_OcsBuilder? ocs);
}

class _$DashboardApiGetWidgetsResponseApplicationJson extends DashboardApiGetWidgetsResponseApplicationJson {
  @override
  final DashboardApiGetWidgetsResponseApplicationJson_Ocs ocs;

  factory _$DashboardApiGetWidgetsResponseApplicationJson(
          [void Function(DashboardApiGetWidgetsResponseApplicationJsonBuilder)? updates]) =>
      (DashboardApiGetWidgetsResponseApplicationJsonBuilder()..update(updates))._build();

  _$DashboardApiGetWidgetsResponseApplicationJson._({required this.ocs}) : super._() {
    BuiltValueNullFieldError.checkNotNull(ocs, r'DashboardApiGetWidgetsResponseApplicationJson', 'ocs');
  }

  @override
  DashboardApiGetWidgetsResponseApplicationJson rebuild(
          void Function(DashboardApiGetWidgetsResponseApplicationJsonBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DashboardApiGetWidgetsResponseApplicationJsonBuilder toBuilder() =>
      DashboardApiGetWidgetsResponseApplicationJsonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DashboardApiGetWidgetsResponseApplicationJson && ocs == other.ocs;
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
    return (newBuiltValueToStringHelper(r'DashboardApiGetWidgetsResponseApplicationJson')..add('ocs', ocs)).toString();
  }
}

class DashboardApiGetWidgetsResponseApplicationJsonBuilder
    implements
        Builder<DashboardApiGetWidgetsResponseApplicationJson, DashboardApiGetWidgetsResponseApplicationJsonBuilder>,
        $DashboardApiGetWidgetsResponseApplicationJsonInterfaceBuilder {
  _$DashboardApiGetWidgetsResponseApplicationJson? _$v;

  DashboardApiGetWidgetsResponseApplicationJson_OcsBuilder? _ocs;
  DashboardApiGetWidgetsResponseApplicationJson_OcsBuilder get ocs =>
      _$this._ocs ??= DashboardApiGetWidgetsResponseApplicationJson_OcsBuilder();
  set ocs(covariant DashboardApiGetWidgetsResponseApplicationJson_OcsBuilder? ocs) => _$this._ocs = ocs;

  DashboardApiGetWidgetsResponseApplicationJsonBuilder();

  DashboardApiGetWidgetsResponseApplicationJsonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ocs = $v.ocs.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant DashboardApiGetWidgetsResponseApplicationJson other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DashboardApiGetWidgetsResponseApplicationJson;
  }

  @override
  void update(void Function(DashboardApiGetWidgetsResponseApplicationJsonBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DashboardApiGetWidgetsResponseApplicationJson build() => _build();

  _$DashboardApiGetWidgetsResponseApplicationJson _build() {
    _$DashboardApiGetWidgetsResponseApplicationJson _$result;
    try {
      _$result = _$v ?? _$DashboardApiGetWidgetsResponseApplicationJson._(ocs: ocs.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ocs';
        ocs.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'DashboardApiGetWidgetsResponseApplicationJson', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $WidgetItemInterfaceBuilder {
  void replace($WidgetItemInterface other);
  void update(void Function($WidgetItemInterfaceBuilder) updates);
  String? get subtitle;
  set subtitle(String? subtitle);

  String? get title;
  set title(String? title);

  String? get link;
  set link(String? link);

  String? get iconUrl;
  set iconUrl(String? iconUrl);

  String? get overlayIconUrl;
  set overlayIconUrl(String? overlayIconUrl);

  String? get sinceId;
  set sinceId(String? sinceId);
}

class _$WidgetItem extends WidgetItem {
  @override
  final String subtitle;
  @override
  final String title;
  @override
  final String link;
  @override
  final String iconUrl;
  @override
  final String? overlayIconUrl;
  @override
  final String sinceId;

  factory _$WidgetItem([void Function(WidgetItemBuilder)? updates]) => (WidgetItemBuilder()..update(updates))._build();

  _$WidgetItem._(
      {required this.subtitle,
      required this.title,
      required this.link,
      required this.iconUrl,
      this.overlayIconUrl,
      required this.sinceId})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(subtitle, r'WidgetItem', 'subtitle');
    BuiltValueNullFieldError.checkNotNull(title, r'WidgetItem', 'title');
    BuiltValueNullFieldError.checkNotNull(link, r'WidgetItem', 'link');
    BuiltValueNullFieldError.checkNotNull(iconUrl, r'WidgetItem', 'iconUrl');
    BuiltValueNullFieldError.checkNotNull(sinceId, r'WidgetItem', 'sinceId');
  }

  @override
  WidgetItem rebuild(void Function(WidgetItemBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  WidgetItemBuilder toBuilder() => WidgetItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WidgetItem &&
        subtitle == other.subtitle &&
        title == other.title &&
        link == other.link &&
        iconUrl == other.iconUrl &&
        overlayIconUrl == other.overlayIconUrl &&
        sinceId == other.sinceId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, subtitle.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, link.hashCode);
    _$hash = $jc(_$hash, iconUrl.hashCode);
    _$hash = $jc(_$hash, overlayIconUrl.hashCode);
    _$hash = $jc(_$hash, sinceId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WidgetItem')
          ..add('subtitle', subtitle)
          ..add('title', title)
          ..add('link', link)
          ..add('iconUrl', iconUrl)
          ..add('overlayIconUrl', overlayIconUrl)
          ..add('sinceId', sinceId))
        .toString();
  }
}

class WidgetItemBuilder implements Builder<WidgetItem, WidgetItemBuilder>, $WidgetItemInterfaceBuilder {
  _$WidgetItem? _$v;

  String? _subtitle;
  String? get subtitle => _$this._subtitle;
  set subtitle(covariant String? subtitle) => _$this._subtitle = subtitle;

  String? _title;
  String? get title => _$this._title;
  set title(covariant String? title) => _$this._title = title;

  String? _link;
  String? get link => _$this._link;
  set link(covariant String? link) => _$this._link = link;

  String? _iconUrl;
  String? get iconUrl => _$this._iconUrl;
  set iconUrl(covariant String? iconUrl) => _$this._iconUrl = iconUrl;

  String? _overlayIconUrl;
  String? get overlayIconUrl => _$this._overlayIconUrl;
  set overlayIconUrl(covariant String? overlayIconUrl) => _$this._overlayIconUrl = overlayIconUrl;

  String? _sinceId;
  String? get sinceId => _$this._sinceId;
  set sinceId(covariant String? sinceId) => _$this._sinceId = sinceId;

  WidgetItemBuilder();

  WidgetItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _subtitle = $v.subtitle;
      _title = $v.title;
      _link = $v.link;
      _iconUrl = $v.iconUrl;
      _overlayIconUrl = $v.overlayIconUrl;
      _sinceId = $v.sinceId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant WidgetItem other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$WidgetItem;
  }

  @override
  void update(void Function(WidgetItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WidgetItem build() => _build();

  _$WidgetItem _build() {
    final _$result = _$v ??
        _$WidgetItem._(
            subtitle: BuiltValueNullFieldError.checkNotNull(subtitle, r'WidgetItem', 'subtitle'),
            title: BuiltValueNullFieldError.checkNotNull(title, r'WidgetItem', 'title'),
            link: BuiltValueNullFieldError.checkNotNull(link, r'WidgetItem', 'link'),
            iconUrl: BuiltValueNullFieldError.checkNotNull(iconUrl, r'WidgetItem', 'iconUrl'),
            overlayIconUrl: overlayIconUrl,
            sinceId: BuiltValueNullFieldError.checkNotNull(sinceId, r'WidgetItem', 'sinceId'));
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $DashboardApiGetWidgetItemsResponseApplicationJson_OcsInterfaceBuilder {
  void replace($DashboardApiGetWidgetItemsResponseApplicationJson_OcsInterface other);
  void update(void Function($DashboardApiGetWidgetItemsResponseApplicationJson_OcsInterfaceBuilder) updates);
  OCSMetaBuilder get meta;
  set meta(OCSMetaBuilder? meta);

  MapBuilder<String, BuiltList<WidgetItem>> get data;
  set data(MapBuilder<String, BuiltList<WidgetItem>>? data);
}

class _$DashboardApiGetWidgetItemsResponseApplicationJson_Ocs
    extends DashboardApiGetWidgetItemsResponseApplicationJson_Ocs {
  @override
  final OCSMeta meta;
  @override
  final BuiltMap<String, BuiltList<WidgetItem>> data;

  factory _$DashboardApiGetWidgetItemsResponseApplicationJson_Ocs(
          [void Function(DashboardApiGetWidgetItemsResponseApplicationJson_OcsBuilder)? updates]) =>
      (DashboardApiGetWidgetItemsResponseApplicationJson_OcsBuilder()..update(updates))._build();

  _$DashboardApiGetWidgetItemsResponseApplicationJson_Ocs._({required this.meta, required this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(meta, r'DashboardApiGetWidgetItemsResponseApplicationJson_Ocs', 'meta');
    BuiltValueNullFieldError.checkNotNull(data, r'DashboardApiGetWidgetItemsResponseApplicationJson_Ocs', 'data');
  }

  @override
  DashboardApiGetWidgetItemsResponseApplicationJson_Ocs rebuild(
          void Function(DashboardApiGetWidgetItemsResponseApplicationJson_OcsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DashboardApiGetWidgetItemsResponseApplicationJson_OcsBuilder toBuilder() =>
      DashboardApiGetWidgetItemsResponseApplicationJson_OcsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DashboardApiGetWidgetItemsResponseApplicationJson_Ocs && meta == other.meta && data == other.data;
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
    return (newBuiltValueToStringHelper(r'DashboardApiGetWidgetItemsResponseApplicationJson_Ocs')
          ..add('meta', meta)
          ..add('data', data))
        .toString();
  }
}

class DashboardApiGetWidgetItemsResponseApplicationJson_OcsBuilder
    implements
        Builder<DashboardApiGetWidgetItemsResponseApplicationJson_Ocs,
            DashboardApiGetWidgetItemsResponseApplicationJson_OcsBuilder>,
        $DashboardApiGetWidgetItemsResponseApplicationJson_OcsInterfaceBuilder {
  _$DashboardApiGetWidgetItemsResponseApplicationJson_Ocs? _$v;

  OCSMetaBuilder? _meta;
  OCSMetaBuilder get meta => _$this._meta ??= OCSMetaBuilder();
  set meta(covariant OCSMetaBuilder? meta) => _$this._meta = meta;

  MapBuilder<String, BuiltList<WidgetItem>>? _data;
  MapBuilder<String, BuiltList<WidgetItem>> get data => _$this._data ??= MapBuilder<String, BuiltList<WidgetItem>>();
  set data(covariant MapBuilder<String, BuiltList<WidgetItem>>? data) => _$this._data = data;

  DashboardApiGetWidgetItemsResponseApplicationJson_OcsBuilder();

  DashboardApiGetWidgetItemsResponseApplicationJson_OcsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _meta = $v.meta.toBuilder();
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant DashboardApiGetWidgetItemsResponseApplicationJson_Ocs other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DashboardApiGetWidgetItemsResponseApplicationJson_Ocs;
  }

  @override
  void update(void Function(DashboardApiGetWidgetItemsResponseApplicationJson_OcsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DashboardApiGetWidgetItemsResponseApplicationJson_Ocs build() => _build();

  _$DashboardApiGetWidgetItemsResponseApplicationJson_Ocs _build() {
    _$DashboardApiGetWidgetItemsResponseApplicationJson_Ocs _$result;
    try {
      _$result =
          _$v ?? _$DashboardApiGetWidgetItemsResponseApplicationJson_Ocs._(meta: meta.build(), data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'meta';
        meta.build();
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DashboardApiGetWidgetItemsResponseApplicationJson_Ocs', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $DashboardApiGetWidgetItemsResponseApplicationJsonInterfaceBuilder {
  void replace($DashboardApiGetWidgetItemsResponseApplicationJsonInterface other);
  void update(void Function($DashboardApiGetWidgetItemsResponseApplicationJsonInterfaceBuilder) updates);
  DashboardApiGetWidgetItemsResponseApplicationJson_OcsBuilder get ocs;
  set ocs(DashboardApiGetWidgetItemsResponseApplicationJson_OcsBuilder? ocs);
}

class _$DashboardApiGetWidgetItemsResponseApplicationJson extends DashboardApiGetWidgetItemsResponseApplicationJson {
  @override
  final DashboardApiGetWidgetItemsResponseApplicationJson_Ocs ocs;

  factory _$DashboardApiGetWidgetItemsResponseApplicationJson(
          [void Function(DashboardApiGetWidgetItemsResponseApplicationJsonBuilder)? updates]) =>
      (DashboardApiGetWidgetItemsResponseApplicationJsonBuilder()..update(updates))._build();

  _$DashboardApiGetWidgetItemsResponseApplicationJson._({required this.ocs}) : super._() {
    BuiltValueNullFieldError.checkNotNull(ocs, r'DashboardApiGetWidgetItemsResponseApplicationJson', 'ocs');
  }

  @override
  DashboardApiGetWidgetItemsResponseApplicationJson rebuild(
          void Function(DashboardApiGetWidgetItemsResponseApplicationJsonBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DashboardApiGetWidgetItemsResponseApplicationJsonBuilder toBuilder() =>
      DashboardApiGetWidgetItemsResponseApplicationJsonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DashboardApiGetWidgetItemsResponseApplicationJson && ocs == other.ocs;
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
    return (newBuiltValueToStringHelper(r'DashboardApiGetWidgetItemsResponseApplicationJson')..add('ocs', ocs))
        .toString();
  }
}

class DashboardApiGetWidgetItemsResponseApplicationJsonBuilder
    implements
        Builder<DashboardApiGetWidgetItemsResponseApplicationJson,
            DashboardApiGetWidgetItemsResponseApplicationJsonBuilder>,
        $DashboardApiGetWidgetItemsResponseApplicationJsonInterfaceBuilder {
  _$DashboardApiGetWidgetItemsResponseApplicationJson? _$v;

  DashboardApiGetWidgetItemsResponseApplicationJson_OcsBuilder? _ocs;
  DashboardApiGetWidgetItemsResponseApplicationJson_OcsBuilder get ocs =>
      _$this._ocs ??= DashboardApiGetWidgetItemsResponseApplicationJson_OcsBuilder();
  set ocs(covariant DashboardApiGetWidgetItemsResponseApplicationJson_OcsBuilder? ocs) => _$this._ocs = ocs;

  DashboardApiGetWidgetItemsResponseApplicationJsonBuilder();

  DashboardApiGetWidgetItemsResponseApplicationJsonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ocs = $v.ocs.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant DashboardApiGetWidgetItemsResponseApplicationJson other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DashboardApiGetWidgetItemsResponseApplicationJson;
  }

  @override
  void update(void Function(DashboardApiGetWidgetItemsResponseApplicationJsonBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DashboardApiGetWidgetItemsResponseApplicationJson build() => _build();

  _$DashboardApiGetWidgetItemsResponseApplicationJson _build() {
    _$DashboardApiGetWidgetItemsResponseApplicationJson _$result;
    try {
      _$result = _$v ?? _$DashboardApiGetWidgetItemsResponseApplicationJson._(ocs: ocs.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ocs';
        ocs.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DashboardApiGetWidgetItemsResponseApplicationJson', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $WidgetItemsInterfaceBuilder {
  void replace($WidgetItemsInterface other);
  void update(void Function($WidgetItemsInterfaceBuilder) updates);
  ListBuilder<WidgetItem> get items;
  set items(ListBuilder<WidgetItem>? items);

  String? get emptyContentMessage;
  set emptyContentMessage(String? emptyContentMessage);

  String? get halfEmptyContentMessage;
  set halfEmptyContentMessage(String? halfEmptyContentMessage);
}

class _$WidgetItems extends WidgetItems {
  @override
  final BuiltList<WidgetItem> items;
  @override
  final String emptyContentMessage;
  @override
  final String halfEmptyContentMessage;

  factory _$WidgetItems([void Function(WidgetItemsBuilder)? updates]) =>
      (WidgetItemsBuilder()..update(updates))._build();

  _$WidgetItems._({required this.items, required this.emptyContentMessage, required this.halfEmptyContentMessage})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(items, r'WidgetItems', 'items');
    BuiltValueNullFieldError.checkNotNull(emptyContentMessage, r'WidgetItems', 'emptyContentMessage');
    BuiltValueNullFieldError.checkNotNull(halfEmptyContentMessage, r'WidgetItems', 'halfEmptyContentMessage');
  }

  @override
  WidgetItems rebuild(void Function(WidgetItemsBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  WidgetItemsBuilder toBuilder() => WidgetItemsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WidgetItems &&
        items == other.items &&
        emptyContentMessage == other.emptyContentMessage &&
        halfEmptyContentMessage == other.halfEmptyContentMessage;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, emptyContentMessage.hashCode);
    _$hash = $jc(_$hash, halfEmptyContentMessage.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WidgetItems')
          ..add('items', items)
          ..add('emptyContentMessage', emptyContentMessage)
          ..add('halfEmptyContentMessage', halfEmptyContentMessage))
        .toString();
  }
}

class WidgetItemsBuilder implements Builder<WidgetItems, WidgetItemsBuilder>, $WidgetItemsInterfaceBuilder {
  _$WidgetItems? _$v;

  ListBuilder<WidgetItem>? _items;
  ListBuilder<WidgetItem> get items => _$this._items ??= ListBuilder<WidgetItem>();
  set items(covariant ListBuilder<WidgetItem>? items) => _$this._items = items;

  String? _emptyContentMessage;
  String? get emptyContentMessage => _$this._emptyContentMessage;
  set emptyContentMessage(covariant String? emptyContentMessage) => _$this._emptyContentMessage = emptyContentMessage;

  String? _halfEmptyContentMessage;
  String? get halfEmptyContentMessage => _$this._halfEmptyContentMessage;
  set halfEmptyContentMessage(covariant String? halfEmptyContentMessage) =>
      _$this._halfEmptyContentMessage = halfEmptyContentMessage;

  WidgetItemsBuilder();

  WidgetItemsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _emptyContentMessage = $v.emptyContentMessage;
      _halfEmptyContentMessage = $v.halfEmptyContentMessage;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant WidgetItems other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$WidgetItems;
  }

  @override
  void update(void Function(WidgetItemsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WidgetItems build() => _build();

  _$WidgetItems _build() {
    _$WidgetItems _$result;
    try {
      _$result = _$v ??
          _$WidgetItems._(
              items: items.build(),
              emptyContentMessage:
                  BuiltValueNullFieldError.checkNotNull(emptyContentMessage, r'WidgetItems', 'emptyContentMessage'),
              halfEmptyContentMessage: BuiltValueNullFieldError.checkNotNull(
                  halfEmptyContentMessage, r'WidgetItems', 'halfEmptyContentMessage'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'WidgetItems', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $DashboardApiGetWidgetItemsV2ResponseApplicationJson_OcsInterfaceBuilder {
  void replace($DashboardApiGetWidgetItemsV2ResponseApplicationJson_OcsInterface other);
  void update(void Function($DashboardApiGetWidgetItemsV2ResponseApplicationJson_OcsInterfaceBuilder) updates);
  OCSMetaBuilder get meta;
  set meta(OCSMetaBuilder? meta);

  MapBuilder<String, WidgetItems> get data;
  set data(MapBuilder<String, WidgetItems>? data);
}

class _$DashboardApiGetWidgetItemsV2ResponseApplicationJson_Ocs
    extends DashboardApiGetWidgetItemsV2ResponseApplicationJson_Ocs {
  @override
  final OCSMeta meta;
  @override
  final BuiltMap<String, WidgetItems> data;

  factory _$DashboardApiGetWidgetItemsV2ResponseApplicationJson_Ocs(
          [void Function(DashboardApiGetWidgetItemsV2ResponseApplicationJson_OcsBuilder)? updates]) =>
      (DashboardApiGetWidgetItemsV2ResponseApplicationJson_OcsBuilder()..update(updates))._build();

  _$DashboardApiGetWidgetItemsV2ResponseApplicationJson_Ocs._({required this.meta, required this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(meta, r'DashboardApiGetWidgetItemsV2ResponseApplicationJson_Ocs', 'meta');
    BuiltValueNullFieldError.checkNotNull(data, r'DashboardApiGetWidgetItemsV2ResponseApplicationJson_Ocs', 'data');
  }

  @override
  DashboardApiGetWidgetItemsV2ResponseApplicationJson_Ocs rebuild(
          void Function(DashboardApiGetWidgetItemsV2ResponseApplicationJson_OcsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DashboardApiGetWidgetItemsV2ResponseApplicationJson_OcsBuilder toBuilder() =>
      DashboardApiGetWidgetItemsV2ResponseApplicationJson_OcsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DashboardApiGetWidgetItemsV2ResponseApplicationJson_Ocs && meta == other.meta && data == other.data;
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
    return (newBuiltValueToStringHelper(r'DashboardApiGetWidgetItemsV2ResponseApplicationJson_Ocs')
          ..add('meta', meta)
          ..add('data', data))
        .toString();
  }
}

class DashboardApiGetWidgetItemsV2ResponseApplicationJson_OcsBuilder
    implements
        Builder<DashboardApiGetWidgetItemsV2ResponseApplicationJson_Ocs,
            DashboardApiGetWidgetItemsV2ResponseApplicationJson_OcsBuilder>,
        $DashboardApiGetWidgetItemsV2ResponseApplicationJson_OcsInterfaceBuilder {
  _$DashboardApiGetWidgetItemsV2ResponseApplicationJson_Ocs? _$v;

  OCSMetaBuilder? _meta;
  OCSMetaBuilder get meta => _$this._meta ??= OCSMetaBuilder();
  set meta(covariant OCSMetaBuilder? meta) => _$this._meta = meta;

  MapBuilder<String, WidgetItems>? _data;
  MapBuilder<String, WidgetItems> get data => _$this._data ??= MapBuilder<String, WidgetItems>();
  set data(covariant MapBuilder<String, WidgetItems>? data) => _$this._data = data;

  DashboardApiGetWidgetItemsV2ResponseApplicationJson_OcsBuilder();

  DashboardApiGetWidgetItemsV2ResponseApplicationJson_OcsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _meta = $v.meta.toBuilder();
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant DashboardApiGetWidgetItemsV2ResponseApplicationJson_Ocs other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DashboardApiGetWidgetItemsV2ResponseApplicationJson_Ocs;
  }

  @override
  void update(void Function(DashboardApiGetWidgetItemsV2ResponseApplicationJson_OcsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DashboardApiGetWidgetItemsV2ResponseApplicationJson_Ocs build() => _build();

  _$DashboardApiGetWidgetItemsV2ResponseApplicationJson_Ocs _build() {
    _$DashboardApiGetWidgetItemsV2ResponseApplicationJson_Ocs _$result;
    try {
      _$result =
          _$v ?? _$DashboardApiGetWidgetItemsV2ResponseApplicationJson_Ocs._(meta: meta.build(), data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'meta';
        meta.build();
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DashboardApiGetWidgetItemsV2ResponseApplicationJson_Ocs', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $DashboardApiGetWidgetItemsV2ResponseApplicationJsonInterfaceBuilder {
  void replace($DashboardApiGetWidgetItemsV2ResponseApplicationJsonInterface other);
  void update(void Function($DashboardApiGetWidgetItemsV2ResponseApplicationJsonInterfaceBuilder) updates);
  DashboardApiGetWidgetItemsV2ResponseApplicationJson_OcsBuilder get ocs;
  set ocs(DashboardApiGetWidgetItemsV2ResponseApplicationJson_OcsBuilder? ocs);
}

class _$DashboardApiGetWidgetItemsV2ResponseApplicationJson
    extends DashboardApiGetWidgetItemsV2ResponseApplicationJson {
  @override
  final DashboardApiGetWidgetItemsV2ResponseApplicationJson_Ocs ocs;

  factory _$DashboardApiGetWidgetItemsV2ResponseApplicationJson(
          [void Function(DashboardApiGetWidgetItemsV2ResponseApplicationJsonBuilder)? updates]) =>
      (DashboardApiGetWidgetItemsV2ResponseApplicationJsonBuilder()..update(updates))._build();

  _$DashboardApiGetWidgetItemsV2ResponseApplicationJson._({required this.ocs}) : super._() {
    BuiltValueNullFieldError.checkNotNull(ocs, r'DashboardApiGetWidgetItemsV2ResponseApplicationJson', 'ocs');
  }

  @override
  DashboardApiGetWidgetItemsV2ResponseApplicationJson rebuild(
          void Function(DashboardApiGetWidgetItemsV2ResponseApplicationJsonBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DashboardApiGetWidgetItemsV2ResponseApplicationJsonBuilder toBuilder() =>
      DashboardApiGetWidgetItemsV2ResponseApplicationJsonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DashboardApiGetWidgetItemsV2ResponseApplicationJson && ocs == other.ocs;
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
    return (newBuiltValueToStringHelper(r'DashboardApiGetWidgetItemsV2ResponseApplicationJson')..add('ocs', ocs))
        .toString();
  }
}

class DashboardApiGetWidgetItemsV2ResponseApplicationJsonBuilder
    implements
        Builder<DashboardApiGetWidgetItemsV2ResponseApplicationJson,
            DashboardApiGetWidgetItemsV2ResponseApplicationJsonBuilder>,
        $DashboardApiGetWidgetItemsV2ResponseApplicationJsonInterfaceBuilder {
  _$DashboardApiGetWidgetItemsV2ResponseApplicationJson? _$v;

  DashboardApiGetWidgetItemsV2ResponseApplicationJson_OcsBuilder? _ocs;
  DashboardApiGetWidgetItemsV2ResponseApplicationJson_OcsBuilder get ocs =>
      _$this._ocs ??= DashboardApiGetWidgetItemsV2ResponseApplicationJson_OcsBuilder();
  set ocs(covariant DashboardApiGetWidgetItemsV2ResponseApplicationJson_OcsBuilder? ocs) => _$this._ocs = ocs;

  DashboardApiGetWidgetItemsV2ResponseApplicationJsonBuilder();

  DashboardApiGetWidgetItemsV2ResponseApplicationJsonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ocs = $v.ocs.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant DashboardApiGetWidgetItemsV2ResponseApplicationJson other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DashboardApiGetWidgetItemsV2ResponseApplicationJson;
  }

  @override
  void update(void Function(DashboardApiGetWidgetItemsV2ResponseApplicationJsonBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DashboardApiGetWidgetItemsV2ResponseApplicationJson build() => _build();

  _$DashboardApiGetWidgetItemsV2ResponseApplicationJson _build() {
    _$DashboardApiGetWidgetItemsV2ResponseApplicationJson _$result;
    try {
      _$result = _$v ?? _$DashboardApiGetWidgetItemsV2ResponseApplicationJson._(ocs: ocs.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ocs';
        ocs.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DashboardApiGetWidgetItemsV2ResponseApplicationJson', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
