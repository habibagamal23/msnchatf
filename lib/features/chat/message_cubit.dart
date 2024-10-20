import 'dart:async';
import 'dart:io';

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
  String roomId = '';

  Future<void> fetchMessages(String roomId) async {
    emit(MessagesLoading());
    try {
      this.roomId = roomId;
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
    required String type,
    String? imageUrl,
  }) async {
    try {
      if (this.roomId.isNotEmpty) {
        // Handle text or image message
        String msgContent =
            (type == 'text') ? messageController.text : imageUrl!;

        await _firebaseData.createMessage(
          toId,
          msgContent,
          this.roomId,
          type: type,
        );

        if (type == 'text') {
          messageController.clear();
        }

        fetchMessages(this.roomId);
      }
    } catch (e) {
      emit(MessagesError('Failed to send message: $e'));
    }
  }

  Future<void> sendImage(File file, String toId) async {
    try {
      if (this.roomId.isNotEmpty) {
        String imageUrl = await _firebaseData.uploadImage(file, this.roomId);
//
        print("send imge");
        await sendMessage(toId: toId, type: 'image', imageUrl: imageUrl);
      }
    } catch (e) {
      emit(MessagesError('Failed to upload image or send message: $e'));
    }
  }

  @override
  Future<void> close() {
    messageController.dispose();
    _messageSubscription?.cancel();
    return super.close();
  }
}
