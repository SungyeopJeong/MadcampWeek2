// ignore_for_file: empty_catches, avoid_print

import 'package:devil/pages/chat_page.dart';
import 'package:devil/pages/main_page.dart';
import 'package:devil/pages/my_page.dart';
import 'package:devil/style/color.dart';
import 'package:devil/style/theme.dart';
import 'package:devil/viewmodels/info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // 추가
  //print(await KakaoSdk.origin);

  KakaoSdk.init(
    nativeAppKey: dotenv.env['nativeKey'],
    javaScriptAppKey: dotenv.env['jsKey'],
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InfoModel()),
      ],
      child: MaterialApp(
        title: 'DeVil',
        theme: DevilTheme.theme,
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIdx,
        children: const [
          MainPage(),
          ChatPage(),
          MyPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (idx) {
          setState(() {
            _currentIdx = idx;
          });
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        fixedColor: DevilColor.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(_currentIdx == 0 ? Icons.home : Icons.home_outlined),
            label: 'main',
          ),
          BottomNavigationBarItem(
            icon: Icon(_currentIdx == 1 ? Icons.chat : Icons.chat_outlined),
            label: 'chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(_currentIdx == 2 ? Icons.person : Icons.person_outlined),
            label: 'my',
          ),
        ],
      ),
    );
  }
}
