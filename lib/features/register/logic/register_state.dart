part of 'register_cubit.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final User? user;
  RegisterSuccess({required this.user});
}

class RegisterFailure extends RegisterState {
  final String errorMessage;
  RegisterFailure(this.errorMessage);
}

class RegisterPasswordVisibilityToggled extends RegisterState {
  final bool isPasswordVisible;
  RegisterPasswordVisibilityToggled(this.isPasswordVisible);
}
