
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'edu_program.g.dart';

@JsonSerializable()
class EduProgram extends Equatable {
  const EduProgram({
    required this.eduProgram,
    required this.eduProgramCode,
    required this.department,
    required this.prodDepartment,
    this.type,
  });
  // factory EduProgram.fromRawJson(String str) =>
  //     EduProgram.fromJson(json.decode(str));

  // factory EduProgram.fromJson(Map<String, dynamic> json) {
  //   return EduProgram(
  //     eduProgramCode: json["PROPERTIES"]["OKSO_CODE"]["VALUE"] as String,
  //     eduProgram: json["NAME"] as String,
  //     department: json["PROPERTIES"]["DEPARTMENT"]["VALUE_TEXT"] as String,
  //     prodDepartment:
  //         json["PROPERTIES"]["PROD_DEPARTMENT"]["VALUE_TEXT"] as String?,
  //   );
  // }

  /// Converts `Map<String, dynamic>` to [EduProgram].
  factory EduProgram.fromJson(Map<String, dynamic> json) =>
      _$EduProgramFromJson(json);

  /// Name of the educational program. For example,
  /// "Прикладная математика и информатика".
  @JsonKey(name: 'NAME')
  final String eduProgram;

  /// Code of the educational program. For example, "09.03.02".
  @JsonKey(name: 'PROPERTIES.OKSO_CODE.VALUE', fromJson: _eduProgramCodeFromJson)
  final String eduProgramCode;

  static String _eduProgramCodeFromJson(Map<String, dynamic> json) {
    return json['PROPERTIES']['OKSO_CODE']['VALUE'] as String;
  }

  /// Faculty.
  @JsonKey(name: 'PROPERTIES.DEPARTMENT.VALUE_TEXT'
  final String department;

  /// Department.
  @JsonKey(name: 'PROPERTIES.PROD_DEPARTMENT.VALUE_TEXT')
  final String prodDepartment;

  /// Form of education. For example, "очная".
  @JsonKey(name: 'PROPERTIES.TYPE.VALUE_TEXT')
  final String? type;

  /// Converts [EduProgram] instance to `Map<String, dynamic>`.
  Map<String, dynamic> toJson() => _$EduProgramToJson(this);

  @override
  List<Object?> get props => [
        eduProgram,
        eduProgramCode,
        department,
        prodDepartment,
      ];
}
