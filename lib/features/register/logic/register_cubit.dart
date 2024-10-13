import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network_services/firebase_sevice.dart';
import '../model/register_model.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final FirebaseService _firebaseService;

  RegisterCubit(this._firebaseService) : super(RegisterInitial());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> register() async {
    if (!formKey.currentState!.validate()) {
      emit(RegisterFailure('Please fill in all fields correctly.'));
      return;
    }
    emit(RegisterLoading());
    try {
      RegisterRequestBody registerRequestBody = RegisterRequestBody(
        email: emailController.text,
        password: passwordController.text,
        name: usernameController.text,
        phoneNumber: phoneController.text,
      );

      User? user = await _firebaseService.register(registerRequestBody);

      if (user != null) {
        emit(RegisterSuccess(user: user));
      } else {
        emit(RegisterFailure('Registration failed. Please try again.'));
      }
    } catch (e) {
      emit(RegisterFailure('Registration failed. Error: $e'));
    }
  }

  bool isPasswordVisible = false;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    emit(RegisterPasswordVisibilityToggled(isPasswordVisible));
  }

  Future<void> registerWithGoogle() async {
    emit(RegisterLoading());
    try {
      // Call FirebaseService to register with Google
      await _firebaseService.registerWithGoogle();

      emit(RegisterSuccess(user: FirebaseAuth.instance.currentUser));
    } catch (e) {
      emit(RegisterFailure('Google registration failed. Error: $e'));
    }
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    phoneController.dispose();
    return super.close();
  }
}
