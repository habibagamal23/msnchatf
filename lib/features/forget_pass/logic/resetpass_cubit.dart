import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../core/network_services/firebase_sevice.dart';

part 'resetpass_state.dart';

class ResetpassCubit extends Cubit<ResetpassState> {
  ResetpassCubit(this._auth) : super(ResetpassInitial());
  final FirebaseService _auth;

  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> sendPasswordResetEmail() async {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      emit(ResetpassLoading());

      try {
        await _auth.resetPass(emailController.text);
        emit(ResetpassSuccess('Password reset email sent. Check your inbox.'));
      } catch (error) {
        emit(ResetpassFailure(error.toString()));
      }
    } else {
      emit(ResetpassFailure('Please provide a valid email address.'));
    }
  }

  @override
  Future<void> close() {
    emailController.dispose();
    return super.close();
  }
}
