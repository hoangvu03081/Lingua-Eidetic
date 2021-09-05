import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/routes/routes.dart';
import 'package:lingua_eidetic/services/card_service.dart';

class Header extends StatefulWidget {
  const Header({
    Key? key,
    required this.height,
    required this.title,
  }) : super(key: key);
  final double height;
  final String title;

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
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const SizedBox(
              width: 60 + defaultPadding,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  Icons.keyboard_arrow_left,
                  color: Color(0xFF172853),
                  size: 30,
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              widget.title,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF172853),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          StreamBuilder<int>(
              stream: cardService.getAvailableCardCount(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data == 0) {
                  return SizedBox(
                    width: 60 + defaultPadding,
                    child: _buildUploadBtn(context),
                  );
                } else {
                  return Row(
                    children: [
                      _buildUploadBtn(context),
                      const SizedBox(width: defaultPadding),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(RouteGenerator.REVIEW_PAGE);
                        },
                        child: const Icon(
                          Icons.keyboard_arrow_right,
                          size: 30,
                          color: Color(0xFF172853),
                        ),
                      ),
                    ],
                  );
                }
              })
        ],
      ),
    );
  }

  Widget _buildUploadBtn(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(RouteGenerator.SHARE_COLLECTION_PAGE);
      },
      child: const Icon(
        Icons.backup,
        size: 30,
        color: Color(0xFF172853),
      ),
    );
  }
}
