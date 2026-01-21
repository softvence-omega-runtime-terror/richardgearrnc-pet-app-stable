import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// Represents an authenticated user.
///
/// Uses Freezed for:
/// - Immutability
/// - Value equality
/// - copyWith
/// - JSON serialization
///
/// JSON fields use snake_case (e.g., 'is_email_verified', 'created_at')
/// and are automatically mapped to camelCase Dart properties.
@freezed
abstract class User with _$User {
  /// Creates a [User] instance.
  const factory User({
    required final String id,
    required final String email,
    final String? name,
    @JsonKey(name: 'avatar_url') final String? avatarUrl,
    @JsonKey(name: 'is_email_verified')
    @Default(false)
    final bool isEmailVerified,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
  }) = _User;

  /// Creates a [User] instance from JSON.
  factory User.fromJson(final Map<String, dynamic> json) =>
      _$UserFromJson(json);
}
