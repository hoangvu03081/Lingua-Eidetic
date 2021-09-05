import 'package:flutter/material.dart';
import 'package:lingua_eidetic/constants.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({
    Key? key,
    this.leadingIcon = const Icon(
      Icons.chevron_left,
    ),
    required this.title,
    this.action,
    this.height = 50,
    this.titleStyle = const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
    ),
  }) : super(key: key);
  final Icon leadingIcon;
  final Widget? action;
  final String title;
  final double height;
  final TextStyle titleStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                if (Navigator.canPop(context)) Navigator.of(context).pop();
              },
              child: SizedBox(
                height: height,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: leadingIcon,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              height: height,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  title,
                  style: titleStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: action != null
                ? Align(
                    alignment: Alignment.centerRight,
                    child: action!,
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
