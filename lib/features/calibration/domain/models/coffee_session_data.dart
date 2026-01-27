import 'package:equatable/equatable.dart';

class CoffeeSessionData extends Equatable {
  final String brandName;
  final String variety;
  final String origin;
  final String process;
  final String roastType;
  final DateTime roastDate;
  final int restDays; // Calculado automáticamente
  final int sampleCount;
  final String extraNotes;

  const CoffeeSessionData({
    required this.brandName,
    required this.variety,
    required this.origin,
    required this.process,
    required this.roastType,
    required this.roastDate,
    required this.restDays,
    required this.sampleCount,
    required this.extraNotes,
  });

  factory CoffeeSessionData.empty() {
    return CoffeeSessionData(
      brandName: '',
      variety: '',
      origin: '',
      process: '',
      roastType: '',
      roastDate: DateTime.now(),
      restDays: 0,
      sampleCount: 1,
      extraNotes: '',
    );
  }

  int getCalculatedRestDays() {
    final today = DateTime.now();
    return today.difference(roastDate).inDays;
  }

  CoffeeSessionData copyWith({
    String? brandName,
    String? variety,
    String? origin,
    String? process,
    String? roastType,
    DateTime? roastDate,
    int? restDays,
    int? sampleCount,
    String? extraNotes,
  }) {
    final newRoastDate = roastDate ?? this.roastDate;
    return CoffeeSessionData(
      brandName: brandName ?? this.brandName,
      variety: variety ?? this.variety,
      origin: origin ?? this.origin,
      process: process ?? this.process,
      roastType: roastType ?? this.roastType,
      roastDate: newRoastDate,
      restDays: newRoastDate != roastDate ? newRoastDate.difference(DateTime.now()).inDays.abs() : (restDays ?? this.restDays),
      sampleCount: sampleCount ?? this.sampleCount,
      extraNotes: extraNotes ?? this.extraNotes,
    );
  }

  @override
  List<Object?> get props => [
    brandName,
    variety,
    origin,
    process,
    roastType,
    roastDate,
    restDays,
    sampleCount,
    extraNotes,
  ];
}
