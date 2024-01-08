import 'package:devil/models/study.dart';
import 'package:devil/pages/study_detail_page.dart';
import 'package:devil/style/color.dart';
import 'package:devil/style/text.dart';
import 'package:flutter/material.dart';

class StudyBlock extends StatelessWidget {
  final Study study;

  const StudyBlock({super.key, required this.study});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                StudyDetailPage(
              study: study,
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOutQuart;
              var tween = Tween(begin: begin, end: end).chain(
                CurveTween(curve: curve),
              );

              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1C1D),
          border: Border.all(),
          borderRadius: BorderRadius.circular(9.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.home,
              color: DevilColor.point,
              size: 40,
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    study.name,
                    style:
                        DevilText.headlineB.copyWith(color: DevilColor.point),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    study.description,
                    style: DevilText.bodyM.copyWith(color: DevilColor.point),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: DevilColor.point,
            ),
          ],
        ),
      ),
    );
  }
}

// TODO Implement this library.