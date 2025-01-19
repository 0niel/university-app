import 'dart:typed_data';

/// Class for parsing gRPC frames and protobuf messages.
class ProtoDecoder {
  /// grpc-frame parser: 1 byte flags + 4 bytes length + payload
  static Uint8List parseGrpcFrame(Uint8List data) {
    if (data.length < 5) {
      throw const FormatException('Слишком короткий ответ, нет gRPC header.');
    }
    final flags = data[0]; // Maybe 0 if no compression
    if (flags != 0) {
      throw FormatException('Неподдерживаемые gRPC flags: $flags');
    }

    // 4 bytes big-endian length
    final length = (data[1] << 24) | (data[2] << 16) | (data[3] << 8) | data[4];

    final payload = data.sublist(5);
    if (payload.length != length) {
      throw FormatException(
        'Длина gRPC payload $length не совпадает с реальным размером ${payload.length}',
      );
    }
    return payload;
  }

  /// Create gRPC frame: 1 byte flags=0, 4 bytes big-endian length,
  /// + protobuf message.
  static Uint8List makeGrpcFrame(List<int> protobufMessage) {
    final length = protobufMessage.length;
    final header = <int>[
      0x00, // flags
      (length >> 24) & 0xFF,
      (length >> 16) & 0xFF,
      (length >> 8) & 0xFF,
      length & 0xFF,
    ];
    return Uint8List.fromList([...header, ...protobufMessage]);
  }

  /// Parse proto message "fieldNumber -> dynamic".
  /// - varint (wireType=0) -> int
  /// - length-delimited (wireType=2) -> Uint8List (bytes)
  static Map<int, dynamic> parseProtobufFields(Uint8List data) {
    final result = <int, dynamic>{};
    var offset = 0;
    while (offset < data.length) {
      // Читаем key (varint)
      final keyResult = _readVarint(data, offset);
      final key = keyResult.value;
      offset = keyResult.nextOffset;

      final wireType = key & 0x07;
      final fieldNumber = key >> 3;

      switch (wireType) {
        case 0: // varint
          final varintRes = _readVarint(data, offset);
          result[fieldNumber] = varintRes.value;
          offset = varintRes.nextOffset;
        case 2: // length-delimited
          final lenRes = _readVarint(data, offset);
          final length = lenRes.value;
          offset = lenRes.nextOffset;
          if (offset + length > data.length) {
            throw const FormatException(
              'length-delimited поле выходит за границы массива',
            );
          }
          final bytes = data.sublist(offset, offset + length);
          offset += length;
          result[fieldNumber] = bytes;
        default:
          throw FormatException('Unsupported wireType = $wireType');
      }
    }
    return result;
  }

  /// Varint encoding: 7 bits data + 1 bit continuation flag.
  static List<int> encodeVarint(int value) {
    final bytes = <int>[];
    var v = value;
    while (true) {
      final bits = v & 0x7F;
      v >>= 7;
      if (v == 0) {
        bytes.add(bits);
        break;
      } else {
        bytes.add(bits | 0x80);
      }
    }
    return bytes;
  }

  /// Varint decoding. Returns value and next offset.
  static _VarintResult _readVarint(Uint8List data, int startOffset) {
    var result = 0;
    var shift = 0;
    var offset = startOffset;

    while (true) {
      if (offset >= data.length) {
        throw const FormatException('Varint не закончен до конца массива');
      }
      final byte = data[offset];
      offset++;
      result |= (byte & 0x7F) << shift;
      if ((byte & 0x80) == 0) {
        // last byte
        return _VarintResult(value: result, nextOffset: offset);
      }
      shift += 7;
      if (shift > 64) {
        throw const FormatException('Слишком большой varint (за пределами int64)');
      }
    }
  }

  /// Make length-delimited field: key + length + data.
  static List<int> makeLengthDelimitedField({
    required int fieldNumber,
    required List<int> data,
  }) {
    final key = (fieldNumber << 3) | 2; // wireType=2
    final keyVarint = encodeVarint(key);
    final lengthVarint = encodeVarint(data.length);
    return <int>[
      ...keyVarint,
      ...lengthVarint,
      ...data,
    ];
  }
}

class _VarintResult {
  _VarintResult({required this.value, required this.nextOffset});
  final int value;
  final int nextOffset;
}
