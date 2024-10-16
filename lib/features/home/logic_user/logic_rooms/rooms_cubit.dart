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

  Future<void>  createRoom(String userid) async {
    emit(RoomsLoading());
    try {
      final roomid = await _baseData.createRoom(userid);
      RoomsCreated(roomid);
    } catch (e) {
      emit(RoomsError("This error created room $e"));
    }
  }

  StreamSubscription<List<UserProfile>>? _usersSubscription;
  List<UserProfile> _cachedUsers = [];

  Future<void> fetchAllData() async {
    emit(RoomsLoading());
    try {
      _usersSubscription = _baseData.getAllUsers().listen((users) {
        _cachedUsers = users;
        print('Fetched users');
        fetchRooms();
      });
    } catch (e) {
      emit(RoomsError('Error fetching users: $e'));
    }
  }

  UserProfile? getUserProfile(String userId) {
    try {
      return _cachedUsers.firstWhere(
            (user) => user.id == userId,
        orElse: () => UserProfile(
          id: "",
          name: "Unknown User",
          email: "",
          about: "",
          phoneNumber: "",
          createdAt: "",
          lastActivated: "",
          pushToken: "",
          online: false,
        ),
      );
    } catch (e) {
      print('User not found: $userId');
      return null;
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
    _usersSubscription?.cancel();
    return super.close();
  }
}
