import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../core/network_services/fireBase_data.dart';
import 'message_model.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  final FireBaseData _firebaseData;

  MessageCubit(this._firebaseData) : super(MessageInitial());

  final TextEditingController messageController = TextEditingController();
  StreamSubscription<List<Message>>? _messageSubscription;
  String roomid = '';
  Future<void> fetchMessages(String roomId) async {
    emit(MessagesLoading());
    try {
      this.roomid = roomId;
      _messageSubscription =
          _firebaseData.getMessages(roomid).listen((messages) {
        emit(MessagesLoaded(messages));
      });
    } catch (e) {
      emit(MessagesError('Failed to load messages: $e'));
    }
  }

  Future<void> sendMessage({
    required String toId,
  }) async {
    try {
      if (this.roomid.isNotEmpty) {
        await _firebaseData.createMessage(toId, messageController.text, this.roomid);
        fetchMessages(this.roomid);
      }
    } catch (e) {
      emit(MessagesError('Failed to send message: $e'));
    }
  }

  @override
  Future<void> close() {
    messageController.dispose();
    _messageSubscription!.cancel();
    return super.close();
  }
}
