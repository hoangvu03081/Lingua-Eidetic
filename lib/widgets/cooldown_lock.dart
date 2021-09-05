import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
class CoolDownLock extends StatefulWidget {
  final String timeCooldown;
  const CoolDownLock({Key? key, required this.timeCooldown}) : super(key: key);

  @override
  _CoolDownLockState createState() => _CoolDownLockState();
}

class _CoolDownLockState extends State<CoolDownLock> {

  Widget _inCoolDown(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: const Color(0xFFBBE7FF),
        border: Border.all(color: Color(0xFFBBE7FF), width: 5),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        )
      ),
      child: Row(
        children:[
          Image(image: AssetImage('assets/images/clock-regular.png'),
            width: 10,
            height: 10,),
          const SizedBox(width: 4,),
          Text(widget.timeCooldown, style: TextStyle(fontSize: 12),),
      ]
    )
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.timeCooldown.length == 0){
      return const SizedBox.shrink();
    }
    return _inCoolDown(context);
  }
}
