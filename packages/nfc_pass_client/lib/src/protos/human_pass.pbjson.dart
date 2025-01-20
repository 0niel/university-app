//
//  Generated code. Do not modify.
//  source: human_pass.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use getAccessTokenForDigitalPassRequestDescriptor instead')
const GetAccessTokenForDigitalPassRequest$json = {
  '1': 'GetAccessTokenForDigitalPassRequest',
};

/// Descriptor for `GetAccessTokenForDigitalPassRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAccessTokenForDigitalPassRequestDescriptor =
    $convert.base64Decode('CiNHZXRBY2Nlc3NUb2tlbkZvckRpZ2l0YWxQYXNzUmVxdWVzdA==');

@$core.Deprecated('Use getAccessTokenForDigitalPassResponseDescriptor instead')
const GetAccessTokenForDigitalPassResponse$json = {
  '1': 'GetAccessTokenForDigitalPassResponse',
  '2': [
    {'1': 'jwt', '3': 1, '4': 1, '5': 9, '10': 'jwt'},
  ],
};

/// Descriptor for `GetAccessTokenForDigitalPassResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAccessTokenForDigitalPassResponseDescriptor =
    $convert.base64Decode('CiRHZXRBY2Nlc3NUb2tlbkZvckRpZ2l0YWxQYXNzUmVzcG9uc2USEAoDand0GAEgASgJUgNqd3'
        'Q=');

@$core.Deprecated('Use sendVerificationCodeRequestDescriptor instead')
const SendVerificationCodeRequest$json = {
  '1': 'SendVerificationCodeRequest',
};

/// Descriptor for `SendVerificationCodeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendVerificationCodeRequestDescriptor =
    $convert.base64Decode('ChtTZW5kVmVyaWZpY2F0aW9uQ29kZVJlcXVlc3Q=');

@$core.Deprecated('Use sendVerificationCodeResponseDescriptor instead')
const SendVerificationCodeResponse$json = {
  '1': 'SendVerificationCodeResponse',
};

/// Descriptor for `SendVerificationCodeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendVerificationCodeResponseDescriptor =
    $convert.base64Decode('ChxTZW5kVmVyaWZpY2F0aW9uQ29kZVJlc3BvbnNl');

@$core.Deprecated('Use getDigitalPassRequestDescriptor instead')
const GetDigitalPassRequest$json = {
  '1': 'GetDigitalPassRequest',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'device_info', '3': 2, '4': 1, '5': 11, '6': '.rtu.humanpass.DeviceInfo', '10': 'deviceInfo'},
  ],
};

/// Descriptor for `GetDigitalPassRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDigitalPassRequestDescriptor =
    $convert.base64Decode('ChVHZXREaWdpdGFsUGFzc1JlcXVlc3QSEgoEY29kZRgBIAEoCVIEY29kZRI6CgtkZXZpY2VfaW'
        '5mbxgCIAEoCzIZLnJ0dS5odW1hbnBhc3MuRGV2aWNlSW5mb1IKZGV2aWNlSW5mbw==');

@$core.Deprecated('Use getDigitalPassResponseDescriptor instead')
const GetDigitalPassResponse$json = {
  '1': 'GetDigitalPassResponse',
  '2': [
    {'1': 'inner', '3': 1, '4': 1, '5': 11, '6': '.rtu.humanpass.DigitalPassInner', '10': 'inner'},
  ],
};

/// Descriptor for `GetDigitalPassResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDigitalPassResponseDescriptor =
    $convert.base64Decode('ChZHZXREaWdpdGFsUGFzc1Jlc3BvbnNlEjUKBWlubmVyGAEgASgLMh8ucnR1Lmh1bWFucGFzcy'
        '5EaWdpdGFsUGFzc0lubmVyUgVpbm5lcg==');

@$core.Deprecated('Use digitalPassInnerDescriptor instead')
const DigitalPassInner$json = {
  '1': 'DigitalPassInner',
  '2': [
    {'1': 'pass_id', '3': 1, '4': 1, '5': 3, '10': 'passId'},
    {'1': 'pass_uuid', '3': 2, '4': 1, '5': 9, '10': 'passUuid'},
  ],
};

/// Descriptor for `DigitalPassInner`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List digitalPassInnerDescriptor =
    $convert.base64Decode('ChBEaWdpdGFsUGFzc0lubmVyEhcKB3Bhc3NfaWQYASABKANSBnBhc3NJZBIbCglwYXNzX3V1aW'
        'QYAiABKAlSCHBhc3NVdWlk');

@$core.Deprecated('Use deviceInfoDescriptor instead')
const DeviceInfo$json = {
  '1': 'DeviceInfo',
  '2': [
    {'1': 'device_name', '3': 1, '4': 1, '5': 9, '10': 'deviceName'},
  ],
};

/// Descriptor for `DeviceInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceInfoDescriptor =
    $convert.base64Decode('CgpEZXZpY2VJbmZvEh8KC2RldmljZV9uYW1lGAEgASgJUgpkZXZpY2VOYW1l');

@$core.Deprecated('Use getDigitalPassStatusRequestDescriptor instead')
const GetDigitalPassStatusRequest$json = {
  '1': 'GetDigitalPassStatusRequest',
};

/// Descriptor for `GetDigitalPassStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDigitalPassStatusRequestDescriptor =
    $convert.base64Decode('ChtHZXREaWdpdGFsUGFzc1N0YXR1c1JlcXVlc3Q=');

@$core.Deprecated('Use getDigitalPassStatusResponseDescriptor instead')
const GetDigitalPassStatusResponse$json = {
  '1': 'GetDigitalPassStatusResponse',
};

/// Descriptor for `GetDigitalPassStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDigitalPassStatusResponseDescriptor =
    $convert.base64Decode('ChxHZXREaWdpdGFsUGFzc1N0YXR1c1Jlc3BvbnNl');
