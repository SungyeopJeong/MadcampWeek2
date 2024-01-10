import 'package:devil/models/study.dart';
import 'package:devil/pages/study_list_page.dart';
import 'package:devil/services/login.dart';
import 'package:devil/style/color.dart';
import 'package:devil/style/text.dart';
import 'package:devil/viewmodels/chat_model.dart';
import 'package:devil/viewmodels/info_model.dart';
import 'package:devil/widgets/inkwell_btn.dart';
import 'package:devil/widgets/page_route_builder.dart';
import 'package:devil/widgets/study_block.dart';
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildProfile(context),
            FutureBuilder(
              future: context.watch<InfoModel>().myStudies,
              builder: (context, snapshot) {
                return _buildStudyList(context, "가입한 스터디", snapshot.data ?? []);
              },
            ),
            _buildStudyList(context, "완료한 스터디", []),
          ],
        ),
      ),
    );
  }

  Widget _buildProfile(BuildContext context) {
    final user = context.read<InfoModel>().user;

    return InkWellBtn(
      btnColor: DevilColor.white,
      radius: 12,
      onTap: () {
        context.read<InfoModel>().logout();
      },
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            SizedBox(
              width: 48,
              height: 48,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.network(
                  user.profileUrl,
                  errorBuilder: (_, __, ___) =>
                      const ColoredBox(color: DevilColor.black),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    text: user.displayName,
                    style: DevilText.titleB,
                    children: [TextSpan(text: " 님", style: DevilText.titleL)],
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "${user.platform.locale}로 로그인 중",
                      style: DevilText.labelM,
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 16,
                      color: DevilColor.black,
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            InkWellBtn(
              radius: 4,
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: DevilColor.grey),
                    borderRadius: BorderRadius.circular(4)),
                padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 9),
                child: Text(
                  "회원탈퇴",
                  style: DevilText.labelM.copyWith(color: DevilColor.grey),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStudyList(
    BuildContext context,
    String title,
    List<Study> studies,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Navigator.push(
                context,
                pageRouteBuilder(
                  page: StudyListPage(title: title, list: studies),
                ),
              );
            },
            child: Row(
              children: [
                Text("$title ${studies.length}", style: DevilText.bodyM),
                const Spacer(),
                Text("더보기", style: DevilText.labelMH),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: DevilColor.black,
                ),
              ],
            ),
          ),
        ),
        if (studies.isEmpty)
          Padding(
              padding: const EdgeInsets.only(top: 16),
              child: StudyBlock(textIfNull: "$title가 없습니다"))
        else
          ...studies
              .sublist(0, 2)
              .map(
                (e) => Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: StudyBlock(study: e),
                ),
              )
              .toList(),
      ],
    );
  }

  Widget _buildBeforeLogin() {
    return Scaffold(
      body: Column(
        children: [
          const Spacer(flex: 2),
          Container(
            decoration: BoxDecoration(
              color: DevilColor.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: DevilColor.lightgrey, blurRadius: 4.0)
              ],
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
            style: DevilText.titleM,
          ),
          const SizedBox(height: 4),
          Text(
            "페이지를 이용하기 위해 로그인이 필요합니다.",
            style: DevilText.labelLH.copyWith(color: DevilColor.grey),
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
    return InkWellBtn(
      btnColor: isKakao ? DevilColor.kakao : DevilColor.white,
      radius: 12,
      onTap: () {
        context.read<InfoModel>().login(platform).then((value) {
          if (!value) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: DevilColor.black,
                content: Text(
                  "로그인에 실패했습니다",
                  style: DevilText.bodyM.copyWith(color: DevilColor.point),
                ),
              ),
            );
          } else {
            final userid = context.read<InfoModel>().user.id;
            context.read<ChatModel>().init(userid);
            context.read<ChatModel>().getMyChat(userid);
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
              style: DevilText.bodyM,
            ),
          ],
        ),
      ),
    );
  }
}
