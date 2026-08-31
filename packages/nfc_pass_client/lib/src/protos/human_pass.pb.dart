// This is a generated file - do not edit.
//
// Generated from human_pass.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class GetAccessTokenForDigitalPassRequest extends $pb.GeneratedMessage {
  factory GetAccessTokenForDigitalPassRequest() => create();

  GetAccessTokenForDigitalPassRequest._();

  factory GetAccessTokenForDigitalPassRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetAccessTokenForDigitalPassRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAccessTokenForDigitalPassRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rtu.humanpass'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAccessTokenForDigitalPassRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAccessTokenForDigitalPassRequest copyWith(
          void Function(GetAccessTokenForDigitalPassRequest) updates) =>
      super.copyWith((message) =>
              updates(message as GetAccessTokenForDigitalPassRequest))
          as GetAccessTokenForDigitalPassRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAccessTokenForDigitalPassRequest create() =>
      GetAccessTokenForDigitalPassRequest._();
  @$core.override
  GetAccessTokenForDigitalPassRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetAccessTokenForDigitalPassRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          GetAccessTokenForDigitalPassRequest>(create);
  static GetAccessTokenForDigitalPassRequest? _defaultInstance;
}

class GetAccessTokenForDigitalPassResponse extends $pb.GeneratedMessage {
  factory GetAccessTokenForDigitalPassResponse({
    $core.String? jwt,
  }) {
    final result = create();
    if (jwt != null) result.jwt = jwt;
    return result;
  }

  GetAccessTokenForDigitalPassResponse._();

  factory GetAccessTokenForDigitalPassResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetAccessTokenForDigitalPassResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAccessTokenForDigitalPassResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rtu.humanpass'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'jwt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAccessTokenForDigitalPassResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAccessTokenForDigitalPassResponse copyWith(
          void Function(GetAccessTokenForDigitalPassResponse) updates) =>
      super.copyWith((message) =>
              updates(message as GetAccessTokenForDigitalPassResponse))
          as GetAccessTokenForDigitalPassResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAccessTokenForDigitalPassResponse create() =>
      GetAccessTokenForDigitalPassResponse._();
  @$core.override
  GetAccessTokenForDigitalPassResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetAccessTokenForDigitalPassResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          GetAccessTokenForDigitalPassResponse>(create);
  static GetAccessTokenForDigitalPassResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get jwt => $_getSZ(0);
  @$pb.TagNumber(1)
  set jwt($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasJwt() => $_has(0);
  @$pb.TagNumber(1)
  void clearJwt() => $_clearField(1);
}

class SendVerificationCodeRequest extends $pb.GeneratedMessage {
  factory SendVerificationCodeRequest() => create();

  SendVerificationCodeRequest._();

  factory SendVerificationCodeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SendVerificationCodeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SendVerificationCodeRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rtu.humanpass'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendVerificationCodeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendVerificationCodeRequest copyWith(
          void Function(SendVerificationCodeRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SendVerificationCodeRequest))
          as SendVerificationCodeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SendVerificationCodeRequest create() =>
      SendVerificationCodeRequest._();
  @$core.override
  SendVerificationCodeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SendVerificationCodeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SendVerificationCodeRequest>(create);
  static SendVerificationCodeRequest? _defaultInstance;
}

class SendVerificationCodeResponse extends $pb.GeneratedMessage {
  factory SendVerificationCodeResponse() => create();

  SendVerificationCodeResponse._();

  factory SendVerificationCodeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SendVerificationCodeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SendVerificationCodeResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rtu.humanpass'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendVerificationCodeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendVerificationCodeResponse copyWith(
          void Function(SendVerificationCodeResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SendVerificationCodeResponse))
          as SendVerificationCodeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SendVerificationCodeResponse create() =>
      SendVerificationCodeResponse._();
  @$core.override
  SendVerificationCodeResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SendVerificationCodeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SendVerificationCodeResponse>(create);
  static SendVerificationCodeResponse? _defaultInstance;
}

class GetDigitalPassRequest extends $pb.GeneratedMessage {
  factory GetDigitalPassRequest({
    $core.String? code,
    DeviceInfo? deviceInfo,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (deviceInfo != null) result.deviceInfo = deviceInfo;
    return result;
  }

  GetDigitalPassRequest._();

  factory GetDigitalPassRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetDigitalPassRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDigitalPassRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rtu.humanpass'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOM<DeviceInfo>(2, _omitFieldNames ? '' : 'deviceInfo',
        subBuilder: DeviceInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDigitalPassRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDigitalPassRequest copyWith(
          void Function(GetDigitalPassRequest) updates) =>
      super.copyWith((message) => updates(message as GetDigitalPassRequest))
          as GetDigitalPassRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDigitalPassRequest create() => GetDigitalPassRequest._();
  @$core.override
  GetDigitalPassRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetDigitalPassRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDigitalPassRequest>(create);
  static GetDigitalPassRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  DeviceInfo get deviceInfo => $_getN(1);
  @$pb.TagNumber(2)
  set deviceInfo(DeviceInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDeviceInfo() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeviceInfo() => $_clearField(2);
  @$pb.TagNumber(2)
  DeviceInfo ensureDeviceInfo() => $_ensure(1);
}

class GetDigitalPassResponse extends $pb.GeneratedMessage {
  factory GetDigitalPassResponse({
    DigitalPassInner? inner,
  }) {
    final result = create();
    if (inner != null) result.inner = inner;
    return result;
  }

  GetDigitalPassResponse._();

  factory GetDigitalPassResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetDigitalPassResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDigitalPassResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rtu.humanpass'),
      createEmptyInstance: create)
    ..aOM<DigitalPassInner>(1, _omitFieldNames ? '' : 'inner',
        subBuilder: DigitalPassInner.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDigitalPassResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDigitalPassResponse copyWith(
          void Function(GetDigitalPassResponse) updates) =>
      super.copyWith((message) => updates(message as GetDigitalPassResponse))
          as GetDigitalPassResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDigitalPassResponse create() => GetDigitalPassResponse._();
  @$core.override
  GetDigitalPassResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetDigitalPassResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDigitalPassResponse>(create);
  static GetDigitalPassResponse? _defaultInstance;

  @$pb.TagNumber(1)
  DigitalPassInner get inner => $_getN(0);
  @$pb.TagNumber(1)
  set inner(DigitalPassInner value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasInner() => $_has(0);
  @$pb.TagNumber(1)
  void clearInner() => $_clearField(1);
  @$pb.TagNumber(1)
  DigitalPassInner ensureInner() => $_ensure(0);
}

class DigitalPassInner extends $pb.GeneratedMessage {
  factory DigitalPassInner({
    $fixnum.Int64? passId,
    $core.String? passUuid,
  }) {
    final result = create();
    if (passId != null) result.passId = passId;
    if (passUuid != null) result.passUuid = passUuid;
    return result;
  }

  DigitalPassInner._();

  factory DigitalPassInner.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DigitalPassInner.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DigitalPassInner',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rtu.humanpass'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'passId')
    ..aOS(2, _omitFieldNames ? '' : 'passUuid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DigitalPassInner clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DigitalPassInner copyWith(void Function(DigitalPassInner) updates) =>
      super.copyWith((message) => updates(message as DigitalPassInner))
          as DigitalPassInner;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DigitalPassInner create() => DigitalPassInner._();
  @$core.override
  DigitalPassInner createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DigitalPassInner getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DigitalPassInner>(create);
  static DigitalPassInner? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get passId => $_getI64(0);
  @$pb.TagNumber(1)
  set passId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPassId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPassId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get passUuid => $_getSZ(1);
  @$pb.TagNumber(2)
  set passUuid($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPassUuid() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassUuid() => $_clearField(2);
}

class DeviceInfo extends $pb.GeneratedMessage {
  factory DeviceInfo({
    $core.String? deviceName,
  }) {
    final result = create();
    if (deviceName != null) result.deviceName = deviceName;
    return result;
  }

  DeviceInfo._();

  factory DeviceInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeviceInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeviceInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rtu.humanpass'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceInfo copyWith(void Function(DeviceInfo) updates) =>
      super.copyWith((message) => updates(message as DeviceInfo)) as DeviceInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeviceInfo create() => DeviceInfo._();
  @$core.override
  DeviceInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeviceInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeviceInfo>(create);
  static DeviceInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceName => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceName() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceName() => $_clearField(1);
}

class GetDigitalPassStatusRequest extends $pb.GeneratedMessage {
  factory GetDigitalPassStatusRequest() => create();

  GetDigitalPassStatusRequest._();

  factory GetDigitalPassStatusRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetDigitalPassStatusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDigitalPassStatusRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rtu.humanpass'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDigitalPassStatusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDigitalPassStatusRequest copyWith(
          void Function(GetDigitalPassStatusRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetDigitalPassStatusRequest))
          as GetDigitalPassStatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDigitalPassStatusRequest create() =>
      GetDigitalPassStatusRequest._();
  @$core.override
  GetDigitalPassStatusRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetDigitalPassStatusRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDigitalPassStatusRequest>(create);
  static GetDigitalPassStatusRequest? _defaultInstance;
}

class GetDigitalPassStatusResponse extends $pb.GeneratedMessage {
  factory GetDigitalPassStatusResponse() => create();

  GetDigitalPassStatusResponse._();

  factory GetDigitalPassStatusResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetDigitalPassStatusResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDigitalPassStatusResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rtu.humanpass'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDigitalPassStatusResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDigitalPassStatusResponse copyWith(
          void Function(GetDigitalPassStatusResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetDigitalPassStatusResponse))
          as GetDigitalPassStatusResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDigitalPassStatusResponse create() =>
      GetDigitalPassStatusResponse._();
  @$core.override
  GetDigitalPassStatusResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetDigitalPassStatusResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDigitalPassStatusResponse>(create);
  static GetDigitalPassStatusResponse? _defaultInstance;
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
