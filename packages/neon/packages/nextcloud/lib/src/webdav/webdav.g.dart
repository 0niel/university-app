// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'webdav.dart';

// **************************************************************************
// XmlSerializableGenerator
// **************************************************************************

void _$WebDavMultistatusBuildXmlChildren(WebDavMultistatus instance, XmlBuilder builder,
    {Map<String, String> namespaces = const {}}) {
  final responses = instance.responses;
  final responsesSerialized = responses;
  for (final value in responsesSerialized) {
    builder.element('response', namespace: 'DAV:', nest: () {
      value.buildXmlChildren(builder, namespaces: namespaces);
    });
  }
}

void _$WebDavMultistatusBuildXmlElement(WebDavMultistatus instance, XmlBuilder builder,
    {Map<String, String> namespaces = const {}}) {
  builder.element('multistatus', namespace: 'DAV:', namespaces: namespaces, nest: () {
    instance.buildXmlChildren(builder, namespaces: namespaces);
  });
}

WebDavMultistatus _$WebDavMultistatusFromXmlElement(XmlElement element) {
  final responses = element.getElements('response', namespace: 'DAV:')!;
  return WebDavMultistatus(responses: responses.map((e) => WebDavResponse.fromXmlElement(e)).toList());
}

List<XmlAttribute> _$WebDavMultistatusToXmlAttributes(WebDavMultistatus instance,
    {Map<String, String?> namespaces = const {}}) {
  final attributes = <XmlAttribute>[];
  return attributes;
}

List<XmlNode> _$WebDavMultistatusToXmlChildren(WebDavMultistatus instance,
    {Map<String, String?> namespaces = const {}}) {
  final children = <XmlNode>[];
  final responses = instance.responses;
  final responsesSerialized = responses;
  final responsesConstructed = responsesSerialized.map((e) => XmlElement(XmlName('response', namespaces['DAV:']),
      e.toXmlAttributes(namespaces: namespaces), e.toXmlChildren(namespaces: namespaces)));
  children.addAll(responsesConstructed);
  return children;
}

XmlElement _$WebDavMultistatusToXmlElement(WebDavMultistatus instance, {Map<String, String?> namespaces = const {}}) {
  return XmlElement(
      XmlName('multistatus', namespaces['DAV:']),
      [...namespaces.toXmlAttributes(), ...instance.toXmlAttributes(namespaces: namespaces)],
      instance.toXmlChildren(namespaces: namespaces));
}

mixin _$WebDavMultistatusXmlSerializableMixin {
  void buildXmlChildren(XmlBuilder builder, {Map<String, String> namespaces = const {}}) =>
      _$WebDavMultistatusBuildXmlChildren(this as WebDavMultistatus, builder, namespaces: namespaces);

  void buildXmlElement(XmlBuilder builder, {Map<String, String> namespaces = const {}}) =>
      _$WebDavMultistatusBuildXmlElement(this as WebDavMultistatus, builder, namespaces: namespaces);

  List<XmlAttribute> toXmlAttributes({Map<String, String?> namespaces = const {}}) =>
      _$WebDavMultistatusToXmlAttributes(this as WebDavMultistatus, namespaces: namespaces);

  List<XmlNode> toXmlChildren({Map<String, String?> namespaces = const {}}) =>
      _$WebDavMultistatusToXmlChildren(this as WebDavMultistatus, namespaces: namespaces);

  XmlElement toXmlElement({Map<String, String?> namespaces = const {}}) =>
      _$WebDavMultistatusToXmlElement(this as WebDavMultistatus, namespaces: namespaces);
}

void _$WebDavResponseBuildXmlChildren(WebDavResponse instance, XmlBuilder builder,
    {Map<String, String> namespaces = const {}}) {
  final href = instance.href;
  final hrefSerialized = href;
  builder.element('href', namespace: 'DAV:', nest: () {
    if (hrefSerialized != null) {
      builder.text(hrefSerialized);
    }
  });
  final propstats = instance.propstats;
  final propstatsSerialized = propstats;
  for (final value in propstatsSerialized) {
    builder.element('propstat', namespace: 'DAV:', nest: () {
      value.buildXmlChildren(builder, namespaces: namespaces);
    });
  }
}

void _$WebDavResponseBuildXmlElement(WebDavResponse instance, XmlBuilder builder,
    {Map<String, String> namespaces = const {}}) {
  builder.element('response', namespace: 'DAV:', namespaces: namespaces, nest: () {
    instance.buildXmlChildren(builder, namespaces: namespaces);
  });
}

WebDavResponse _$WebDavResponseFromXmlElement(XmlElement element) {
  final href = element.getElement('href', namespace: 'DAV:')?.getText();
  final propstats = element.getElements('propstat', namespace: 'DAV:')!;
  return WebDavResponse(href: href, propstats: propstats.map((e) => WebDavPropstat.fromXmlElement(e)).toList());
}

List<XmlAttribute> _$WebDavResponseToXmlAttributes(WebDavResponse instance,
    {Map<String, String?> namespaces = const {}}) {
  final attributes = <XmlAttribute>[];
  return attributes;
}

List<XmlNode> _$WebDavResponseToXmlChildren(WebDavResponse instance, {Map<String, String?> namespaces = const {}}) {
  final children = <XmlNode>[];
  final href = instance.href;
  final hrefSerialized = href;
  final hrefConstructed =
      XmlElement(XmlName('href', namespaces['DAV:']), [], hrefSerialized != null ? [XmlText(hrefSerialized)] : []);
  children.add(hrefConstructed);
  final propstats = instance.propstats;
  final propstatsSerialized = propstats;
  final propstatsConstructed = propstatsSerialized.map((e) => XmlElement(XmlName('propstat', namespaces['DAV:']),
      e.toXmlAttributes(namespaces: namespaces), e.toXmlChildren(namespaces: namespaces)));
  children.addAll(propstatsConstructed);
  return children;
}

XmlElement _$WebDavResponseToXmlElement(WebDavResponse instance, {Map<String, String?> namespaces = const {}}) {
  return XmlElement(
      XmlName('response', namespaces['DAV:']),
      [...namespaces.toXmlAttributes(), ...instance.toXmlAttributes(namespaces: namespaces)],
      instance.toXmlChildren(namespaces: namespaces));
}

mixin _$WebDavResponseXmlSerializableMixin {
  void buildXmlChildren(XmlBuilder builder, {Map<String, String> namespaces = const {}}) =>
      _$WebDavResponseBuildXmlChildren(this as WebDavResponse, builder, namespaces: namespaces);

  void buildXmlElement(XmlBuilder builder, {Map<String, String> namespaces = const {}}) =>
      _$WebDavResponseBuildXmlElement(this as WebDavResponse, builder, namespaces: namespaces);

  List<XmlAttribute> toXmlAttributes({Map<String, String?> namespaces = const {}}) =>
      _$WebDavResponseToXmlAttributes(this as WebDavResponse, namespaces: namespaces);

  List<XmlNode> toXmlChildren({Map<String, String?> namespaces = const {}}) =>
      _$WebDavResponseToXmlChildren(this as WebDavResponse, namespaces: namespaces);

  XmlElement toXmlElement({Map<String, String?> namespaces = const {}}) =>
      _$WebDavResponseToXmlElement(this as WebDavResponse, namespaces: namespaces);
}

void _$WebDavPropstatBuildXmlChildren(WebDavPropstat instance, XmlBuilder builder,
    {Map<String, String> namespaces = const {}}) {
  final status = instance.status;
  final statusSerialized = status;
  builder.element('status', namespace: 'DAV:', nest: () {
    builder.text(statusSerialized);
  });
  final prop = instance.prop;
  final propSerialized = prop;
  builder.element('prop', namespace: 'DAV:', nest: () {
    propSerialized.buildXmlChildren(builder, namespaces: namespaces);
  });
}

void _$WebDavPropstatBuildXmlElement(WebDavPropstat instance, XmlBuilder builder,
    {Map<String, String> namespaces = const {}}) {
  builder.element('propstat', namespace: 'DAV:', namespaces: namespaces, nest: () {
    instance.buildXmlChildren(builder, namespaces: namespaces);
  });
}

WebDavPropstat _$WebDavPropstatFromXmlElement(XmlElement element) {
  final status = element.getElement('status', namespace: 'DAV:')!.getText()!;
  final prop = element.getElement('prop', namespace: 'DAV:')!;
  return WebDavPropstat(status: status, prop: WebDavProp.fromXmlElement(prop));
}

List<XmlAttribute> _$WebDavPropstatToXmlAttributes(WebDavPropstat instance,
    {Map<String, String?> namespaces = const {}}) {
  final attributes = <XmlAttribute>[];
  return attributes;
}

List<XmlNode> _$WebDavPropstatToXmlChildren(WebDavPropstat instance, {Map<String, String?> namespaces = const {}}) {
  final children = <XmlNode>[];
  final status = instance.status;
  final statusSerialized = status;
  final statusConstructed = XmlElement(XmlName('status', namespaces['DAV:']), [], [XmlText(statusSerialized)]);
  children.add(statusConstructed);
  final prop = instance.prop;
  final propSerialized = prop;
  final propConstructed = XmlElement(XmlName('prop', namespaces['DAV:']),
      propSerialized.toXmlAttributes(namespaces: namespaces), propSerialized.toXmlChildren(namespaces: namespaces));
  children.add(propConstructed);
  return children;
}

XmlElement _$WebDavPropstatToXmlElement(WebDavPropstat instance, {Map<String, String?> namespaces = const {}}) {
  return XmlElement(
      XmlName('propstat', namespaces['DAV:']),
      [...namespaces.toXmlAttributes(), ...instance.toXmlAttributes(namespaces: namespaces)],
      instance.toXmlChildren(namespaces: namespaces));
}

mixin _$WebDavPropstatXmlSerializableMixin {
  void buildXmlChildren(XmlBuilder builder, {Map<String, String> namespaces = const {}}) =>
      _$WebDavPropstatBuildXmlChildren(this as WebDavPropstat, builder, namespaces: namespaces);

  void buildXmlElement(XmlBuilder builder, {Map<String, String> namespaces = const {}}) =>
      _$WebDavPropstatBuildXmlElement(this as WebDavPropstat, builder, namespaces: namespaces);

  List<XmlAttribute> toXmlAttributes({Map<String, String?> namespaces = const {}}) =>
      _$WebDavPropstatToXmlAttributes(this as WebDavPropstat, namespaces: namespaces);

  List<XmlNode> toXmlChildren({Map<String, String?> namespaces = const {}}) =>
      _$WebDavPropstatToXmlChildren(this as WebDavPropstat, namespaces: namespaces);

  XmlElement toXmlElement({Map<String, String?> namespaces = const {}}) =>
      _$WebDavPropstatToXmlElement(this as WebDavPropstat, namespaces: namespaces);
}

void _$WebDavPropertyupdateBuildXmlChildren(WebDavPropertyupdate instance, XmlBuilder builder,
    {Map<String, String> namespaces = const {}}) {
  final set = instance.set;
  final setSerialized = set;
  if (setSerialized != null) {
    builder.element('set', namespace: 'DAV:', nest: () {
      setSerialized.buildXmlChildren(builder, namespaces: namespaces);
    });
  }
  final remove = instance.remove;
  final removeSerialized = remove;
  if (removeSerialized != null) {
    builder.element('remove', namespace: 'DAV:', nest: () {
      removeSerialized.buildXmlChildren(builder, namespaces: namespaces);
    });
  }
}

void _$WebDavPropertyupdateBuildXmlElement(WebDavPropertyupdate instance, XmlBuilder builder,
    {Map<String, String> namespaces = const {}}) {
  builder.element('propertyupdate', namespace: 'DAV:', namespaces: namespaces, nest: () {
    instance.buildXmlChildren(builder, namespaces: namespaces);
  });
}

WebDavPropertyupdate _$WebDavPropertyupdateFromXmlElement(XmlElement element) {
  final set = element.getElement('set', namespace: 'DAV:');
  final remove = element.getElement('remove', namespace: 'DAV:');
  return WebDavPropertyupdate(
      set: set != null ? WebDavSet.fromXmlElement(set) : null,
      remove: remove != null ? WebDavRemove.fromXmlElement(remove) : null);
}

List<XmlAttribute> _$WebDavPropertyupdateToXmlAttributes(WebDavPropertyupdate instance,
    {Map<String, String?> namespaces = const {}}) {
  final attributes = <XmlAttribute>[];
  return attributes;
}

List<XmlNode> _$WebDavPropertyupdateToXmlChildren(WebDavPropertyupdate instance,
    {Map<String, String?> namespaces = const {}}) {
  final children = <XmlNode>[];
  final set = instance.set;
  final setSerialized = set;
  final setConstructed = setSerialized != null
      ? XmlElement(XmlName('set', namespaces['DAV:']), setSerialized.toXmlAttributes(namespaces: namespaces),
          setSerialized.toXmlChildren(namespaces: namespaces))
      : null;
  if (setConstructed != null) {
    children.add(setConstructed);
  }
  final remove = instance.remove;
  final removeSerialized = remove;
  final removeConstructed = removeSerialized != null
      ? XmlElement(XmlName('remove', namespaces['DAV:']), removeSerialized.toXmlAttributes(namespaces: namespaces),
          removeSerialized.toXmlChildren(namespaces: namespaces))
      : null;
  if (removeConstructed != null) {
    children.add(removeConstructed);
  }
  return children;
}

XmlElement _$WebDavPropertyupdateToXmlElement(WebDavPropertyupdate instance,
    {Map<String, String?> namespaces = const {}}) {
  return XmlElement(
      XmlName('propertyupdate', namespaces['DAV:']),
      [...namespaces.toXmlAttributes(), ...instance.toXmlAttributes(namespaces: namespaces)],
      instance.toXmlChildren(namespaces: namespaces));
}

mixin _$WebDavPropertyupdateXmlSerializableMixin {
  void buildXmlChildren(XmlBuilder builder, {Map<String, String> namespaces = const {}}) =>
      _$WebDavPropertyupdateBuildXmlChildren(this as WebDavPropertyupdate, builder, namespaces: namespaces);

  void buildXmlElement(XmlBuilder builder, {Map<String, String> namespaces = const {}}) =>
      _$WebDavPropertyupdateBuildXmlElement(this as WebDavPropertyupdate, builder, namespaces: namespaces);

  List<XmlAttribute> toXmlAttributes({Map<String, String?> namespaces = const {}}) =>
      _$WebDavPropertyupdateToXmlAttributes(this as WebDavPropertyupdate, namespaces: namespaces);

  List<XmlNode> toXmlChildren({Map<String, String?> namespaces = const {}}) =>
      _$WebDavPropertyupdateToXmlChildren(this as WebDavPropertyupdate, namespaces: namespaces);

  XmlElement toXmlElement({Map<String, String?> namespaces = const {}}) =>
      _$WebDavPropertyupdateToXmlElement(this as WebDavPropertyupdate, namespaces: namespaces);
}

void _$WebDavSetBuildXmlChildren(WebDavSet instance, XmlBuilder builder, {Map<String, String> namespaces = const {}}) {
  final prop = instance.prop;
  final propSerialized = prop;
  builder.element('prop', namespace: 'DAV:', nest: () {
    propSerialized.buildXmlChildren(builder, namespaces: namespaces);
  });
}

void _$WebDavSetBuildXmlElement(WebDavSet instance, XmlBuilder builder, {Map<String, String> namespaces = const {}}) {
  builder.element('set', namespace: 'DAV:', namespaces: namespaces, nest: () {
    instance.buildXmlChildren(builder, namespaces: namespaces);
  });
}

WebDavSet _$WebDavSetFromXmlElement(XmlElement element) {
  final prop = element.getElement('prop', namespace: 'DAV:')!;
  return WebDavSet(prop: WebDavProp.fromXmlElement(prop));
}

List<XmlAttribute> _$WebDavSetToXmlAttributes(WebDavSet instance, {Map<String, String?> namespaces = const {}}) {
  final attributes = <XmlAttribute>[];
  return attributes;
}

List<XmlNode> _$WebDavSetToXmlChildren(WebDavSet instance, {Map<String, String?> namespaces = const {}}) {
  final children = <XmlNode>[];
  final prop = instance.prop;
  final propSerialized = prop;
  final propConstructed = XmlElement(XmlName('prop', namespaces['DAV:']),
      propSerialized.toXmlAttributes(namespaces: namespaces), propSerialized.toXmlChildren(namespaces: namespaces));
  children.add(propConstructed);
  return children;
}

XmlElement _$WebDavSetToXmlElement(WebDavSet instance, {Map<String, String?> namespaces = const {}}) {
  return XmlElement(
      XmlName('set', namespaces['DAV:']),
      [...namespaces.toXmlAttributes(), ...instance.toXmlAttributes(namespaces: namespaces)],
      instance.toXmlChildren(namespaces: namespaces));
}

mixin _$WebDavSetXmlSerializableMixin {
  void buildXmlChildren(XmlBuilder builder, {Map<String, String> namespaces = const {}}) =>
      _$WebDavSetBuildXmlChildren(this as WebDavSet, builder, namespaces: namespaces);

  void buildXmlElement(XmlBuilder builder, {Map<String, String> namespaces = const {}}) =>
      _$WebDavSetBuildXmlElement(this as WebDavSet, builder, namespaces: namespaces);

  List<XmlAttribute> toXmlAttributes({Map<String, String?> namespaces = const {}}) =>
      _$WebDavSetToXmlAttributes(this as WebDavSet, namespaces: namespaces);

  List<XmlNode> toXmlChildren({Map<String, String?> namespaces = const {}}) =>
      _$WebDavSetToXmlChildren(this as WebDavSet, namespaces: namespaces);

  XmlElement toXmlElement({Map<String, String?> namespaces = const {}}) =>
      _$WebDavSetToXmlElement(this as WebDavSet, namespaces: namespaces);
}

void _$WebDavRemoveBuildXmlChildren(WebDavRemove instance, XmlBuilder builder,
    {Map<String, String> namespaces = const {}}) {
  final prop = instance.prop;
  final propSerialized = prop;
  builder.element('prop', namespace: 'DAV:', nest: () {
    propSerialized.buildXmlChildren(builder, namespaces: namespaces);
  });
}

void _$WebDavRemoveBuildXmlElement(WebDavRemove instance, XmlBuilder builder,
    {Map<String, String> namespaces = const {}}) {
  builder.element('remove', namespace: 'DAV:', namespaces: namespaces, nest: () {
    instance.buildXmlChildren(builder, namespaces: namespaces);
  });
}

WebDavRemove _$WebDavRemoveFromXmlElement(XmlElement element) {
  final prop = element.getElement('prop', namespace: 'DAV:')!;
  return WebDavRemove(prop: WebDavPropWithoutValues.fromXmlElement(prop));
}

List<XmlAttribute> _$WebDavRemoveToXmlAttributes(WebDavRemove instance, {Map<String, String?> namespaces = const {}}) {
  final attributes = <XmlAttribute>[];
  return attributes;
}

List<XmlNode> _$WebDavRemoveToXmlChildren(WebDavRemove instance, {Map<String, String?> namespaces = const {}}) {
  final children = <XmlNode>[];
  final prop = instance.prop;
  final propSerialized = prop;
  final propConstructed = XmlElement(XmlName('prop', namespaces['DAV:']),
      propSerialized.toXmlAttributes(namespaces: namespaces), propSerialized.toXmlChildren(namespaces: namespaces));
  children.add(propConstructed);
  return children;
}

XmlElement _$WebDavRemoveToXmlElement(WebDavRemove instance, {Map<String, String?> namespaces = const {}}) {
  return XmlElement(
      XmlName('remove', namespaces['DAV:']),
      [...namespaces.toXmlAttributes(), ...instance.toXmlAttributes(namespaces: namespaces)],
      instance.toXmlChildren(namespaces: namespaces));
}

mixin _$WebDavRemoveXmlSerializableMixin {
  void buildXmlChildren(XmlBuilder builder, {Map<String, String> namespaces = const {}}) =>
      _$WebDavRemoveBuildXmlChildren(this as WebDavRemove, builder, namespaces: namespaces);

  void buildXmlElement(XmlBuilder builder, {Map<String, String> namespaces = const {}}) =>
      _$WebDavRemoveBuildXmlElement(this as WebDavRemove, builder, namespaces: namespaces);

  List<XmlAttribute> toXmlAttributes({Map<String, String?> namespaces = const {}}) =>
      _$WebDavRemoveToXmlAttributes(this as WebDavRemove, namespaces: namespaces);

  List<XmlNode> toXmlChildren({Map<String, String?> namespaces = const {}}) =>
      _$WebDavRemoveToXmlChildren(this as WebDavRemove, namespaces: namespaces);

  XmlElement toXmlElement({Map<String, String?> namespaces = const {}}) =>
      _$WebDavRemoveToXmlElement(this as WebDavRemove, namespaces: namespaces);
}

void _$WebDavPropfindBuildXmlChildren(WebDavPropfind instance, XmlBuilder builder,
    {Map<String, String> namespaces = const {}}) {
  final prop = instance.prop;
  final propSerialized = prop;
  builder.element('prop', namespace: 'DAV:', nest: () {
    propSerialized.buildXmlChildren(builder, namespaces: namespaces);
  });
}

void _$WebDavPropfindBuildXmlElement(WebDavPropfind instance, XmlBuilder builder,
    {Map<String, String> namespaces = const {}}) {
  builder.element('propfind', namespace: 'DAV:', namespaces: namespaces, nest: () {
    instance.buildXmlChildren(builder, namespaces: namespaces);
  });
}

WebDavPropfind _$WebDavPropfindFromXmlElement(XmlElement element) {
  final prop = element.getElement('prop', namespace: 'DAV:')!;
  return WebDavPropfind(prop: WebDavPropWithoutValues.fromXmlElement(prop));
}

List<XmlAttribute> _$WebDavPropfindToXmlAttributes(WebDavPropfind instance,
    {Map<String, String?> namespaces = const {}}) {
  final attributes = <XmlAttribute>[];
  return attributes;
}

List<XmlNode> _$WebDavPropfindToXmlChildren(WebDavPropfind instance, {Map<String, String?> namespaces = const {}}) {
  final children = <XmlNode>[];
  final prop = instance.prop;
  final propSerialized = prop;
  final propConstructed = XmlElement(XmlName('prop', namespaces['DAV:']),
      propSerialized.toXmlAttributes(namespaces: namespaces), propSerialized.toXmlChildren(namespaces: namespaces));
  children.add(propConstructed);
  return children;
}

XmlElement _$WebDavPropfindToXmlElement(WebDavPropfind instance, {Map<String, String?> namespaces = const {}}) {
  return XmlElement(
      XmlName('propfind', namespaces['DAV:']),
      [...namespaces.toXmlAttributes(), ...instance.toXmlAttributes(namespaces: namespaces)],
      instance.toXmlChildren(namespaces: namespaces));
}

mixin _$WebDavPropfindXmlSerializableMixin {
  void buildXmlChildren(XmlBuilder builder, {Map<String, String> namespaces = const {}}) =>
      _$WebDavPropfindBuildXmlChildren(this as WebDavPropfind, builder, namespaces: namespaces);

  void buildXmlElement(XmlBuilder builder, {Map<String, String> namespaces = const {}}) =>
      _$WebDavPropfindBuildXmlElement(this as WebDavPropfind, builder, namespaces: namespaces);

  List<XmlAttribute> toXmlAttributes({Map<String, String?> namespaces = const {}}) =>
      _$WebDavPropfindToXmlAttributes(this as WebDavPropfind, namespaces: namespaces);

  List<XmlNode> toXmlChildren({Map<String, String?> namespaces = const {}}) =>
      _$WebDavPropfindToXmlChildren(this as WebDavPropfind, namespaces: namespaces);

  XmlElement toXmlElement({Map<String, String?> namespaces = const {}}) =>
      _$WebDavPropfindToXmlElement(this as WebDavPropfind, namespaces: namespaces);
}

void _$WebDavOcFilterFilesBuildXmlChildren(WebDavOcFilterFiles instance, XmlBuilder builder,
    {Map<String, String> namespaces = const {}}) {
  final filterRules = instance.filterRules;
  final filterRulesSerialized = filterRules;
  builder.element('filter-rules', namespace: 'http://owncloud.org/ns', nest: () {
    filterRulesSerialized.buildXmlChildren(builder, namespaces: namespaces);
  });
  final prop = instance.prop;
  final propSerialized = prop;
  builder.element('prop', namespace: 'DAV:', nest: () {
    propSerialized.buildXmlChildren(builder, namespaces: namespaces);
  });
}

void _$WebDavOcFilterFilesBuildXmlElement(WebDavOcFilterFiles instance, XmlBuilder builder,
    {Map<String, String> namespaces = const {}}) {
  builder.element('filter-files', namespace: 'http://owncloud.org/ns', namespaces: namespaces, nest: () {
    instance.buildXmlChildren(builder, namespaces: namespaces);
  });
}

WebDavOcFilterFiles _$WebDavOcFilterFilesFromXmlElement(XmlElement element) {
  final filterRules = element.getElement('filter-rules', namespace: 'http://owncloud.org/ns')!;
  final prop = element.getElement('prop', namespace: 'DAV:')!;
  return WebDavOcFilterFiles(
      filterRules: WebDavOcFilterRules.fromXmlElement(filterRules), prop: WebDavPropWithoutValues.fromXmlElement(prop));
}

List<XmlAttribute> _$WebDavOcFilterFilesToXmlAttributes(WebDavOcFilterFiles instance,
    {Map<String, String?> namespaces = const {}}) {
  final attributes = <XmlAttribute>[];
  return attributes;
}

List<XmlNode> _$WebDavOcFilterFilesToXmlChildren(WebDavOcFilterFiles instance,
    {Map<String, String?> namespaces = const {}}) {
  final children = <XmlNode>[];
  final filterRules = instance.filterRules;
  final filterRulesSerialized = filterRules;
  final filterRulesConstructed = XmlElement(
      XmlName('filter-rules', namespaces['http://owncloud.org/ns']),
      filterRulesSerialized.toXmlAttributes(namespaces: namespaces),
      filterRulesSerialized.toXmlChildren(namespaces: namespaces));
  children.add(filterRulesConstructed);
  final prop = instance.prop;
  final propSerialized = prop;
  final propConstructed = XmlElement(XmlName('prop', namespaces['DAV:']),
      propSerialized.toXmlAttributes(namespaces: namespaces), propSerialized.toXmlChildren(namespaces: namespaces));
  children.add(propConstructed);
  return children;
}

XmlElement _$WebDavOcFilterFilesToXmlElement(WebDavOcFilterFiles instance,
    {Map<String, String?> namespaces = const {}}) {
  return XmlElement(
      XmlName('filter-files', namespaces['http://owncloud.org/ns']),
      [...namespaces.toXmlAttributes(), ...instance.toXmlAttributes(namespaces: namespaces)],
      instance.toXmlChildren(namespaces: namespaces));
}

mixin _$WebDavOcFilterFilesXmlSerializableMixin {
  void buildXmlChildren(XmlBuilder builder, {Map<String, String> namespaces = const {}}) =>
      _$WebDavOcFilterFilesBuildXmlChildren(this as WebDavOcFilterFiles, builder, namespaces: namespaces);

  void buildXmlElement(XmlBuilder builder, {Map<String, String> namespaces = const {}}) =>
      _$WebDavOcFilterFilesBuildXmlElement(this as WebDavOcFilterFiles, builder, namespaces: namespaces);

  List<XmlAttribute> toXmlAttributes({Map<String, String?> namespaces = const {}}) =>
      _$WebDavOcFilterFilesToXmlAttributes(this as WebDavOcFilterFiles, namespaces: namespaces);

  List<XmlNode> toXmlChildren({Map<String, String?> namespaces = const {}}) =>
      _$WebDavOcFilterFilesToXmlChildren(this as WebDavOcFilterFiles, namespaces: namespaces);

  XmlElement toXmlElement({Map<String, String?> namespaces = const {}}) =>
      _$WebDavOcFilterFilesToXmlElement(this as WebDavOcFilterFiles, namespaces: namespaces);
}

void _$WebDavResourcetypeBuildXmlChildren(WebDavResourcetype instance, XmlBuilder builder,
    {Map<String, String> namespaces = const {}}) {
  final collection = instance.collection;
  final collectionSerialized = collection;
  if (collectionSerialized != null) {
    for (final value in collectionSerialized) {
      builder.element('collection', namespace: 'DAV:', isSelfClosing: true, nest: () {
        if (value != null) {
          builder.text(value);
        }
      });
    }
  }
}

void _$WebDavResourcetypeBuildXmlElement(WebDavResourcetype instance, XmlBuilder builder,
    {Map<String, String> namespaces = const {}}) {
  builder.element('resourcetype', namespace: 'DAV:', namespaces: namespaces, nest: () {
    instance.buildXmlChildren(builder, namespaces: namespaces);
  });
}

WebDavResourcetype _$WebDavResourcetypeFromXmlElement(XmlElement element) {
  final collection = element.getElements('collection', namespace: 'DAV:')?.map((e) => e.getText()).whereType<String>();
  return WebDavResourcetype(collection: collection?.toList());
}

List<XmlAttribute> _$WebDavResourcetypeToXmlAttributes(WebDavResourcetype instance,
    {Map<String, String?> namespaces = const {}}) {
  final attributes = <XmlAttribute>[];
  return attributes;
}

List<XmlNode> _$WebDavResourcetypeToXmlChildren(WebDavResourcetype instance,
    {Map<String, String?> namespaces = const {}}) {
  final children = <XmlNode>[];
  final collection = instance.collection;
  final collectionSerialized = collection;
  final collectionConstructed = collectionSerialized
      ?.map((e) => XmlElement(XmlName('collection', namespaces['DAV:']), [], e != null ? [XmlText(e)] : [], true));
  if (collectionConstructed != null) {
    children.addAll(collectionConstructed);
  }
  return children;
}

XmlElement _$WebDavResourcetypeToXmlElement(WebDavResourcetype instance, {Map<String, String?> namespaces = const {}}) {
  return XmlElement(
      XmlName('resourcetype', namespaces['DAV:']),
      [...namespaces.toXmlAttributes(), ...instance.toXmlAttributes(namespaces: namespaces)],
      instance.toXmlChildren(namespaces: namespaces));
}

mixin _$WebDavResourcetypeXmlSerializableMixin {
  void buildXmlChildren(XmlBuilder builder, {Map<String, String> namespaces = const {}}) =>
      _$WebDavResourcetypeBuildXmlChildren(this as WebDavResourcetype, builder, namespaces: namespaces);

  void buildXmlElement(XmlBuilder builder, {Map<String, String> namespaces = const {}}) =>
      _$WebDavResourcetypeBuildXmlElement(this as WebDavResourcetype, builder, namespaces: namespaces);

  List<XmlAttribute> toXmlAttributes({Map<String, String?> namespaces = const {}}) =>
      _$WebDavResourcetypeToXmlAttributes(this as WebDavResourcetype, namespaces: namespaces);

  List<XmlNode> toXmlChildren({Map<String, String?> namespaces = const {}}) =>
      _$WebDavResourcetypeToXmlChildren(this as WebDavResourcetype, namespaces: namespaces);

  XmlElement toXmlElement({Map<String, String?> namespaces = const {}}) =>
      _$WebDavResourcetypeToXmlElement(this as WebDavResourcetype, namespaces: namespaces);
}
