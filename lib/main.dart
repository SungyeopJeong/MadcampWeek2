import 'package:devil/pages/chat_list_page.dart';
import 'package:devil/pages/chat_page.dart';
import 'package:devil/pages/main_page.dart';
import 'package:devil/pages/my_page.dart';
import 'package:devil/style/color.dart';
import 'package:devil/style/theme.dart';
import 'package:devil/viewmodels/chat_model.dart';
import 'package:devil/viewmodels/info_model.dart';
import 'package:devil/viewmodels/study_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

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
        ChangeNotifierProvider(create: (_) => StudyModel()),
        ChangeNotifierProvider(create: (_) => ChatModel()),
      ],
      child: MaterialApp(
        title: 'DeVil',
        theme: DevilTheme.theme,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.noScaling),
            child: child!,
          );
        },
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

  final navKeyList = List.generate(3, (index) => GlobalKey<NavigatorState>());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        final pageContext = navKeyList[_currentIdx].currentState!.context;
        final canPop = Navigator.canPop(pageContext);
        if (canPop) {
          Navigator.pop(pageContext);
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIdx,
          children: [
            Navigator(
              key: navKeyList[0],
              onGenerateRoute: (_) => MaterialPageRoute(
                builder: (_) => MainPage(navigateToLogin: () {
                  setState(() {
                    _currentIdx = 2;
                  });
                }),
              ),
            ),
            Navigator(
              key: navKeyList[1],
              onGenerateRoute: (_) => MaterialPageRoute(
                builder: (_) => const ChatList(),
              ),
            ),
            Navigator(
              key: navKeyList[2],
              onGenerateRoute: (_) => MaterialPageRoute(
                builder: (_) => const MyPage(),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (idx) {
            setState(() {
              if (idx == 1 && !context.read<InfoModel>().isLogined) {
                _currentIdx = 2;
              } else {
                _currentIdx = idx;
              }
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
              icon:
                  Icon(_currentIdx == 2 ? Icons.person : Icons.person_outlined),
              label: 'my',
            ),
          ],
        ),
      ),
    );
  }
}
