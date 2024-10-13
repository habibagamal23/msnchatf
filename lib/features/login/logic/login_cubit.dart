import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../../core/network_services/firebase_sevice.dart';
import '../model/login_model.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final FirebaseService _auth;
  LoginCubit(this._auth) : super(LoginInitial());

  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool ispass = false;

  void togglepass() {
    ispass = !ispass;
    emit(LoginpassToggle(ispass));
  }

  Future login() async {
    if (!formKey.currentState!.validate()) {
      emit(LoginFeliuer('Please fill in all fields correctly.'));
      return;
    }
    emit(LoginLoading());
    try {
      LoginRequestBody mymodel =
          LoginRequestBody(email: email.text, password: pass.text);

      User? user = await _auth.login(mymodel);

      if (user != null) {
        emit(LoginSuces(user));
      } else {
        emit(LoginFeliuer("login is feluier"));
      }
    } catch (e) {
      emit(LoginFeliuer("$e  is error "));
    }
  }

  Future<void> loginWithGoogle() async {
    emit(LoginLoading()); // Emit loading state
    try {
      // Attempt to log in using Google Sign-In
      User? user = await _auth.loginWithGoogle();

      if (user != null) {
        // If login is successful, emit the success state
        emit(LoginSuces(user));
      } else {
        // Emit failure state if user cancels or login fails
        emit(LoginFeliuer("Google login was canceled or failed."));
      }
    } catch (e) {
      // Emit failure state if there is an error
      emit(LoginFeliuer("Google login error: $e"));
    }
  }

  @override
  Future<void> close() {
    email.dispose();
    pass.dispose();
    return super.close();
  }
}
