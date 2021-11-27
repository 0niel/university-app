part of 'employee_bloc.dart';

abstract class EmployeeState extends Equatable {
  const EmployeeState();

  @override
  List<Object> get props => [];
}

class EmployeeInitial extends EmployeeState {}

class EmployeeLoading extends EmployeeState {}

class EmployeeLoaded extends EmployeeState {
  final List<Employee> employees;

  const EmployeeLoaded({required this.employees});

  @override
  List<Object> get props => [employees];
}

class EmployeeItemsNotFound extends EmployeeState {}

class EmployeeLoadError extends EmployeeState {}
