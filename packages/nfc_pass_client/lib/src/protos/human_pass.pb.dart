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
import 'package:protobuf/well_known_types/google/protobuf/empty.pb.dart' as $2;
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart'
    as $1;

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

enum SendVerificationCodeResponse_Result {
  success,
  waitForToNextAttempt,
  noDigitalPassOrVerificationMethod,
  notSet
}

class SendVerificationCodeResponse extends $pb.GeneratedMessage {
  factory SendVerificationCodeResponse({
    VerificationCodeSent? success,
    $1.Timestamp? waitForToNextAttempt,
    $2.Empty? noDigitalPassOrVerificationMethod,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (waitForToNextAttempt != null)
      result.waitForToNextAttempt = waitForToNextAttempt;
    if (noDigitalPassOrVerificationMethod != null)
      result.noDigitalPassOrVerificationMethod =
          noDigitalPassOrVerificationMethod;
    return result;
  }

  SendVerificationCodeResponse._();

  factory SendVerificationCodeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SendVerificationCodeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, SendVerificationCodeResponse_Result>
      _SendVerificationCodeResponse_ResultByTag = {
    1: SendVerificationCodeResponse_Result.success,
    2: SendVerificationCodeResponse_Result.waitForToNextAttempt,
    3: SendVerificationCodeResponse_Result.noDigitalPassOrVerificationMethod,
    0: SendVerificationCodeResponse_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SendVerificationCodeResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rtu.humanpass'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOM<VerificationCodeSent>(1, _omitFieldNames ? '' : 'success',
        subBuilder: VerificationCodeSent.create)
    ..aOM<$1.Timestamp>(2, _omitFieldNames ? '' : 'waitForToNextAttempt',
        subBuilder: $1.Timestamp.create)
    ..aOM<$2.Empty>(
        3, _omitFieldNames ? '' : 'noDigitalPassOrVerificationMethod',
        subBuilder: $2.Empty.create)
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

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  SendVerificationCodeResponse_Result whichResult() =>
      _SendVerificationCodeResponse_ResultByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  void clearResult() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  VerificationCodeSent get success => $_getN(0);
  @$pb.TagNumber(1)
  set success(VerificationCodeSent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
  @$pb.TagNumber(1)
  VerificationCodeSent ensureSuccess() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.Timestamp get waitForToNextAttempt => $_getN(1);
  @$pb.TagNumber(2)
  set waitForToNextAttempt($1.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasWaitForToNextAttempt() => $_has(1);
  @$pb.TagNumber(2)
  void clearWaitForToNextAttempt() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Timestamp ensureWaitForToNextAttempt() => $_ensure(1);

  @$pb.TagNumber(3)
  $2.Empty get noDigitalPassOrVerificationMethod => $_getN(2);
  @$pb.TagNumber(3)
  set noDigitalPassOrVerificationMethod($2.Empty value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasNoDigitalPassOrVerificationMethod() => $_has(2);
  @$pb.TagNumber(3)
  void clearNoDigitalPassOrVerificationMethod() => $_clearField(3);
  @$pb.TagNumber(3)
  $2.Empty ensureNoDigitalPassOrVerificationMethod() => $_ensure(2);
}

class VerificationCodeSent extends $pb.GeneratedMessage {
  factory VerificationCodeSent({
    $1.Timestamp? waitForToNextAttempt,
  }) {
    final result = create();
    if (waitForToNextAttempt != null)
      result.waitForToNextAttempt = waitForToNextAttempt;
    return result;
  }

  VerificationCodeSent._();

  factory VerificationCodeSent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VerificationCodeSent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VerificationCodeSent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rtu.humanpass'),
      createEmptyInstance: create)
    ..aOM<$1.Timestamp>(1, _omitFieldNames ? '' : 'waitForToNextAttempt',
        subBuilder: $1.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerificationCodeSent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerificationCodeSent copyWith(void Function(VerificationCodeSent) updates) =>
      super.copyWith((message) => updates(message as VerificationCodeSent))
          as VerificationCodeSent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VerificationCodeSent create() => VerificationCodeSent._();
  @$core.override
  VerificationCodeSent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VerificationCodeSent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VerificationCodeSent>(create);
  static VerificationCodeSent? _defaultInstance;

  @$pb.TagNumber(1)
  $1.Timestamp get waitForToNextAttempt => $_getN(0);
  @$pb.TagNumber(1)
  set waitForToNextAttempt($1.Timestamp value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWaitForToNextAttempt() => $_has(0);
  @$pb.TagNumber(1)
  void clearWaitForToNextAttempt() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Timestamp ensureWaitForToNextAttempt() => $_ensure(0);
}

class GetDigitalPassRequest extends $pb.GeneratedMessage {
  factory GetDigitalPassRequest({
    $core.String? receivedCode,
    DeviceInfo? deviceInfo,
  }) {
    final result = create();
    if (receivedCode != null) result.receivedCode = receivedCode;
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
    ..aOS(1, _omitFieldNames ? '' : 'receivedCode')
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
  $core.String get receivedCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set receivedCode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReceivedCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearReceivedCode() => $_clearField(1);

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

enum GetDigitalPassResponse_Result { success, wrongCode, nfcError, notSet }

class GetDigitalPassResponse extends $pb.GeneratedMessage {
  factory GetDigitalPassResponse({
    DigitalPass? success,
    $2.Empty? wrongCode,
    $2.Empty? nfcError,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (wrongCode != null) result.wrongCode = wrongCode;
    if (nfcError != null) result.nfcError = nfcError;
    return result;
  }

  GetDigitalPassResponse._();

  factory GetDigitalPassResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetDigitalPassResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, GetDigitalPassResponse_Result>
      _GetDigitalPassResponse_ResultByTag = {
    1: GetDigitalPassResponse_Result.success,
    2: GetDigitalPassResponse_Result.wrongCode,
    3: GetDigitalPassResponse_Result.nfcError,
    0: GetDigitalPassResponse_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDigitalPassResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rtu.humanpass'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOM<DigitalPass>(1, _omitFieldNames ? '' : 'success',
        subBuilder: DigitalPass.create)
    ..aOM<$2.Empty>(2, _omitFieldNames ? '' : 'wrongCode',
        subBuilder: $2.Empty.create)
    ..aOM<$2.Empty>(3, _omitFieldNames ? '' : 'nfcError',
        subBuilder: $2.Empty.create)
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
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  GetDigitalPassResponse_Result whichResult() =>
      _GetDigitalPassResponse_ResultByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  void clearResult() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  DigitalPass get success => $_getN(0);
  @$pb.TagNumber(1)
  set success(DigitalPass value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
  @$pb.TagNumber(1)
  DigitalPass ensureSuccess() => $_ensure(0);

  @$pb.TagNumber(2)
  $2.Empty get wrongCode => $_getN(1);
  @$pb.TagNumber(2)
  set wrongCode($2.Empty value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasWrongCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearWrongCode() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.Empty ensureWrongCode() => $_ensure(1);

  @$pb.TagNumber(3)
  $2.Empty get nfcError => $_getN(2);
  @$pb.TagNumber(3)
  set nfcError($2.Empty value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasNfcError() => $_has(2);
  @$pb.TagNumber(3)
  void clearNfcError() => $_clearField(3);
  @$pb.TagNumber(3)
  $2.Empty ensureNfcError() => $_ensure(2);
}

class DigitalPass extends $pb.GeneratedMessage {
  factory DigitalPass({
    $fixnum.Int64? cardNumber,
    $core.String? usingId,
  }) {
    final result = create();
    if (cardNumber != null) result.cardNumber = cardNumber;
    if (usingId != null) result.usingId = usingId;
    return result;
  }

  DigitalPass._();

  factory DigitalPass.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DigitalPass.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DigitalPass',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rtu.humanpass'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'cardNumber')
    ..aOS(2, _omitFieldNames ? '' : 'usingId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DigitalPass clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DigitalPass copyWith(void Function(DigitalPass) updates) =>
      super.copyWith((message) => updates(message as DigitalPass))
          as DigitalPass;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DigitalPass create() => DigitalPass._();
  @$core.override
  DigitalPass createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DigitalPass getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DigitalPass>(create);
  static DigitalPass? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get cardNumber => $_getI64(0);
  @$pb.TagNumber(1)
  set cardNumber($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCardNumber() => $_has(0);
  @$pb.TagNumber(1)
  void clearCardNumber() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get usingId => $_getSZ(1);
  @$pb.TagNumber(2)
  set usingId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUsingId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUsingId() => $_clearField(2);
}

class DeviceInfo extends $pb.GeneratedMessage {
  factory DeviceInfo({
    $core.String? deviceInfoRaw,
  }) {
    final result = create();
    if (deviceInfoRaw != null) result.deviceInfoRaw = deviceInfoRaw;
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
    ..aOS(1, _omitFieldNames ? '' : 'deviceInfoRaw')
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
  $core.String get deviceInfoRaw => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceInfoRaw($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceInfoRaw() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceInfoRaw() => $_clearField(1);
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
