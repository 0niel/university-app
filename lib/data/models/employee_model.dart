import 'dart:convert';

import 'package:rtu_mirea_app/domain/entities/employee.dart';

class EmployeeModel extends Employee {
  const EmployeeModel({
    required name,
    required secondName,
    required lastName,
    required email,
    required institute,
    required department,
  }) : super(
          name: name,
          secondName: secondName,
          lastName: lastName,
          email: email,
          institute: institute,
          department: department,
        );

  factory EmployeeModel.fromRawJson(String str) => EmployeeModel.fromJson(json.decode(str));

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      name: json["HUMAN"]["NAME"],
      secondName: json["HUMAN"]["SECOND_NAME"],
      lastName: json["HUMAN"]["LAST_NAME"],
      email: json["HUMAN"]["EMAIL"],
      institute: json["HUMAN"]["INSTITUTE"],
      department: json["HUMAN"]["DEPARTMENT"],
    );
  }
}
