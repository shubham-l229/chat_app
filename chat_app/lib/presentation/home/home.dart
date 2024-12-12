import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/bloc/users/users_bloc.dart';
import 'package:chat_app/presentation/ai_chat/ai_chat_screen.dart';
import 'package:chat_app/utils/colors.dart' as cs;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../data/injection/dependency_injection.dart';
import '../../data/local/cache_manager.dart';
import '../../services/one_signal_services.dart';
import '../../services/socket_services.dart';
import '../chat/chat_screen.dart';

class Home extends StatelessWidget {
  final UsersBloc _usersBloc;
  CacheManager cacheManager = CacheManager();

  Home({super.key}) : _usersBloc = UsersBloc() {
    _usersBloc.add(GetUsers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AiChatScreen()));
        },
        child: Image.asset(
          "assets/chat.png",
          height: 30,
          width: 30,
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
          child: SafeArea(
              child: BlocConsumer(
        bloc: _usersBloc,
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return state is GetUserLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : state is GetUserFailed
                  ? Container(
                      child: const Text("Failed to get response"),
                    )
                  : state is GetUserSuccess
                      ? StreamBuilder(
                          stream: getIt<SocketServices>().onlineUserStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<dynamic> onlineUsers =
                                  snapshot.data as List<dynamic>;
                              return ListView.builder(
                                  itemCount: state.usersModel.users!.length,
                                  itemBuilder: (buildContext, i) {
                                    return state.usersModel.users![i].id ==
                                            getIt<CacheManager>().getUserId()
                                        ? const SizedBox.shrink()
                                        : InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ChatScreen(
                                                            user: state
                                                                .usersModel
                                                                .users![i],
                                                          )));
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color:
                                                    cs.Colors().backGroundColor,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: cs.Colors()
                                                        .appBarColors
                                                        .withOpacity(0.2),
                                                    spreadRadius: 5,
                                                    blurRadius: 7,
                                                    offset: Offset(0,
                                                        3), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 10),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    flex: 3,
                                                    child: Stack(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      children: [
                                                        Container(
                                                          height: 75,
                                                          width: 75,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          45)),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        45),
                                                            child:
                                                                CachedNetworkImage(
                                                              fit: BoxFit.cover,
                                                              height: 75,
                                                              width: 75,
                                                              imageUrl: state
                                                                  .usersModel
                                                                  .users![i]
                                                                  .profileImageUrl!,
                                                              placeholder: (context,
                                                                      url) =>
                                                                  Center(
                                                                      child:
                                                                          CircularProgressIndicator()),
                                                              errorWidget:
                                                                  (context, url,
                                                                          error) =>
                                                                      Icon(
                                                                Icons.error,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Icon(
                                                          Icons.circle,
                                                          size: 20,
                                                          color: onlineUsers
                                                                  .contains(state
                                                                      .usersModel
                                                                      .users![i]
                                                                      .id)
                                                              ? Colors.green
                                                              : Colors.red,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                      flex: 8,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              state
                                                                  .usersModel
                                                                  .users![i]
                                                                  .name!,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          Text(
                                                              state
                                                                  .usersModel
                                                                  .users![i]
                                                                  .phone!,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold))
                                                        ],
                                                      ))
                                                ],
                                              ).paddingSymmetric(
                                                  horizontal: 5, vertical: 10),
                                            ),
                                          );
                                  });
                            }
                            return ListView.builder(
                                itemCount: state.usersModel.users!.length,
                                itemBuilder: (buildContext, i) {
                                  return state.usersModel.users![i].id ==
                                          getIt<CacheManager>().getUserId()
                                      ? const SizedBox.shrink()
                                      : Container(
                                          decoration: BoxDecoration(
                                            color: cs.Colors().backGroundColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: cs.Colors()
                                                    .appBarColors
                                                    .withOpacity(0.2),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: Offset(0,
                                                    3), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              45)),
                                                  child: CachedNetworkImage(
                                                    imageUrl: state
                                                        .usersModel
                                                        .users![i]
                                                        .profileImageUrl!,
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit: BoxFit.cover,
                                                            colorFilter:
                                                                ColorFilter.mode(
                                                                    Colors.red,
                                                                    BlendMode
                                                                        .colorBurn)),
                                                      ),
                                                    ),
                                                    placeholder: (context,
                                                            url) =>
                                                        Center(
                                                            child:
                                                                CircularProgressIndicator()),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                  flex: 7,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        state.usersModel
                                                            .users![i].name!,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(state.usersModel
                                                          .users![i].phone!)
                                                    ],
                                                  ))
                                            ],
                                          ),
                                        );
                                });
                          })
                      : SizedBox.shrink();
        },
      ))),
    );
  }
}
