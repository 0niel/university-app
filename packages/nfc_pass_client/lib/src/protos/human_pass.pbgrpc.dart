//
//  Generated code. Do not modify.
//  source: human_pass.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:nfc_pass_client/src/protos/human_pass.pb.dart' as $0;
import 'package:protobuf/protobuf.dart' as $pb;

export 'human_pass.pb.dart';

@$pb.GrpcServiceName('rtu.humanpass.LongTimeTokenService')
class LongTimeTokenServiceClient extends $grpc.Client {
  LongTimeTokenServiceClient(
    $grpc.ClientChannel channel, {
    $grpc.CallOptions? options,
    $core.Iterable<$grpc.ClientInterceptor>? interceptors,
  }) : super(
          channel,
          options: options,
          interceptors: interceptors,
        );
  static final _$getAccessTokenForDigitalPass =
      $grpc.ClientMethod<$0.GetAccessTokenForDigitalPassRequest, $0.GetAccessTokenForDigitalPassResponse>(
    '/rtu.humanpass.LongTimeTokenService/GetAccessTokenForDigitalPass',
    ($0.GetAccessTokenForDigitalPassRequest value) => value.writeToBuffer(),
    ($core.List<$core.int> value) => $0.GetAccessTokenForDigitalPassResponse.fromBuffer(value),
  );

  $grpc.ResponseFuture<$0.GetAccessTokenForDigitalPassResponse> getAccessTokenForDigitalPass(
    $0.GetAccessTokenForDigitalPassRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getAccessTokenForDigitalPass, request, options: options);
  }
}

@$pb.GrpcServiceName('rtu.humanpass.LongTimeTokenService')
abstract class LongTimeTokenServiceBase extends $grpc.Service {
  LongTimeTokenServiceBase() {
    $addMethod(
      $grpc.ServiceMethod<$0.GetAccessTokenForDigitalPassRequest, $0.GetAccessTokenForDigitalPassResponse>(
        'GetAccessTokenForDigitalPass',
        getAccessTokenForDigitalPass_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetAccessTokenForDigitalPassRequest.fromBuffer(value),
        ($0.GetAccessTokenForDigitalPassResponse value) => value.writeToBuffer(),
      ),
    );
  }
  $core.String get $name => 'rtu.humanpass.LongTimeTokenService';

  $async.Future<$0.GetAccessTokenForDigitalPassResponse> getAccessTokenForDigitalPass_Pre(
    $grpc.ServiceCall call,
    $async.Future<$0.GetAccessTokenForDigitalPassRequest> request,
  ) async {
    return getAccessTokenForDigitalPass(call, await request);
  }

  $async.Future<$0.GetAccessTokenForDigitalPassResponse> getAccessTokenForDigitalPass(
    $grpc.ServiceCall call,
    $0.GetAccessTokenForDigitalPassRequest request,
  );
}

@$pb.GrpcServiceName('rtu.humanpass.HumanPassService')
class HumanPassServiceClient extends $grpc.Client {
  HumanPassServiceClient(
    $grpc.ClientChannel channel, {
    $grpc.CallOptions? options,
    $core.Iterable<$grpc.ClientInterceptor>? interceptors,
  }) : super(
          channel,
          options: options,
          interceptors: interceptors,
        );
  static final _$sendVerificationCode =
      $grpc.ClientMethod<$0.SendVerificationCodeRequest, $0.SendVerificationCodeResponse>(
    '/rtu.humanpass.HumanPassService/SendVerificationCode',
    ($0.SendVerificationCodeRequest value) => value.writeToBuffer(),
    ($core.List<$core.int> value) => $0.SendVerificationCodeResponse.fromBuffer(value),
  );
  static final _$getDigitalPass = $grpc.ClientMethod<$0.GetDigitalPassRequest, $0.GetDigitalPassResponse>(
    '/rtu.humanpass.HumanPassService/GetDigitalPass',
    ($0.GetDigitalPassRequest value) => value.writeToBuffer(),
    ($core.List<$core.int> value) => $0.GetDigitalPassResponse.fromBuffer(value),
  );
  static final _$getDigitalPassStatus =
      $grpc.ClientMethod<$0.GetDigitalPassStatusRequest, $0.GetDigitalPassStatusResponse>(
    '/rtu.humanpass.HumanPassService/GetDigitalPassStatus',
    ($0.GetDigitalPassStatusRequest value) => value.writeToBuffer(),
    ($core.List<$core.int> value) => $0.GetDigitalPassStatusResponse.fromBuffer(value),
  );

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
}

@$pb.GrpcServiceName('rtu.humanpass.HumanPassService')
abstract class HumanPassServiceBase extends $grpc.Service {
  HumanPassServiceBase() {
    $addMethod(
      $grpc.ServiceMethod<$0.SendVerificationCodeRequest, $0.SendVerificationCodeResponse>(
        'SendVerificationCode',
        sendVerificationCode_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SendVerificationCodeRequest.fromBuffer(value),
        ($0.SendVerificationCodeResponse value) => value.writeToBuffer(),
      ),
    );
    $addMethod(
      $grpc.ServiceMethod<$0.GetDigitalPassRequest, $0.GetDigitalPassResponse>(
        'GetDigitalPass',
        getDigitalPass_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetDigitalPassRequest.fromBuffer(value),
        ($0.GetDigitalPassResponse value) => value.writeToBuffer(),
      ),
    );
    $addMethod(
      $grpc.ServiceMethod<$0.GetDigitalPassStatusRequest, $0.GetDigitalPassStatusResponse>(
        'GetDigitalPassStatus',
        getDigitalPassStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetDigitalPassStatusRequest.fromBuffer(value),
        ($0.GetDigitalPassStatusResponse value) => value.writeToBuffer(),
      ),
    );
  }
  $core.String get $name => 'rtu.humanpass.HumanPassService';

  $async.Future<$0.SendVerificationCodeResponse> sendVerificationCode_Pre(
    $grpc.ServiceCall call,
    $async.Future<$0.SendVerificationCodeRequest> request,
  ) async {
    return sendVerificationCode(call, await request);
  }

  $async.Future<$0.GetDigitalPassResponse> getDigitalPass_Pre(
    $grpc.ServiceCall call,
    $async.Future<$0.GetDigitalPassRequest> request,
  ) async {
    return getDigitalPass(call, await request);
  }

  $async.Future<$0.GetDigitalPassStatusResponse> getDigitalPassStatus_Pre(
    $grpc.ServiceCall call,
    $async.Future<$0.GetDigitalPassStatusRequest> request,
  ) async {
    return getDigitalPassStatus(call, await request);
  }

  $async.Future<$0.SendVerificationCodeResponse> sendVerificationCode(
    $grpc.ServiceCall call,
    $0.SendVerificationCodeRequest request,
  );
  $async.Future<$0.GetDigitalPassResponse> getDigitalPass($grpc.ServiceCall call, $0.GetDigitalPassRequest request);
  $async.Future<$0.GetDigitalPassStatusResponse> getDigitalPassStatus(
    $grpc.ServiceCall call,
    $0.GetDigitalPassStatusRequest request,
  );
}
