import 'dart:convert';

import 'package:rtu_mirea_app/domain/entities/employee.dart';

class EmployeeModel extends Employee {
  const EmployeeModel({
    required name,
    required secondName,
    required lastName,
    required email,
    required employmentKind,
    required employmentDate,
    required rate,
    required fireDate,
    required post,
    required department,
  }) : super(
          name: name,
          secondName: secondName,
          lastName: lastName,
          email: email,
          employmentKind: employmentKind,
          employmentDate: employmentDate,
          rate: rate,
          fireDate: fireDate,
          post: post,
          department: department,
        );

  factory EmployeeModel.fromRawJson(String str) =>
      EmployeeModel.fromJson(json.decode(str));

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      name: json["HUMAN"]["NAME"],
      secondName: json["HUMAN"]["SECOND_NAME"],
      lastName: json["HUMAN"]["LAST_NAME"],
      email: json["HUMAN"]["EMAIL"],
      employmentKind: json["EMPLOYEE"]["PROPERTIES"]["EMPLOYMENT_KIND"]
          ["VALUE"],
      employmentDate: json["EMPLOYEE"]["PROPERTIES"]["EMPLOYMENT_DATE"]
          ["VALUE"],
      rate: json["EMPLOYEE"]["PROPERTIES"]["RATE"]["VALUE"],
      fireDate: json["EMPLOYEE"]["PROPERTIES"]["FIRE_DATE"]["VALUE"],
      post: json["EMPLOYEE"]["PROPERTIES"]["POST"]["VALUE"],
      department: json["EMPLOYEE"]["PROPERTIES"]["DEPARTMENT"]["VALUE"],
    );
  }
}
