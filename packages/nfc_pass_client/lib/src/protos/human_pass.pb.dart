//
//  Generated code. Do not modify.
//  source: human_pass.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

/// ========== Сообщения для LongTimeTokenService ==========
class GetAccessTokenForDigitalPassRequest extends $pb.GeneratedMessage {
  factory GetAccessTokenForDigitalPassRequest() => create();
  GetAccessTokenForDigitalPassRequest._() : super();
  factory GetAccessTokenForDigitalPassRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetAccessTokenForDigitalPassRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetAccessTokenForDigitalPassRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rtu.humanpass'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  GetAccessTokenForDigitalPassRequest clone() => GetAccessTokenForDigitalPassRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  GetAccessTokenForDigitalPassRequest copyWith(void Function(GetAccessTokenForDigitalPassRequest) updates) =>
      super.copyWith((message) => updates(message as GetAccessTokenForDigitalPassRequest))
          as GetAccessTokenForDigitalPassRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAccessTokenForDigitalPassRequest create() => GetAccessTokenForDigitalPassRequest._();
  GetAccessTokenForDigitalPassRequest createEmptyInstance() => create();
  static $pb.PbList<GetAccessTokenForDigitalPassRequest> createRepeated() =>
      $pb.PbList<GetAccessTokenForDigitalPassRequest>();
  @$core.pragma('dart2js:noInline')
  static GetAccessTokenForDigitalPassRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetAccessTokenForDigitalPassRequest>(create);
  static GetAccessTokenForDigitalPassRequest? _defaultInstance;
}

class GetAccessTokenForDigitalPassResponse extends $pb.GeneratedMessage {
  factory GetAccessTokenForDigitalPassResponse({
    $core.String? jwt,
  }) {
    final $result = create();
    if (jwt != null) {
      $result.jwt = jwt;
    }
    return $result;
  }
  GetAccessTokenForDigitalPassResponse._() : super();
  factory GetAccessTokenForDigitalPassResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetAccessTokenForDigitalPassResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetAccessTokenForDigitalPassResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rtu.humanpass'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'jwt')
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  GetAccessTokenForDigitalPassResponse clone() => GetAccessTokenForDigitalPassResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  GetAccessTokenForDigitalPassResponse copyWith(void Function(GetAccessTokenForDigitalPassResponse) updates) =>
      super.copyWith((message) => updates(message as GetAccessTokenForDigitalPassResponse))
          as GetAccessTokenForDigitalPassResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAccessTokenForDigitalPassResponse create() => GetAccessTokenForDigitalPassResponse._();
  GetAccessTokenForDigitalPassResponse createEmptyInstance() => create();
  static $pb.PbList<GetAccessTokenForDigitalPassResponse> createRepeated() =>
      $pb.PbList<GetAccessTokenForDigitalPassResponse>();
  @$core.pragma('dart2js:noInline')
  static GetAccessTokenForDigitalPassResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetAccessTokenForDigitalPassResponse>(create);
  static GetAccessTokenForDigitalPassResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get jwt => $_getSZ(0);
  @$pb.TagNumber(1)
  set jwt($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasJwt() => $_has(0);
  @$pb.TagNumber(1)
  void clearJwt() => clearField(1);
}

/// ========== Сообщения для HumanPassService ==========
class SendVerificationCodeRequest extends $pb.GeneratedMessage {
  factory SendVerificationCodeRequest() => create();
  SendVerificationCodeRequest._() : super();
  factory SendVerificationCodeRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SendVerificationCodeRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SendVerificationCodeRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rtu.humanpass'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  SendVerificationCodeRequest clone() => SendVerificationCodeRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  SendVerificationCodeRequest copyWith(void Function(SendVerificationCodeRequest) updates) =>
      super.copyWith((message) => updates(message as SendVerificationCodeRequest)) as SendVerificationCodeRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SendVerificationCodeRequest create() => SendVerificationCodeRequest._();
  SendVerificationCodeRequest createEmptyInstance() => create();
  static $pb.PbList<SendVerificationCodeRequest> createRepeated() => $pb.PbList<SendVerificationCodeRequest>();
  @$core.pragma('dart2js:noInline')
  static SendVerificationCodeRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SendVerificationCodeRequest>(create);
  static SendVerificationCodeRequest? _defaultInstance;
}

class SendVerificationCodeResponse extends $pb.GeneratedMessage {
  factory SendVerificationCodeResponse() => create();
  SendVerificationCodeResponse._() : super();
  factory SendVerificationCodeResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SendVerificationCodeResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SendVerificationCodeResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rtu.humanpass'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  SendVerificationCodeResponse clone() => SendVerificationCodeResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  SendVerificationCodeResponse copyWith(void Function(SendVerificationCodeResponse) updates) =>
      super.copyWith((message) => updates(message as SendVerificationCodeResponse)) as SendVerificationCodeResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SendVerificationCodeResponse create() => SendVerificationCodeResponse._();
  SendVerificationCodeResponse createEmptyInstance() => create();
  static $pb.PbList<SendVerificationCodeResponse> createRepeated() => $pb.PbList<SendVerificationCodeResponse>();
  @$core.pragma('dart2js:noInline')
  static SendVerificationCodeResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SendVerificationCodeResponse>(create);
  static SendVerificationCodeResponse? _defaultInstance;
}

class GetDigitalPassRequest extends $pb.GeneratedMessage {
  factory GetDigitalPassRequest({
    $core.String? code,
    DeviceInfo? deviceInfo,
  }) {
    final $result = create();
    if (code != null) {
      $result.code = code;
    }
    if (deviceInfo != null) {
      $result.deviceInfo = deviceInfo;
    }
    return $result;
  }
  GetDigitalPassRequest._() : super();
  factory GetDigitalPassRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetDigitalPassRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetDigitalPassRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rtu.humanpass'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOM<DeviceInfo>(2, _omitFieldNames ? '' : 'deviceInfo', subBuilder: DeviceInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  GetDigitalPassRequest clone() => GetDigitalPassRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  GetDigitalPassRequest copyWith(void Function(GetDigitalPassRequest) updates) =>
      super.copyWith((message) => updates(message as GetDigitalPassRequest)) as GetDigitalPassRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDigitalPassRequest create() => GetDigitalPassRequest._();
  GetDigitalPassRequest createEmptyInstance() => create();
  static $pb.PbList<GetDigitalPassRequest> createRepeated() => $pb.PbList<GetDigitalPassRequest>();
  @$core.pragma('dart2js:noInline')
  static GetDigitalPassRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetDigitalPassRequest>(create);
  static GetDigitalPassRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => clearField(1);

  @$pb.TagNumber(2)
  DeviceInfo get deviceInfo => $_getN(1);
  @$pb.TagNumber(2)
  set deviceInfo(DeviceInfo v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasDeviceInfo() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeviceInfo() => clearField(2);
  @$pb.TagNumber(2)
  DeviceInfo ensureDeviceInfo() => $_ensure(1);
}

class GetDigitalPassResponse extends $pb.GeneratedMessage {
  factory GetDigitalPassResponse({
    DigitalPassInner? inner,
  }) {
    final $result = create();
    if (inner != null) {
      $result.inner = inner;
    }
    return $result;
  }
  GetDigitalPassResponse._() : super();
  factory GetDigitalPassResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetDigitalPassResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetDigitalPassResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rtu.humanpass'), createEmptyInstance: create)
    ..aOM<DigitalPassInner>(1, _omitFieldNames ? '' : 'inner', subBuilder: DigitalPassInner.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  GetDigitalPassResponse clone() => GetDigitalPassResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  GetDigitalPassResponse copyWith(void Function(GetDigitalPassResponse) updates) =>
      super.copyWith((message) => updates(message as GetDigitalPassResponse)) as GetDigitalPassResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDigitalPassResponse create() => GetDigitalPassResponse._();
  GetDigitalPassResponse createEmptyInstance() => create();
  static $pb.PbList<GetDigitalPassResponse> createRepeated() => $pb.PbList<GetDigitalPassResponse>();
  @$core.pragma('dart2js:noInline')
  static GetDigitalPassResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetDigitalPassResponse>(create);
  static GetDigitalPassResponse? _defaultInstance;

  @$pb.TagNumber(1)
  DigitalPassInner get inner => $_getN(0);
  @$pb.TagNumber(1)
  set inner(DigitalPassInner v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasInner() => $_has(0);
  @$pb.TagNumber(1)
  void clearInner() => clearField(1);
  @$pb.TagNumber(1)
  DigitalPassInner ensureInner() => $_ensure(0);
}

class DigitalPassInner extends $pb.GeneratedMessage {
  factory DigitalPassInner({
    $fixnum.Int64? passId,
    $core.String? passUuid,
  }) {
    final $result = create();
    if (passId != null) {
      $result.passId = passId;
    }
    if (passUuid != null) {
      $result.passUuid = passUuid;
    }
    return $result;
  }
  DigitalPassInner._() : super();
  factory DigitalPassInner.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DigitalPassInner.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DigitalPassInner',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rtu.humanpass'), createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'passId')
    ..aOS(2, _omitFieldNames ? '' : 'passUuid')
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DigitalPassInner clone() => DigitalPassInner()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DigitalPassInner copyWith(void Function(DigitalPassInner) updates) =>
      super.copyWith((message) => updates(message as DigitalPassInner)) as DigitalPassInner;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DigitalPassInner create() => DigitalPassInner._();
  DigitalPassInner createEmptyInstance() => create();
  static $pb.PbList<DigitalPassInner> createRepeated() => $pb.PbList<DigitalPassInner>();
  @$core.pragma('dart2js:noInline')
  static DigitalPassInner getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DigitalPassInner>(create);
  static DigitalPassInner? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get passId => $_getI64(0);
  @$pb.TagNumber(1)
  set passId($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasPassId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPassId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get passUuid => $_getSZ(1);
  @$pb.TagNumber(2)
  set passUuid($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasPassUuid() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassUuid() => clearField(2);
}

class DeviceInfo extends $pb.GeneratedMessage {
  factory DeviceInfo({
    $core.String? deviceName,
  }) {
    final $result = create();
    if (deviceName != null) {
      $result.deviceName = deviceName;
    }
    return $result;
  }
  DeviceInfo._() : super();
  factory DeviceInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DeviceInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeviceInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rtu.humanpass'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceName')
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DeviceInfo clone() => DeviceInfo()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DeviceInfo copyWith(void Function(DeviceInfo) updates) =>
      super.copyWith((message) => updates(message as DeviceInfo)) as DeviceInfo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeviceInfo create() => DeviceInfo._();
  DeviceInfo createEmptyInstance() => create();
  static $pb.PbList<DeviceInfo> createRepeated() => $pb.PbList<DeviceInfo>();
  @$core.pragma('dart2js:noInline')
  static DeviceInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeviceInfo>(create);
  static DeviceInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceName => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceName($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasDeviceName() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceName() => clearField(1);
}

class GetDigitalPassStatusRequest extends $pb.GeneratedMessage {
  factory GetDigitalPassStatusRequest() => create();
  GetDigitalPassStatusRequest._() : super();
  factory GetDigitalPassStatusRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetDigitalPassStatusRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetDigitalPassStatusRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rtu.humanpass'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  GetDigitalPassStatusRequest clone() => GetDigitalPassStatusRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  GetDigitalPassStatusRequest copyWith(void Function(GetDigitalPassStatusRequest) updates) =>
      super.copyWith((message) => updates(message as GetDigitalPassStatusRequest)) as GetDigitalPassStatusRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDigitalPassStatusRequest create() => GetDigitalPassStatusRequest._();
  GetDigitalPassStatusRequest createEmptyInstance() => create();
  static $pb.PbList<GetDigitalPassStatusRequest> createRepeated() => $pb.PbList<GetDigitalPassStatusRequest>();
  @$core.pragma('dart2js:noInline')
  static GetDigitalPassStatusRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetDigitalPassStatusRequest>(create);
  static GetDigitalPassStatusRequest? _defaultInstance;
}

class GetDigitalPassStatusResponse extends $pb.GeneratedMessage {
  factory GetDigitalPassStatusResponse() => create();
  GetDigitalPassStatusResponse._() : super();
  factory GetDigitalPassStatusResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GetDigitalPassStatusResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetDigitalPassStatusResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'rtu.humanpass'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  GetDigitalPassStatusResponse clone() => GetDigitalPassStatusResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  GetDigitalPassStatusResponse copyWith(void Function(GetDigitalPassStatusResponse) updates) =>
      super.copyWith((message) => updates(message as GetDigitalPassStatusResponse)) as GetDigitalPassStatusResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDigitalPassStatusResponse create() => GetDigitalPassStatusResponse._();
  GetDigitalPassStatusResponse createEmptyInstance() => create();
  static $pb.PbList<GetDigitalPassStatusResponse> createRepeated() => $pb.PbList<GetDigitalPassStatusResponse>();
  @$core.pragma('dart2js:noInline')
  static GetDigitalPassStatusResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetDigitalPassStatusResponse>(create);
  static GetDigitalPassStatusResponse? _defaultInstance;
}

const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
