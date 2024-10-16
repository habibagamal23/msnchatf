import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:msnchat/core/network_services/fireBase_data.dart';
import 'package:msnchat/features/home/model/roomModel.dart';

import '../../model/user_info.dart';

part 'rooms_state.dart';

class RoomsCubit extends Cubit<RoomsState> {
  FireBaseData _baseData;
  RoomsCubit(this._baseData) : super(RoomsInitial());

  Future creatrooms(String userid) async {
    emit(RoomsLoading());

    try {
      await _baseData.createRoom(userid);
      emit(RoomsCreated(userid));
    } catch (e) {
      emit(RoomsError(e.toString()));
    }
  }

  StreamSubscription<List<Room>>? streamSubscription;
  StreamSubscription<List<UserProfile>>? streamSubscriptionpr;

  void fetchroom() {
    streamSubscription = _baseData.getAllRooms().listen((rooms) {
      emit(RoomsLoaded(rooms));
    }, onError: (e) {
      emit(RoomsError(e.toString()));
    });
  }

  List<UserProfile> myusers = [];

  Future fetchuserandroom() async {
    emit(RoomsLoading());
    try {
      streamSubscriptionpr = _baseData.getAllUsers().listen((users) {
        myusers = users;
        fetchroom();
      });
    } catch (e) {
      emit(RoomsError(e.toString()));
    }
  }

  UserProfile? getuserprofile(String userid) {
    try {
      return myusers.firstWhere((user) => user.id == userid,
          orElse: () => UserProfile(
                id: "",
                name: 'Unknown',
                about: '',
                email: '',
                phoneNumber: '',
                lastActivated: '',
                createdAt: '',
                pushToken: '',
                online: false,
              ));
    } catch (e) {
      print("user not found ");
      return null;
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
