import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:msnchat/features/home/logic/rooms_cubit/rooms_cubit.dart';
import 'package:msnchat/features/home/ui/card.dart';

import '../../../core/network_services/fireBase_data.dart';
import '../../../core/network_services/firebase_sevice.dart';
import '../../../core/utils/styles.dart';
import '../../../core/utils/routes.dart';
import '../logic/logic_users/users_cubit.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RoomsCubit(FireBaseData())..fetchAllData(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.settings,
                color: ColorsManager.mainBlue,
              )),
          toolbarHeight: 80,
          title: const Text(
            "Chats Screen",
            style: TextStyle(
                color: ColorsManager.mainBlue,
                fontSize: 30,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.logout,
                color: ColorsManager.mainBlue,
              ),
              onPressed: () async {
                await FirebaseService().logout();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.loginScreen,
                  (route) => false,
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: ColorsManager.mainBlue,
          onPressed: () {
            context.read<UsersCubit>().fetchAllUsers();
            Navigator.pushNamed(context, Routes.selectUserScreen);
          },
          child: const Icon(
            Icons.chat,
            color: ColorsManager.whitebeg,
          ),
        ),
        body: BlocBuilder<RoomsCubit, RoomsState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is HomeLoaded) {
              if (state.rooms.isEmpty) {
                return const Center(child: Text("No chats available"));
              }

              return ListView.builder(
                itemCount: state.rooms.length,
                itemBuilder: (context, index) {
                  final chatRoom = state.rooms[index];

                  // Safely find the other user in the room
                  final otherUserId = chatRoom.members.firstWhere(
                    (id) => id != FireBaseData().myUid,
                    orElse: () =>
                        'Unknown', // Provide a fallback value if no other user is found
                  );

                  // Fetch the user profile from the cached users in HomeCubit
                  final userProfile =
                      context.read<RoomsCubit>().getUserProfile(otherUserId);

                  if (otherUserId == 'Unknown' || userProfile == null) {
                    return ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('No other user found'),
                      subtitle: const Text('Room contains only your ID'),
                    );
                  }

                  return UserCard(userProfile: userProfile);
                },
              );
            }

            if (state is HomeError) {
              return Center(child: Text('Error: ${state.message}'));
            }

            return const Center(child: Text("No chats available"));
          },
        ),
      ),
    );
  }
}
