part of 'rooms_cubit.dart';

@immutable
sealed class RoomsState {}

final class RoomsInitial extends RoomsState {}

final class RoomsLoading extends RoomsState {}

final class RoomsLoaded extends RoomsState {
  final List<Room> rooms;
  RoomsLoaded(this.rooms);
}
final class RoomsCreated extends RoomsState {
  final String roomId;
  RoomsCreated(this.roomId);
}



final class RoomsError extends RoomsState {
  final String err;
  RoomsError(this.err);
}
