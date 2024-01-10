import 'package:devil/pages/chat_detail_page.dart';
import 'package:devil/pages/chat_page.dart';
import 'package:devil/pages/main_page.dart';
import 'package:devil/pages/my_page.dart';
import 'package:devil/style/color.dart';
import 'package:devil/style/theme.dart';
import 'package:devil/viewmodels/chat_model.dart';
import 'package:devil/viewmodels/info_model.dart';
import 'package:devil/viewmodels/study_model.dart';
import 'package:devil/widgets/page_route_builder.dart';
import 'package:devil/widgets/pop_up.dart';
import 'package:devil/widgets/show_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ko'),
        ],
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
                  showModal(
                    context: context,
                    builder: (_) => PopUp(
                      msg: '로그인 후 이용 가능합니다.',
                      onTap: () {
                        setState(() {
                          _currentIdx = 2;
                        });
                      },
                    ),
                  );
                }),
              ),
            ),
            Navigator(
              key: navKeyList[1],
              onGenerateRoute: (_) => MaterialPageRoute(
                builder: (_) => ChatPage(
                  navigateToDetail: (study) {
                    Navigator.push(
                      context,
                      pageRouteBuilder(page: ChatDetailPage(study: study)),
                    );
                  },
                ),
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
            if (idx == 1 && !context.read<InfoModel>().isLogined) {
              showModal(
                context: context,
                builder: (_) => PopUp(
                  msg: '로그인 후 이용 가능합니다.',
                  onTap: () {
                    setState(() {
                      _currentIdx = 2;
                    });
                  },
                ),
              );
            } else {
              setState(() {
                _currentIdx = idx;
              });
            }
          },
          showSelectedLabels: false,
          showUnselectedLabels: false,
          fixedColor: DevilColor.grey,
          backgroundColor: DevilColor.white,
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
