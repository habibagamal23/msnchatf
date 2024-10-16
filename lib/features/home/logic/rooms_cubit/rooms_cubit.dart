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

  final String myUid = FireBaseData().myUid;

  StreamSubscription<List<Room>>? _chatRoomsSubscription;
  StreamSubscription<List<UserProfile>>? _usersSubscription;

  List<UserProfile> _cachedUsers = [];

  Future<void> fetchAllData() async {
    emit(HomeLoading());
    try {
      _usersSubscription = _firebaseService.fetchAllUsers().listen((users) {
        _cachedUsers = users;
        fetchChatRooms();
      });
    } catch (e) {
      emit(HomeError('Error fetching users: $e'));
    }
  }

  void fetchChatRooms() {
    _chatRoomsSubscription = _firebaseService.getAllChats().listen((rooms) {
      emit(HomeLoaded(rooms));
    }, onError: (e) {
      emit(HomeError('Error fetching chat rooms: $e'));
    });
  }

  Future<void> createRoom(String userId) async {
    emit(HomeLoading());
    try {
      final roomId = await _firebaseService.createRoom(userId);
      emit(ChatRoomCreated(roomId));
    } catch (e) {
      emit(HomeError('Error creating room: $e'));
    }
  }

  UserProfile? getUserProfile(String userId) {
    return _cachedUsers.firstWhere(
      (user) => user.id == userId,
      orElse: () => _defaultUnknownUser(),
    );
  }

  UserProfile _defaultUnknownUser() {
    return UserProfile(
      id: "",
      name: "Unknown User",
      email: "",
      about: "",
      phoneNumber: "",
      createdAt: "",
      lastActivated: "",
      pushToken: "",
      online: false,
    );
  }

  @override
  Future<void> close() {
    _chatRoomsSubscription?.cancel();
    _usersSubscription?.cancel();
    return super.close();
  }
}
