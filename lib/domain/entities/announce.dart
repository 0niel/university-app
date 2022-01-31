import 'package:equatable/equatable.dart';

class Announce extends Equatable {
  final String name;
  final String text;
  final String date;

  const Announce({
    required this.name,
    required this.text,
    required this.date,
  });

  @override
  List<Object> get props => [name, text, date];
}
