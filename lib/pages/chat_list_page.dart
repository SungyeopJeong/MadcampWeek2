import 'dart:convert';

import 'package:devil/models/study.dart';
import 'package:devil/viewmodels/info_model.dart';
import 'package:devil/widgets/study_chat_block.dart';
import 'package:devil/widgets/top_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  List studyList = [];

  @override
  void initState() {
    super.initState();
    print("Chat InitState called");
  }

  // Future<void> getUserData(userId) async {
  //   try {
  //     Map<String, dynamic> data = {'id': userId};

  //     final response = await http.post(
  //       Uri.parse("http://172.10.7.49/api/user/studies"),
  //       body: data,
  //     );
  //     if (response.statusCode == 200) {
  //       setState(() {
  //         studyList =
  //             jsonDecode(response.body).map((e) => Study.fromJson(e)).toList();
  //       });
  //     } else {
  //       print('POST request failed with status: ${response.statusCode}');
  //       print('Response body: ${response.body}');
  //     }
  //   } catch (e) {
  //     print('Error during POST request: $e');
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    if (context.watch<InfoModel>().isLogined) {
      return FutureBuilder<List<Study>>(
        future: context.watch<InfoModel>().myStudies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while the future is still running
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // Show an error message if the future encounters an error
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            final mystudy = snapshot.data;

            return Scaffold(
              appBar: const TopAppBar(title: "Chat"),
              body: mystudy!.isEmpty
                  ? const Center(child: Text("No studies available"))
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Expanded(
                        child: ListView.builder(
                          itemCount: mystudy.length,
                          itemBuilder: (_, idx) {
                            Study study = mystudy[idx];
                            return StudyChatBlock(
                              study: study,
                            );
                          },
                        ),
                      ),
                    ),
            );
          }
        },
      );
    }
    return const Text("not yet");
  }
}
