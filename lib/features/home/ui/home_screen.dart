import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:msnchat/core/network_services/fireBase_data.dart';
import 'package:msnchat/features/home/logic_user/logic_rooms/rooms_cubit.dart';
import 'package:msnchat/features/home/logic_user/users_cubit.dart';

import '../../../core/network_services/firebase_sevice.dart';
import '../../../core/utils/styles.dart';
import '../../../core/utils/routes.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RoomsCubit(FireBaseData())..fetchRooms(),
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
              context.read<UsersCubit>().fetchAlluserWithoutme();
              Navigator.pushNamed(context, Routes.selectUserScreen);
            },
            child: const Icon(
              Icons.chat,
              color: ColorsManager.whitebeg,
            ),
          ),
          body: BlocBuilder<RoomsCubit, RoomsState>(builder: (context, state) {
            if (state is RoomsLoading) {
              return Center(child: const CircularProgressIndicator());
            }

            if (state is RoomsLoaded) {
              return ListView.builder(
                  itemCount: state.rooms.length,
                  itemBuilder: (context, index) {
                    final chatroom = state.rooms[index];
                    return ListTile(
                      title: Text(chatroom.id),
                    );
                  });
            }

            if (state is RoomsError) {
              return Text(state.err);
            }
            return Text("no rooms");
          })),
    );
  }
}
