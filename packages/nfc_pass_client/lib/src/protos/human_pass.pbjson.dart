// This is a generated file - do not edit.
//
// Generated from human_pass.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use getAccessTokenForDigitalPassRequestDescriptor instead')
const GetAccessTokenForDigitalPassRequest$json = {
  '1': 'GetAccessTokenForDigitalPassRequest',
};

/// Descriptor for `GetAccessTokenForDigitalPassRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAccessTokenForDigitalPassRequestDescriptor =
    $convert
        .base64Decode('CiNHZXRBY2Nlc3NUb2tlbkZvckRpZ2l0YWxQYXNzUmVxdWVzdA==');

@$core.Deprecated('Use getAccessTokenForDigitalPassResponseDescriptor instead')
const GetAccessTokenForDigitalPassResponse$json = {
  '1': 'GetAccessTokenForDigitalPassResponse',
  '2': [
    {'1': 'jwt', '3': 1, '4': 1, '5': 9, '10': 'jwt'},
  ],
};

/// Descriptor for `GetAccessTokenForDigitalPassResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAccessTokenForDigitalPassResponseDescriptor =
    $convert.base64Decode(
        'CiRHZXRBY2Nlc3NUb2tlbkZvckRpZ2l0YWxQYXNzUmVzcG9uc2USEAoDand0GAEgASgJUgNqd3'
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
  '2': [
    {
      '1': 'success',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.rtu.humanpass.VerificationCodeSent',
      '9': 0,
      '10': 'success'
    },
    {
      '1': 'wait_for_to_next_attempt',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '9': 0,
      '10': 'waitForToNextAttempt'
    },
    {
      '1': 'no_digital_pass_or_verification_method',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Empty',
      '9': 0,
      '10': 'noDigitalPassOrVerificationMethod'
    },
  ],
  '8': [
    {'1': 'result'},
  ],
};

/// Descriptor for `SendVerificationCodeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendVerificationCodeResponseDescriptor = $convert.base64Decode(
    'ChxTZW5kVmVyaWZpY2F0aW9uQ29kZVJlc3BvbnNlEj8KB3N1Y2Nlc3MYASABKAsyIy5ydHUuaH'
    'VtYW5wYXNzLlZlcmlmaWNhdGlvbkNvZGVTZW50SABSB3N1Y2Nlc3MSVAoYd2FpdF9mb3JfdG9f'
    'bmV4dF9hdHRlbXB0GAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcEgAUhR3YWl0Rm'
    '9yVG9OZXh0QXR0ZW1wdBJrCiZub19kaWdpdGFsX3Bhc3Nfb3JfdmVyaWZpY2F0aW9uX21ldGhv'
    'ZBgDIAEoCzIWLmdvb2dsZS5wcm90b2J1Zi5FbXB0eUgAUiFub0RpZ2l0YWxQYXNzT3JWZXJpZm'
    'ljYXRpb25NZXRob2RCCAoGcmVzdWx0');

@$core.Deprecated('Use verificationCodeSentDescriptor instead')
const VerificationCodeSent$json = {
  '1': 'VerificationCodeSent',
  '2': [
    {
      '1': 'wait_for_to_next_attempt',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'waitForToNextAttempt'
    },
  ],
};

/// Descriptor for `VerificationCodeSent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verificationCodeSentDescriptor = $convert.base64Decode(
    'ChRWZXJpZmljYXRpb25Db2RlU2VudBJSChh3YWl0X2Zvcl90b19uZXh0X2F0dGVtcHQYASABKA'
    'syGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUhR3YWl0Rm9yVG9OZXh0QXR0ZW1wdA==');

@$core.Deprecated('Use getDigitalPassRequestDescriptor instead')
const GetDigitalPassRequest$json = {
  '1': 'GetDigitalPassRequest',
  '2': [
    {'1': 'received_code', '3': 1, '4': 1, '5': 9, '10': 'receivedCode'},
    {
      '1': 'device_info',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.rtu.humanpass.DeviceInfo',
      '10': 'deviceInfo'
    },
  ],
};

/// Descriptor for `GetDigitalPassRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDigitalPassRequestDescriptor = $convert.base64Decode(
    'ChVHZXREaWdpdGFsUGFzc1JlcXVlc3QSIwoNcmVjZWl2ZWRfY29kZRgBIAEoCVIMcmVjZWl2ZW'
    'RDb2RlEjoKC2RldmljZV9pbmZvGAIgASgLMhkucnR1Lmh1bWFucGFzcy5EZXZpY2VJbmZvUgpk'
    'ZXZpY2VJbmZv');

@$core.Deprecated('Use getDigitalPassResponseDescriptor instead')
const GetDigitalPassResponse$json = {
  '1': 'GetDigitalPassResponse',
  '2': [
    {
      '1': 'success',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.rtu.humanpass.DigitalPass',
      '9': 0,
      '10': 'success'
    },
    {
      '1': 'wrong_code',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Empty',
      '9': 0,
      '10': 'wrongCode'
    },
    {
      '1': 'nfc_error',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Empty',
      '9': 0,
      '10': 'nfcError'
    },
  ],
  '8': [
    {'1': 'result'},
  ],
};

/// Descriptor for `GetDigitalPassResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDigitalPassResponseDescriptor = $convert.base64Decode(
    'ChZHZXREaWdpdGFsUGFzc1Jlc3BvbnNlEjYKB3N1Y2Nlc3MYASABKAsyGi5ydHUuaHVtYW5wYX'
    'NzLkRpZ2l0YWxQYXNzSABSB3N1Y2Nlc3MSNwoKd3JvbmdfY29kZRgCIAEoCzIWLmdvb2dsZS5w'
    'cm90b2J1Zi5FbXB0eUgAUgl3cm9uZ0NvZGUSNQoJbmZjX2Vycm9yGAMgASgLMhYuZ29vZ2xlLn'
    'Byb3RvYnVmLkVtcHR5SABSCG5mY0Vycm9yQggKBnJlc3VsdA==');

@$core.Deprecated('Use digitalPassDescriptor instead')
const DigitalPass$json = {
  '1': 'DigitalPass',
  '2': [
    {'1': 'card_number', '3': 1, '4': 1, '5': 3, '10': 'cardNumber'},
    {'1': 'using_id', '3': 2, '4': 1, '5': 9, '10': 'usingId'},
  ],
};

/// Descriptor for `DigitalPass`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List digitalPassDescriptor = $convert.base64Decode(
    'CgtEaWdpdGFsUGFzcxIfCgtjYXJkX251bWJlchgBIAEoA1IKY2FyZE51bWJlchIZCgh1c2luZ1'
    '9pZBgCIAEoCVIHdXNpbmdJZA==');

@$core.Deprecated('Use deviceInfoDescriptor instead')
const DeviceInfo$json = {
  '1': 'DeviceInfo',
  '2': [
    {'1': 'device_info_raw', '3': 1, '4': 1, '5': 9, '10': 'deviceInfoRaw'},
  ],
};

/// Descriptor for `DeviceInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceInfoDescriptor = $convert.base64Decode(
    'CgpEZXZpY2VJbmZvEiYKD2RldmljZV9pbmZvX3JhdxgBIAEoCVINZGV2aWNlSW5mb1Jhdw==');

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
