import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../data/models/chat_model.dart';

class AiChatController extends GetxController {
  TextEditingController controller1 = new TextEditingController();
  bool istyping = false;

  List<ChatModel> chat = [];
  ScrollController scrollController = ScrollController();
  double maxscroll = 0.0;
  AiChatController();
  sendmessage(ChatModel message) async {
    chat.add(message);
    istyping = true;
    controller1.clear();

    update();
    //checkbottom();
    //print(scrollController.position.maxScrollExtent);
    String txt = await gemini(message.message);

    // String txt = await gettextcompletion(message.message);
    chat.add(ChatModel(message: txt, sender: "chatgpt"));
    istyping = false;
    update();
    checkbottom();
    print(scrollController.position.maxScrollExtent);
  }

  Future gemini(String text) async {
    try {
      String api = dotenv.env['GEMINI_API']!;
      final model = GenerativeModel(
        model: 'gemini-1.5-flash-latest',
        apiKey: api,
      );

      final prompt = text;
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      return response.text;
    } catch (e) {
      return "Some Error Occured";
    }
  }

  Future gettextcompletion(String text) async {
    var headres = {
      "Content-Type": "application/json",
      "Authorization":
          "Bearer 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"
    };
    String url = "https://api.openai.com/v1/chat/completions";
    // var body = {
    //   "model": "text-davinci-003",
    //   "prompt": text,
    //   "max_tokens": 2048,
    //   "temperature": 0.4
    // };
    var body = {
      "model": "gpt-3.5-turbo",
      "messages": [
        {"role": "system", "content": text}
      ]
    };
    try {
      http.Response response = await http.post(Uri.parse(url),
          headers: headres, body: jsonEncode(body));
      print(response.body);
      if (response.statusCode == 200) {
        print(response.body);
        Map data = jsonDecode(response.body);
        print(data);
        return data["choices"][0]["message"]["content"];
      } else {
        Map data = jsonDecode(response.body);
        return data["error"]["message"];
      }
    } catch (e) {
      return e;
    }
  }

  checkbottom() {
    double newscroll = scrollController.position.maxScrollExtent;
    if (newscroll >= maxscroll) {
      final position = scrollController.position.maxScrollExtent;
      scrollController.jumpTo(position);

      update();
    }
  }
}
