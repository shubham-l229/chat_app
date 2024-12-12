import 'package:chat_app/controllers/ai_chat_controller.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_app/utils/colors.dart' as cs;

import '../../data/models/chat_model.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_sharp,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "AI Chat Screen",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: GetBuilder<AiChatController>(
          init: AiChatController(),
          builder: (controller) {
            return SafeArea(
                child: Column(
              children: [
                Expanded(
                    child: ListView.builder(
                        controller: controller.scrollController,
                        itemCount: controller.chat.length,
                        itemBuilder: (context, i) {
                          return BubbleSpecialThree(
                            text: controller.chat[i].message,
                            isSender: controller.chat[i].sender == "user",
                            color: controller.chat[i].sender == "user"
                                ? cs.Colors().sendBackgroundColor
                                : cs.Colors().receiveBackgroundColor,
                            tail: true,
                            textStyle: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ).marginSymmetric(horizontal: 5);
                        })),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 70,
                    child: MessageBar(
                      onSend: (_) {
                        if (_.isNotEmpty) {
                          // SendMessage(
                          //         receiverId: user!.id!,
                          //         message: _,
                          //         receiveMessageBloc: _receiveMessageBloc)
                          controller.sendmessage(
                              ChatModel(message: _, sender: "user"));
                        }
                      },
                    ),
                  ),
                )
              ],
            ));
          }),
    );
  }
}
