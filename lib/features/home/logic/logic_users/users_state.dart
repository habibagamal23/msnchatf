part of 'users_cubit.dart';

@immutable
sealed class UsersState {}

final class UsersInitial extends UsersState {}

class UserLoading extends UsersState {}

class UserLoaded extends UsersState {
  final List<UserProfile> users;
  UserLoaded(this.users);
}

class UserProfileLoaded extends UsersState {
  final UserProfile userProfile;
  UserProfileLoaded(this.userProfile);
}

class UserError extends UsersState {
  final String message;
  UserError(this.message);
}
