import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/network_services/fireBase_data.dart';
import '../../../../core/network_services/firebase_sevice.dart';
import '../../../register/model/user_info.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  final FireBaseData _firebaseService;

  UsersCubit(this._firebaseService) : super(UsersInitial());

  StreamSubscription<List<UserProfile>>? _usersSubscription;

  void fetchAllUsers() {
    emit(UserLoading());
    _usersSubscription = _firebaseService.fetchAllUsersWithoutme().listen(
      (users) {
        emit(UserLoaded(users));
      },
      onError: (e) {
        emit(UserError(e.toString())); // Handle errors
      },
    );
  }

  @override
  Future<void> close() {
    _usersSubscription?.cancel();
    return super.close();
  }
}
