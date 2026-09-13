// This is a generated file - do not edit.
//
// Generated from human_pass.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'human_pass.pb.dart' as $0;

export 'human_pass.pb.dart';

@$pb.GrpcServiceName('rtu.humanpass.LongTimeTokenService')
class LongTimeTokenServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  LongTimeTokenServiceClient(super.channel,
      {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.GetAccessTokenForDigitalPassResponse>
      getAccessTokenForDigitalPass(
    $0.GetAccessTokenForDigitalPassRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getAccessTokenForDigitalPass, request,
        options: options);
  }

  // method descriptors

  static final _$getAccessTokenForDigitalPass = $grpc.ClientMethod<
          $0.GetAccessTokenForDigitalPassRequest,
          $0.GetAccessTokenForDigitalPassResponse>(
      '/rtu.humanpass.LongTimeTokenService/GetAccessTokenForDigitalPass',
      ($0.GetAccessTokenForDigitalPassRequest value) => value.writeToBuffer(),
      $0.GetAccessTokenForDigitalPassResponse.fromBuffer);
}

@$pb.GrpcServiceName('rtu.humanpass.LongTimeTokenService')
abstract class LongTimeTokenServiceBase extends $grpc.Service {
  $core.String get $name => 'rtu.humanpass.LongTimeTokenService';

  LongTimeTokenServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GetAccessTokenForDigitalPassRequest,
            $0.GetAccessTokenForDigitalPassResponse>(
        'GetAccessTokenForDigitalPass',
        getAccessTokenForDigitalPass_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetAccessTokenForDigitalPassRequest.fromBuffer(value),
        ($0.GetAccessTokenForDigitalPassResponse value) =>
            value.writeToBuffer()));
  }

  $async.Future<$0.GetAccessTokenForDigitalPassResponse>
      getAccessTokenForDigitalPass_Pre(
          $grpc.ServiceCall $call,
          $async.Future<$0.GetAccessTokenForDigitalPassRequest>
              $request) async {
    return getAccessTokenForDigitalPass($call, await $request);
  }

  $async.Future<$0.GetAccessTokenForDigitalPassResponse>
      getAccessTokenForDigitalPass($grpc.ServiceCall call,
          $0.GetAccessTokenForDigitalPassRequest request);
}

@$pb.GrpcServiceName('rtu.humanpass.HumanPassService')
class HumanPassServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  HumanPassServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.SendVerificationCodeResponse> sendVerificationCode(
    $0.SendVerificationCodeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$sendVerificationCode, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetDigitalPassResponse> getDigitalPass(
    $0.GetDigitalPassRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getDigitalPass, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetDigitalPassStatusResponse> getDigitalPassStatus(
    $0.GetDigitalPassStatusRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getDigitalPassStatus, request, options: options);
  }

  // method descriptors

  static final _$sendVerificationCode = $grpc.ClientMethod<
          $0.SendVerificationCodeRequest, $0.SendVerificationCodeResponse>(
      '/rtu.humanpass.HumanPassService/SendVerificationCode',
      ($0.SendVerificationCodeRequest value) => value.writeToBuffer(),
      $0.SendVerificationCodeResponse.fromBuffer);
  static final _$getDigitalPass =
      $grpc.ClientMethod<$0.GetDigitalPassRequest, $0.GetDigitalPassResponse>(
          '/rtu.humanpass.HumanPassService/GetDigitalPass',
          ($0.GetDigitalPassRequest value) => value.writeToBuffer(),
          $0.GetDigitalPassResponse.fromBuffer);
  static final _$getDigitalPassStatus = $grpc.ClientMethod<
          $0.GetDigitalPassStatusRequest, $0.GetDigitalPassStatusResponse>(
      '/rtu.humanpass.HumanPassService/GetDigitalPassStatus',
      ($0.GetDigitalPassStatusRequest value) => value.writeToBuffer(),
      $0.GetDigitalPassStatusResponse.fromBuffer);
}

@$pb.GrpcServiceName('rtu.humanpass.HumanPassService')
abstract class HumanPassServiceBase extends $grpc.Service {
  $core.String get $name => 'rtu.humanpass.HumanPassService';

  HumanPassServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.SendVerificationCodeRequest,
            $0.SendVerificationCodeResponse>(
        'SendVerificationCode',
        sendVerificationCode_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SendVerificationCodeRequest.fromBuffer(value),
        ($0.SendVerificationCodeResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetDigitalPassRequest,
            $0.GetDigitalPassResponse>(
        'GetDigitalPass',
        getDigitalPass_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetDigitalPassRequest.fromBuffer(value),
        ($0.GetDigitalPassResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetDigitalPassStatusRequest,
            $0.GetDigitalPassStatusResponse>(
        'GetDigitalPassStatus',
        getDigitalPassStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetDigitalPassStatusRequest.fromBuffer(value),
        ($0.GetDigitalPassStatusResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.SendVerificationCodeResponse> sendVerificationCode_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SendVerificationCodeRequest> $request) async {
    return sendVerificationCode($call, await $request);
  }

  $async.Future<$0.SendVerificationCodeResponse> sendVerificationCode(
      $grpc.ServiceCall call, $0.SendVerificationCodeRequest request);

  $async.Future<$0.GetDigitalPassResponse> getDigitalPass_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetDigitalPassRequest> $request) async {
    return getDigitalPass($call, await $request);
  }

  $async.Future<$0.GetDigitalPassResponse> getDigitalPass(
      $grpc.ServiceCall call, $0.GetDigitalPassRequest request);

  $async.Future<$0.GetDigitalPassStatusResponse> getDigitalPassStatus_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetDigitalPassStatusRequest> $request) async {
    return getDigitalPassStatus($call, await $request);
  }

  $async.Future<$0.GetDigitalPassStatusResponse> getDigitalPassStatus(
      $grpc.ServiceCall call, $0.GetDigitalPassStatusRequest request);
}
