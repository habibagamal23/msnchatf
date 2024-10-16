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
}
