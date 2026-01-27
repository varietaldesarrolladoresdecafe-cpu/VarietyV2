import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user_profile.dart';

abstract class UserProfileLocalDataSource {
  Future<UserProfile?> getUserProfile();
  Future<void> saveUserProfile(UserProfile profile);
  Future<void> deleteUserProfile();
}

class UserProfileLocalDataSourceImpl implements UserProfileLocalDataSource {
  final SharedPreferences preferences;
  static const String _userProfileKey = 'user_profile';

  UserProfileLocalDataSourceImpl({required this.preferences});

  @override
  Future<UserProfile?> getUserProfile() async {
    try {
      final jsonString = preferences.getString(_userProfileKey);
      if (jsonString == null) {
        return null;
      }

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return _parseUserProfile(json);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveUserProfile(UserProfile profile) async {
    final json = _profileToJson(profile);
    await preferences.setString(_userProfileKey, jsonEncode(json));
  }

  @override
  Future<void> deleteUserProfile() async {
    await preferences.remove(_userProfileKey);
  }

  UserProfile _parseUserProfile(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      skillLevel: _parseSkillLevel(json['skillLevel']),
      favoriteMethod: json['favoriteMethod'] ?? '',
      location: json['location'] ?? '',
      waterType: _parseWaterType(json['waterType']),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> _profileToJson(UserProfile profile) {
    return {
      'id': profile.id,
      'name': profile.name,
      'skillLevel': profile.skillLevel.toString().split('.').last,
      'favoriteMethod': profile.favoriteMethod,
      'location': profile.location,
      'waterType': profile.waterType.toString().split('.').last,
      'createdAt': profile.createdAt.toIso8601String(),
      'updatedAt': profile.updatedAt.toIso8601String(),
    };
  }

  SkillLevel _parseSkillLevel(dynamic value) {
    if (value == null) return SkillLevel.beginner;
    final stringValue = value.toString().toLowerCase();
    switch (stringValue) {
      case 'intermediate':
        return SkillLevel.intermediate;
      case 'advanced':
        return SkillLevel.advanced;
      default:
        return SkillLevel.beginner;
    }
  }

  WaterType _parseWaterType(dynamic value) {
    if (value == null) return WaterType.filtered;
    final stringValue = value.toString().toLowerCase();
    switch (stringValue) {
      case 'tap':
        return WaterType.tap;
      case 'distilled':
        return WaterType.distilled;
      case 'bottled':
        return WaterType.bottled;
      case 'mineral':
        return WaterType.mineral;
      default:
        return WaterType.filtered;
    }
  }
}
