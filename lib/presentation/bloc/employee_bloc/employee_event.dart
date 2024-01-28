part of 'employee_bloc.dart';

abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();
}

class LoadEmployees extends EmployeeEvent with AnalyticsEventMixin {
  final String name;

  const LoadEmployees({required this.name});

  @override
  List<Object> get props => [name];

  @override
  AnalyticsEvent get event => AnalyticsEvent('LoadEmployees', properties: {'name': name});
}
