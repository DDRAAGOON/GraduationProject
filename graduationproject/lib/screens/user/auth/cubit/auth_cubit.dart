import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/services/recruitment_sync_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());

    try {
      await RecruitmentSyncService.instance.login(
        email: email,
        password: password,
      );

      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError("Login failed: $e"));
    }
  }
}
