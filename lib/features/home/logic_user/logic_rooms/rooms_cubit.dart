import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:msnchat/core/network_services/fireBase_data.dart';
import 'package:msnchat/features/home/model/roomModel.dart';

part 'rooms_state.dart';

class RoomsCubit extends Cubit<RoomsState> {
  FireBaseData _baseData;
  RoomsCubit(this._baseData) : super(RoomsInitial());

  Future createRoom(String userid) async {
    emit(RoomsLoading());
    try {
      final roomid = await _baseData.createRoom(userid);
      RoomsCreated(roomid);
    } catch (e) {
      emit(RoomsError("This error created room $e"));
    }
  }

  //
  StreamSubscription<List<Room>>? streamSubscriptionrooms;

  void fetchRooms() {
    streamSubscriptionrooms = _baseData.getAllRooms().listen((rooms) {
      emit(RoomsLoaded(rooms));
    }, onError: (e) {
      emit(RoomsError(e.toString()));
    });
  }

  @override
  Future<void> close() {
    streamSubscriptionrooms?.cancel();
    return super.close();
  }
}
