part of 'messages_cubit.dart';

@immutable
sealed class MessagesState {}

final class MessagesInitial extends MessagesState {}

class MessagesLoading extends MessagesState {}

class MessagesLoaded extends MessagesState {
  final List<Message> messages;
  MessagesLoaded(this.messages);
}

class MessagesError extends MessagesState {
  final String error;

  MessagesError(this.error);
}
