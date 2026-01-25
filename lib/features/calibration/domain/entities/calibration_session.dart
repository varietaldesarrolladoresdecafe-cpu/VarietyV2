import 'package:equatable/equatable.dart';

class CalibrationSession extends Equatable {
  final String id;
  final String coffeeName;
  final String method; // Espresso, V60, etc.
  final DateTime date;

  const CalibrationSession({
    required this.id,
    required this.coffeeName,
    required this.method,
    required this.date,
  });

  @override
  List<Object?> get props => [id, coffeeName, method, date];
}