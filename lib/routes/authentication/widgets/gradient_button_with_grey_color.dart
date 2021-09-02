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
    final size = MediaQuery.of(context).size;
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: widget.press,
      overlayColor: MaterialStateProperty.all(const Color(0xFF891212)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(
          left: defaultPadding * 2,
          right: defaultPadding * 2,
          bottom: defaultPadding * 1.2,
          top: defaultPadding,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFE4E4E4),
            width: 3,
          ),
          borderRadius: BorderRadius.circular(15),
          gradient: widget.press != null
              ? const LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  stops: [0, 0.6],
                  colors: [
                    Color(0xDAFF2358),
                    Color(0xDAFF5B27),
                  ],
                )
              : const LinearGradient(
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
              ? const Center(
                  child: SizedBox(
                    width: 26,
                    height: 26,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                )
              : Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
      ),
    );
  }
}
