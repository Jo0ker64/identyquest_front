import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BackButtonWidget extends StatelessWidget {
  final Color color;
  final String? goToRoute;

  const BackButtonWidget({
    super.key,
    this.color = Colors.black,
    this.goToRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: InkWell(
          onTap: () {
            if (goToRoute != null) {
              context.go(goToRoute!); // 🚀 go_router style
            } else {
              Navigator.of(context).pop(); // 🔙 retour classique
            }
          },
          child: Icon(Icons.arrow_back, color: color, size: 28),
        ),
      ),
    );
  }
}
