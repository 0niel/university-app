import 'dart:convert';
import 'dart:typed_data';

import 'package:nfc_pass_client/src/nfc_pass_transport_exception.dart';

Uint8List parseGrpcWebResponse(
  Uint8List body, {
  required Map<String, String> headers,
  bool allowEmpty = false,
}) {
  final normalizedHeaders = {
    for (final entry in headers.entries) entry.key.toLowerCase(): entry.value,
  };
  final contentType =
      normalizedHeaders['content-type']?.split(';').first.trim().toLowerCase();
  if (contentType != 'application/grpc-web+proto' &&
      contentType != 'application/grpc-web') {
    throw const FormatException('Unsupported gRPC-Web content type.');
  }

  Uint8List? payload;
  int? trailerStatus;
  var offset = 0;
  var hasTrailers = false;
  while (offset < body.length) {
    if (body.length - offset < 5) {
      throw const FormatException('Incomplete gRPC-Web frame header.');
    }
    final flags = body[offset];
    final length =
        ByteData.sublistView(body, offset + 1, offset + 5).getUint32(0);
    offset += 5;
    if (length > body.length - offset) {
      throw const FormatException('Incomplete gRPC-Web frame payload.');
    }
    final frame = Uint8List.sublistView(body, offset, offset + length);
    offset += length;
    if (flags == 0) {
      if (payload != null || hasTrailers) {
        throw const FormatException('Unexpected gRPC-Web data frame.');
      }
      payload = frame;
    } else if (flags == 0x80) {
      if (hasTrailers || offset != body.length) {
        throw const FormatException('gRPC-Web trailers must be last.');
      }
      hasTrailers = true;
      final trailers = <String, String>{};
      for (final line in ascii.decode(frame).split('\r\n')) {
        if (line.isEmpty) continue;
        final separator = line.indexOf(':');
        if (separator <= 0) {
          throw const FormatException('Malformed gRPC-Web trailer.');
        }
        final key = line.substring(0, separator).toLowerCase();
        if (!RegExp(r'^[a-z0-9_.-]+$').hasMatch(key) ||
            (key == 'grpc-status' && trailers.containsKey(key))) {
          throw const FormatException('Invalid gRPC-Web trailer field.');
        }
        trailers[key] = line.substring(separator + 1).trim();
      }
      trailerStatus = _parseStatus(trailers['grpc-status']);
    } else {
      throw const FormatException('Unsupported gRPC-Web frame flags.');
    }
  }

  final headerValue = normalizedHeaders['grpc-status'];
  final headerStatus = headerValue == null ? null : _parseStatus(headerValue);
  if (headerStatus != null &&
      trailerStatus != null &&
      headerStatus != trailerStatus) {
    throw const FormatException('Conflicting gRPC-Web status.');
  }
  final status = trailerStatus ?? headerStatus;
  if (status == null) {
    throw const FormatException('Missing gRPC-Web status.');
  }
  if (status != 0) {
    throw NfcPassTransportException(
      'gRPC request failed with status $status.',
      grpcStatus: status,
    );
  }
  if (payload == null && !allowEmpty) {
    throw const FormatException('Missing gRPC-Web response message.');
  }
  return payload ?? Uint8List(0);
}

int _parseStatus(String? value) {
  if (value == null || !RegExp(r'^(0|[1-9][0-9]*)$').hasMatch(value)) {
    throw const FormatException('Invalid gRPC-Web status.');
  }
  final status = int.tryParse(value);
  if (status == null || status > 16) {
    throw const FormatException('Invalid gRPC-Web status.');
  }
  return status;
}
