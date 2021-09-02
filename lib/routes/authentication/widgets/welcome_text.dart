import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lingua_eidetic/routes/authentication/models/anim_trigger.dart';
import 'package:lingua_eidetic/routes/authentication/widgets/opacity_animation.dart';
import 'package:provider/provider.dart';

class WelcomeText extends StatefulWidget {
  final String title;
  final String subtitle;

  const WelcomeText({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  _WelcomeTextState createState() => _WelcomeTextState();
}

class _WelcomeTextState extends State<WelcomeText> {
  String title = '';
  String subtitle = '';

  @override
  void initState() {
    super.initState();
    title = widget.title;
    subtitle = widget.subtitle;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Consumer<AnimTriggerModel>(
      builder: (context, anim, child) {
        return OpacityAnimation(
          duration: anim.duration,
          trigger: anim.trigger,
          changeText: () {
            setState(() {
              title = widget.title;
              subtitle = widget.subtitle;
            });
          },
          child: child!,
        );
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: title,
              style: GoogleFonts.openSans(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 34,
                  color: Colors.black,
                ),
              ),
            ),
            TextSpan(
              text: subtitle,
              style: GoogleFonts.openSans(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Color(0xFFC6C6C6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
