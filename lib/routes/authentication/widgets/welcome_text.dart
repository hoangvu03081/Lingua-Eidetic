import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lingua_eidetic/routes/authentication/widgets/opacity_animation.dart';

class WelcomeText extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool trigger;
  final int duration;

  const WelcomeText({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.trigger,
    required this.duration,
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
    print(subtitle);
    return OpacityAnimation(
      duration: widget.duration,
      trigger: widget.trigger,
      changeText: () {
        setState(() {
          title = widget.title;
          subtitle = widget.subtitle;
        });
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: title,
              style: GoogleFonts.openSans(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: Colors.black,
                ),
              ),
            ),
            TextSpan(
              text: subtitle,
              style: GoogleFonts.openSans(
                textStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
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
