part of 'resetpass_cubit.dart';

@immutable
sealed class ResetpassState {}

final class ResetpassInitial extends ResetpassState {}

class ResetpassLoading extends ResetpassState {}

class ResetpassSuccess extends ResetpassState {
  final String message;

  ResetpassSuccess(this.message);
}

class ResetpassFailure extends ResetpassState {
  final String error;

  ResetpassFailure(this.error);
}
