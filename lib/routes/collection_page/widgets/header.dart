import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/widgets/custom_toast.dart';
import 'package:lingua_eidetic/routes/routes.dart';
import 'package:lingua_eidetic/services/card_service.dart';

class Header extends StatefulWidget {
  const Header({
    Key? key,
    required this.height,
    required this.title,
    required this.onPrevClicked,
  }) : super(key: key);
  final double height;
  final String title;
  final VoidCallback onPrevClicked;

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  late final FToast fToast;
  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    final cardService = CardService();
    final size = MediaQuery.of(context).size;
    return Container(
      height: widget.height,
      padding: const EdgeInsets.only(
        left: defaultPadding,
        right: defaultPadding,
        bottom: defaultPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: widget.onPrevClicked,
            child: Icon(
              Icons.keyboard_arrow_left,
              color: const Color(0xFF172853),
              size: size.height * 0.09,
            ),
          ),
          Text(
            widget.title,
            style: TextStyle(
              color: const Color(0xFF172853),
              fontSize: 32 > size.height * 0.07 ? size.height * 0.07 : 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          StreamBuilder<int>(
              stream: cardService.getAvailableCardCount(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data == 0) {
                  return const SizedBox();
                } else {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(RouteGenerator.REVIEW_PAGE);
                    },
                    child: Icon(
                      Icons.keyboard_arrow_right,
                      size: size.height * 0.09,
                      color: const Color(0xFF172853),
                    ),
                  );
                }
              })
        ],
      ),
    );
  }
}
