import 'package:freezed_annotation/freezed_annotation.dart';

import '../../entities/user.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    User? user,
  }) = _AuthState;
}
