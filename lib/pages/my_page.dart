import 'package:devil/services/login.dart';
import 'package:devil/style/color.dart';
import 'package:devil/style/text.dart';
import 'package:devil/viewmodels/info_model.dart';
import 'package:devil/widgets/top_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  static const _btnHeight = 56.0;
  static const _sepHeight = 20.0;

  @override
  Widget build(BuildContext context) {
    return context.watch<InfoModel>().isLogined
        ? _buildAfterLogin(context)
        : _buildBeforeLogin();
  }

  Widget _buildAfterLogin(BuildContext context) {
    return Scaffold(
      appBar: const TopAppBar(title: "My Page"),
      body: Center(
        child: TextButton(
          onPressed: () {
            context.read<InfoModel>().logout();
          },
          child: Text("로그아웃"),
        ),
      ),
    );
  }

  Widget _buildBeforeLogin() {
    return Scaffold(
      body: Column(
        children: [
          const Spacer(flex: 2),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: DevilColor.lightgrey),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Image.asset(
              "assets/images/logo.png",
              width: 96,
              height: 96,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'DeVil',
            style: DevilText.title,
          ),
          const SizedBox(height: 4),
          Text(
            "페이지를 이용하기 위해 로그인이 필요합니다.",
            style: DevilText.light.copyWith(color: DevilColor.grey),
          ),
          const Spacer(flex: 1),
          () {
            const values = LoginPlatform.values;
            return SizedBox(
              height: values.length * (_btnHeight + _sepHeight) - _sepHeight,
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 40),
                itemCount: values.length,
                itemBuilder: (context, idx) =>
                    _buildLoginBtn(values.elementAt(idx), context),
                separatorBuilder: (_, __) => const SizedBox(height: _sepHeight),
              ),
            );
          }(),
          const Spacer(flex: 3),
        ],
      ),
    );
  }

  Widget _buildLoginBtn(LoginPlatform platform, BuildContext context) {
    final isKakao = platform == LoginPlatform.kakao;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Material(
        color: isKakao ? DevilColor.kakao : DevilColor.white,
        child: InkWell(
          onTap: () {
            context.read<InfoModel>().login(platform).then((value) {
              if (!value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: DevilColor.black,
                    content: Text(
                      "로그인에 실패했습니다",
                      style: DevilText.medium.copyWith(color: DevilColor.point),
                    ),
                  ),
                );
              }
            });
          },
          child: Container(
            decoration: BoxDecoration(
              border: isKakao ? null : Border.all(color: DevilColor.lightgrey),
              borderRadius: BorderRadius.circular(12),
            ),
            height: _btnHeight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/icons/ic_${platform.name}.svg'),
                const SizedBox(width: 16),
                Text(
                  "${platform.locale}로 로그인하기",
                  style: DevilText.body,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
