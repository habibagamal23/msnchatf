import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/network_services/fireBase_data.dart';
import '../../../register/model/user_info.dart';
import '../../model/roomModel.dart';

part 'rooms_state.dart';

class RoomsCubit extends Cubit<RoomsState> {
  final FireBaseData _firebaseService;

  RoomsCubit(this._firebaseService) : super(RoomsInitial());

  final myUid = FireBaseData().myUid;

  StreamSubscription<List<Room>>? _chatRoomsSubscription;
  StreamSubscription<List<UserProfile>>? _usersSubscription;

  List<UserProfile> _cachedUsers = [];

  Future<void> fetchAllData() async {
    emit(HomeLoading());
    try {
      _usersSubscription = _firebaseService.fetchAllUsers().listen((users) {
        _cachedUsers = users;
        print('Fetched users: ${_cachedUsers.map((user) => user.id).toList()}');
        _chatRoomsSubscription = _firebaseService.getAllChats().listen((rooms) {
          emit(HomeLoaded(rooms));
        });
      });
    } catch (e) {
      emit(HomeError('Error fetching data: $e'));
    }
  }

  Future<void> createRoom(String userId) async {
    emit(HomeLoading());
    try {
      final roomId = await _firebaseService.createRoom(userId);
      emit(ChatRoomCreated(roomId));
    } catch (e) {
      print('Error creating room: $e');
      emit(HomeError(e.toString()));
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

  @override
  Future<void> close() {
    _chatRoomsSubscription?.cancel();
    _usersSubscription?.cancel();
    return super.close();
  }
}
