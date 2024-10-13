part of 'rooms_cubit.dart';

@immutable
sealed class RoomsState {}

final class RoomsInitial extends RoomsState {}

class HomeLoading extends RoomsState {}

class ChatRoomCreated extends RoomsState {
  final String roomId;
  ChatRoomCreated(this.roomId);
}

class HomeLoaded extends RoomsState {
  final List<Room> rooms;
  final List<UserProfile> users;
  HomeLoaded(this.rooms, this.users);
}

class HomeError extends RoomsState {
  final String message;
  HomeError(this.message);
}

