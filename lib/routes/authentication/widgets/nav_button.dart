import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lingua_eidetic/routes/authentication/widgets/opacity_animation.dart';

class NavButton extends StatelessWidget {
  final String navigateTitle;
  final String navigateSubtitle;
  final VoidCallback onPressNavigate;
  final bool transition;

  const NavButton({
    Key? key,
    required this.navigateTitle,
    required this.navigateSubtitle,
    required this.onPressNavigate,
    required this.transition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return TextButton(
      onPressed: transition ? onPressNavigate : null,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: GoogleFonts.openSans(
            textStyle: const TextStyle(
              color: Colors.black54,
            ),
          ),
          children: [
            TextSpan(text: navigateSubtitle),
            TextSpan(
              text: navigateTitle,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
