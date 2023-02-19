part of 'employee_bloc.dart';

abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object> get props => [];
}

class LoadEmployees extends EmployeeEvent {
  final String name;

  const LoadEmployees({required this.name});

  @override
  List<Object> get props => [name];
}
