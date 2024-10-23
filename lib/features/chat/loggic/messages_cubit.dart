import 'dart:async';
import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:msnchat/core/network_services/fireBase_data.dart';
import 'package:msnchat/features/chat/model/message_model.dart';

part 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  final FireBaseData fireBaseData;
  MessagesCubit(this.fireBaseData) : super(MessagesInitial());

  final TextEditingController messageContrller = TextEditingController();
  StreamSubscription<List<Message>>? messgessub;
  String roommyId = "";
  Future<void> fetchMessages(String roomId) async {
    emit(MessagesLoading());
    try {
      roommyId = roomId;
      messgessub = fireBaseData.getMessages(roomId).listen((messages) {
        emit(MessagesSuccess(messages));
      });
    } catch (e) {
      emit(MessagesError(e.toString()));
    }
  }

  Future sendMessage(String toid, String type, {String? imgURl}) async {
    try {
      if (roommyId.isNotEmpty) {
        String msg = (type == "text") ? messageContrller.text : imgURl!;
        await fireBaseData.createMessage(toid, msg, roommyId, type);
      }

      await fetchMessages(roommyId);
    } catch (e) {
      emit(MessagesError(e.toString()));
    }
  }

  Future sendImage(File file, String toid) async {
    try {
      if (roommyId.isNotEmpty) {
        String urlimage = await fireBaseData.imageSorge(file, roommyId);
        await sendMessage(toid, 'image', imgURl: urlimage);
      }
    } catch (e) {
      emit(MessagesError(e.toString()));
    }
  }
}
