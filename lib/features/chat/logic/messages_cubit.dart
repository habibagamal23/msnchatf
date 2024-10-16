import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../core/network_services/fireBase_data.dart';
import '../model/massegemodel.dart';

part 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  final FireBaseData _firebaseData;

  MessagesCubit(this._firebaseData) : super(MessagesInitial());

  final TextEditingController messageController = TextEditingController();
  StreamSubscription<List<Message>>? _messageSubscription;

  /// Fetch messages for a given room
  void fetchMessages(String roomId) {
    emit(MessagesLoading());
    try {
      _messageSubscription =
          _firebaseData.getMessages(roomId).listen((messages) {
        emit(MessagesLoaded(messages));
      });
    } catch (e) {
      emit(MessagesError('Failed to load messages: $e'));
    }
  }

  Future<void> sendMessage({
    required String toId,
    required String roomId,
  }) async {
    try {
      await _firebaseData.sendMessage(toId, messageController.text, roomId);

      messageController.clear();
    } catch (e) {
      emit(MessagesError('Failed to send message: $e'));
    }
  }

  Future<void> markMessageAsSeen({
    required String roomId,
    required String messageId,
  }) async {
    try {
      await _firebaseData.seenMessage(chatroomId: roomId, messageId: messageId);
    } catch (e) {
      emit(MessagesError('Failed to mark message as seen: $e'));
    }
  }

  @override
  Future<void> close() {
    messageController.dispose();
    _messageSubscription!.cancel();
    return super.close();
  }
}
