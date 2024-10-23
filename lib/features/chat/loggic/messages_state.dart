part of 'messages_cubit.dart';

@immutable
sealed class MessagesState {}

final class MessagesInitial extends MessagesState {}

final class MessagesLoading extends MessagesState {}

final class MessagesSuccess extends MessagesState {
  final List<Message> messages;
  MessagesSuccess(this.messages);
}

final class MessagesError extends MessagesState {
  final String error;
  MessagesError(this.error);
}
