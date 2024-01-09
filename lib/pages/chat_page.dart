import 'dart:convert';
import 'package:devil/models/study.dart';
import 'package:devil/viewmodels/info_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:devil/widgets/top_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late String id = "";
  List<String> studyNameList = [];
  List<Study> userStudies = [];

  Future<List<Study>> getUserStudy() async {
    const String apiUrl = 'http://10.0.2.2:3000/api/user/studies';
    final islogined = context.read<InfoModel>().isLogined;
    if (islogined) {
      final user = context.read<InfoModel>().user;
      id = user.id;
    }

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode({'id': id}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final studylist = json.decode(response.body);
        return List<Study>.from(
            studylist.map((studyJson) => Study.fromJson(studyJson)));
      } else {
        throw Exception('Failed to load user studies');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to load user studies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopAppBar(title: "Chat"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
              future: getUserStudy(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Expanded(
                    child: StudyListView(userStudies: snapshot.data),
                  );
                }
              },
            ),
            Expanded(
              child: StudyListView(userStudies: userStudies),
            ),
            ElevatedButton(
              onPressed: getUserStudy,
              child: const Text('새로고침'),
            ),
          ],
        ),
      ),
    );
  }
}

class StudyListView extends StatelessWidget {
  final List<Study>? userStudies;

  const StudyListView({super.key, required this.userStudies});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: userStudies!.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(userStudies![index].name),
          subtitle: Text(userStudies![index].description),
          // Add more information as needed
        );
      },
    );
  }
}
