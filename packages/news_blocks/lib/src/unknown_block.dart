import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'unknown_block.freezed.dart';

@freezed
abstract class UnknownBlock with _$UnknownBlock implements NewsBlock {
  const factory UnknownBlock({
    @Default(<String, dynamic>{'type': UnknownBlock.identifier})
    Map<String, dynamic> rawJson,
  }) = _UnknownBlock;

  const UnknownBlock._();

  factory UnknownBlock.fromJson(Map<String, dynamic> json) {
    final rawJson = Map.of(json)
      ..putIfAbsent('type', () => UnknownBlock.identifier);
    return UnknownBlock(rawJson: rawJson);
  }

  @override
  String get type => rawJson['type'] as String;

  @override
  Map<String, dynamic> toJson() => Map.of(rawJson);

  static const identifier = '__unknown__';
}
