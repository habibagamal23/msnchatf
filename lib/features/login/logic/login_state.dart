part of 'login_cubit.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading  extends LoginState {}
final class LoginSuces extends LoginState {
  final User? user;
  LoginSuces(this.user);
}
final class LoginFeliuer extends LoginState {
  final String errom;
  LoginFeliuer(this.errom);
}
final class LoginpassToggle extends LoginState {
  final bool isPassvisable;
  LoginpassToggle(this.isPassvisable);

}

