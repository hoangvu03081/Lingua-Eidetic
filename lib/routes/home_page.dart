import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/models/collection_bean.dart';
import 'package:lingua_eidetic/widgets/collection_ui.dart';
import 'package:lingua_eidetic/widgets/custom_icon_button.dart';
import 'package:lingua_eidetic/widgets/drag_sort_view.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: false,
              snap: false,
              floating: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: size.height * 0.09,
              leadingWidth: 0,
              leading: SizedBox(),
              flexibleSpace: Container(
                width: double.infinity,
                height: size.height * 0.08,
                margin: EdgeInsets.only(
                  top: defaultPadding * 2,
                  left: defaultPadding * 2,
                  right: defaultPadding * 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomIconButton(
                      onTap: () {},
                      icon: Icon(
                        Icons.settings,
                        color: primaryColor,
                      ),
                    ),
                    CustomIconButton(
                      onTap: () {},
                      icon: Icon(
                        Icons.search,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return CollectionUI();
                },
                childCount: 1,
              ),
            ),
          ],
        ),
        // Column(
        //   children: [
        //     Container(
        //       width: double.infinity,
        //       height: size.height * 0.08,
        //       margin: EdgeInsets.symmetric(
        //         vertical: defaultPadding,
        //         horizontal: defaultPadding * 2,
        //       ),
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           CustomIconButton(
        //             onTap: () {},
        //             icon: Icon(
        //               Icons.settings,
        //               color: primaryColor,
        //             ),
        //           ),
        //           CustomIconButton(
        //             onTap: () {},
        //             icon: Icon(
        //               Icons.search,
        //               color: primaryColor,
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //     Expanded(child: CollectionUI()),
        //   ],
        // ),
      ),
    );
  }
}
