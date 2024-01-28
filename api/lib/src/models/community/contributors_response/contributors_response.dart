import 'package:equatable/equatable.dart';
import 'package:github/github.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contributors_response.g.dart';

@JsonSerializable()
class ContributorsResponse extends Equatable {
  const ContributorsResponse({
    required this.contributors,
  });

  factory ContributorsResponse.fromJson(Map<String, dynamic> json) => _$ContriubutorsResponseFromJson(json);

  final List<Contributor> contributors;

  Map<String, dynamic> toJson() => _$ContriubutorsResponseToJson(this);

  @override
  List<Object> get props => [contributors];
}
