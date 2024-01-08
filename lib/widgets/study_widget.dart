import 'package:devil/pages/studydetail_page.dart';
import 'package:flutter/material.dart';

class Study extends StatelessWidget {
  final String name, category, description;
  final int id, max;
  const Study({
    super.key,
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.max,
  });

  final TextStyle textStyle = const TextStyle(
    color: Color(0xFFFFA8B1),
  );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                Studydetail(
              id: id,
              name: name,
              category: category,
              description: description,
              max: max,
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
            Icon(
              Icons.home,
              color: textStyle.color,
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
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textStyle.color,
                      fontSize: 26,
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Text(description, style: textStyle),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: textStyle.color,
            ),
          ],
        ),
      ),
    );
  }
}

// TODO Implement this library.