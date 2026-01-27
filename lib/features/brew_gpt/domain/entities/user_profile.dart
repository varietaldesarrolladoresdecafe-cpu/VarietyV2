import 'package:equatable/equatable.dart';

enum SkillLevel { beginner, intermediate, advanced }

enum WaterType { tap, filtered, distilled, bottled, mineral }

class UserProfile extends Equatable {
  final String id;
  final String name;
  final SkillLevel skillLevel;
  final String favoriteMethod;
  final String location;
  final WaterType waterType;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfile({
    required this.id,
    required this.name,
    required this.skillLevel,
    required this.favoriteMethod,
    required this.location,
    required this.waterType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.empty() {
    return UserProfile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'Amante del Café',
      skillLevel: SkillLevel.beginner,
      favoriteMethod: 'V60',
      location: 'Desconocida',
      waterType: WaterType.filtered,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  UserProfile copyWith({
    String? id,
    String? name,
    SkillLevel? skillLevel,
    String? favoriteMethod,
    String? location,
    WaterType? waterType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      skillLevel: skillLevel ?? this.skillLevel,
      favoriteMethod: favoriteMethod ?? this.favoriteMethod,
      location: location ?? this.location,
      waterType: waterType ?? this.waterType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    skillLevel,
    favoriteMethod,
    location,
    waterType,
    createdAt,
    updatedAt,
  ];
}
