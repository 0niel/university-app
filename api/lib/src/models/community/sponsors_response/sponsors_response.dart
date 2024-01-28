import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:university_app_server_api/src/data/community/models/models.dart';

part 'sponsors_response.g.dart';

@JsonSerializable()
class SponsorsResponse extends Equatable {
  const SponsorsResponse({
    required this.sponsors,
  });

  factory SponsorsResponse.fromJson(Map<String, dynamic> json) => _$SponsorsResponseFromJson(json);

  final List<Sponsor> sponsors;

  Map<String, dynamic> toJson() => _$SponsorsResponseToJson(this);

  @override
  List<Object> get props => [sponsors];
}
