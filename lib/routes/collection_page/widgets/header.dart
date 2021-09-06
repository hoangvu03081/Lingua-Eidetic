import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/routes/routes.dart';
import 'package:lingua_eidetic/services/card_service.dart';
import 'package:lingua_eidetic/widgets/custom_header.dart';

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
  @override
  Widget build(BuildContext context) {
    final cardService = CardService();
    return Container(
        height: widget.height,
        padding: const EdgeInsets.only(
          left: defaultPadding,
          right: defaultPadding,
          bottom: defaultPadding,
        ),
        child: CustomHeader(
          leadingIcon: Icon(
            Icons.chevron_left,
            color: Theme.of(context).accentColor,
            size: 32,
          ),
          height: 75,
          title: widget.title, // widget.title
          action: StreamBuilder<int>(
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
                      _buildTestBtn(context),
                    ],
                  );
                }
              }),
        ));
  }

  Widget _buildUploadBtn(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          RouteGenerator.SHARE_COLLECTION_PAGE,
          arguments: widget.title,
        );
      },
      child: SizedBox(
        height: 30,
        width: 30,
        child: SvgPicture.asset(
          'assets/images/share.svg',
          fit: BoxFit.contain,
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }

  Widget _buildTestBtn(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(RouteGenerator.REVIEW_PAGE);
      },
      child: Icon(
        Icons.keyboard_arrow_right,
        size: 30,
        color: Theme.of(context).accentColor,
      ),
    );
  }
}
