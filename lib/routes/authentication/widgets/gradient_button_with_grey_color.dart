import 'package:flutter/material.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/routes/authentication/models/anim_trigger.dart';
import 'package:lingua_eidetic/routes/authentication/widgets/opacity_animation.dart';
import 'package:provider/provider.dart';

class GradientButtonWithGreyBorder extends StatefulWidget {
  final String text;
  final Function()? press;
  final bool loading;

  const GradientButtonWithGreyBorder({
    Key? key,
    this.press,
    required this.text,
    required this.loading,
  }) : super(key: key);

  @override
  _GradientButtonWithGreyBorderState createState() =>
      _GradientButtonWithGreyBorderState();
}

class _GradientButtonWithGreyBorderState
    extends State<GradientButtonWithGreyBorder> {
  String text = '';

  @override
  void initState() {
    super.initState();
    text = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: widget.press,
      overlayColor: MaterialStateProperty.all(Color(0xFF891212)),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          left: defaultPadding * 2,
          right: defaultPadding * 2,
          bottom: defaultPadding * 1.5,
          top: defaultPadding * 1.2,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xFFE4E4E4),
            width: 3,
          ),
          borderRadius: BorderRadius.circular(15),
          gradient: widget.press != null
              ? LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  stops: [0, 0.6],
                  colors: [
                    Color(0xDAFF2358),
                    Color(0xDAFF5B27),
                  ],
                )
              : LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  stops: [0, 0.6],
                  colors: [
                    Color(0xFF971433),
                    Color(0xFFA03919),
                  ],
                ),
        ),
        child: Consumer<AnimTriggerModel>(
          builder: (context, anim, child) => OpacityAnimation(
            duration: anim.duration,
            trigger: anim.trigger,
            changeText: () {
              setState(() {
                text = widget.text;
              });
            },
            child: child!,
          ),
          child: widget.loading
              ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
      ),
    );
  }
}
