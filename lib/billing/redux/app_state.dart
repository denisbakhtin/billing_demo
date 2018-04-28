import 'package:meta/meta.dart';
import '../models/user.dart';
import '../models/enrollment.dart';

@immutable
class AppState {
  final bool isLoading;
  final String token;
  final String error;
  final UserModel user;
  final EnrollmentsModel enrollments;

  AppState({
    this.isLoading = false,
    this.token,
    this.error,
    this.user,
    this.enrollments,
  });

  factory AppState.loading() => new AppState(isLoading: true);

  AppState copyWith({
    bool isLoading,
    String token,
    UserModel user,
    EnrollmentsModel enrollments,
    String error,
  }) {
    return new AppState(
      isLoading: isLoading ?? this.isLoading,
      token: token ?? this.token,
      error: error ?? this.error,
      user: user ?? this.user,
      enrollments: enrollments ?? this.enrollments,
    );
  }

  @override
  int get hashCode =>
      isLoading.hashCode ^
      user.hashCode ^
      token.hashCode ^
      error.hashCode ^
      enrollments.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          token == other.token &&
          user == other.user &&
          enrollments == other.enrollments &&
          error == other.error;

  @override
  String toString() {
    return 'AppState{isLoading: $isLoading, user: $user, token: $token, enrollments: $enrollments, error: $error}';
  }
}
