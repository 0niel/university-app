import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/domain/entities/employee.dart';
import 'package:rtu_mirea_app/domain/usecases/get_employees.dart';

part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final GetEmployees getEmployees;

  EmployeeBloc({required this.getEmployees}) : super(EmployeeInitial()) {
    on<LoadEmployees>(_onLoadEmployees);
  }

  void _onLoadEmployees(
    LoadEmployees event,
    Emitter<EmployeeState> emit,
  ) async {
    if (event.name.length > 2) {
      emit(EmployeeLoading());

      final employees =
          await getEmployees(GetEmployeesParams(event.token, event.name));

      employees.fold((failure) => emit(EmployeeLoadError()), (result) {
        if (result.isEmpty) {
          emit(EmployeeItemsNotFound());
        } else {
          emit(EmployeeLoaded(employees: result));
        }
      });
    }
  }
}
