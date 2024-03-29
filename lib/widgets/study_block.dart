import 'package:devil/models/study.dart';
import 'package:devil/pages/study_detail_page.dart';
import 'package:devil/style/color.dart';
import 'package:devil/style/text.dart';
import 'package:devil/widgets/inkwell_btn.dart';
import 'package:devil/widgets/page_route_builder.dart';
import 'package:flutter/material.dart';

class StudyBlock extends StatelessWidget {
  final Study? study;
  final String? textIfNull;

  const StudyBlock({super.key, this.study, this.textIfNull});

  @override
  Widget build(BuildContext context) {
    if (study == null) {
      return Container(
        decoration: BoxDecoration(
          color: DevilColor.white,
          borderRadius: BorderRadius.circular(12),
        ),
        width: double.infinity,
        height: 80,
        alignment: Alignment.center,
        child: Text(
          textIfNull!,
          style: DevilText.bodyM.copyWith(color: DevilColor.lightgrey),
        ),
      );
    } else {
      return InkWellBtn(
        btnColor: DevilColor.white,
        radius: 12,
        onTap: () {
          Navigator.push(
            context,
            pageRouteBuilder(page: StudyDetailPage(study: study!)),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: DevilColor.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 20,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    alignment: Alignment.center,
                    child: Text(
                      study!.category,
                      style: DevilText.labelB.copyWith(color: DevilColor.point),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.home, size: 20, color: DevilColor.point),
                  SizedBox(
                    width: 48,
                    child: Text.rich(
                      TextSpan(
                        text: "${study!.now}",
                        style: DevilText.labelM.copyWith(
                          color: study!.now >= study!.max
                              ? DevilColor.lightgrey
                              : null,
                        ),
                        children: [
                          TextSpan(
                            text: " / ${study!.max}",
                            style: DevilText.labelM,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(study!.name, style: DevilText.bodyM),
              ),
              Text(
                study!.description,
                style: DevilText.labelM.copyWith(color: DevilColor.grey),
              ),
            ],
          ),
        ),
      );
    }
  }
}
