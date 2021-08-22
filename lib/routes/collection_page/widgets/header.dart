import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/routes/authentication/widgets/error_toast.dart';
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: widget.onPrevClicked,
            child: Icon(
              Icons.keyboard_arrow_left,
              color: Color(0xFF172853),
              size: 70,
            ),
          ),
          Text(
            widget.title,
            style: TextStyle(
              color: Color(0xFF172853),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          StreamBuilder<int>(
              stream: cardService.getAvailableCardCount(),
              builder: (context, snapshot) {
                return GestureDetector(
                  onTap: () {
                    if (snapshot.hasData && snapshot.data == 0) {
                      showToast(
                        fToast,
                        ErrorToast(errorText: 'No available card'),
                        3,
                        left: 0,
                        right: 0,
                        bottom: defaultPadding * 4,
                      );
                      return;
                    }

                    Navigator.of(context).pushNamed(RouteGenerator.REVIEW_PAGE);
                  },
                  child: const Icon(
                    Icons.keyboard_arrow_right,
                    size: 70,
                    color: Color(0xFF172853),
                  ),
                );
              })
        ],
      ),
      height: widget.height,
    );
  }
}
