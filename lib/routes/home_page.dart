import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/models/collection_bean.dart';
import 'package:lingua_eidetic/widgets/drag_sort_view.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CollectionBean> collectionList = [
    CollectionBean(title: '1', number: 1),
    CollectionBean(title: '1', number: 1),
    CollectionBean(title: '1', number: 1),
    CollectionBean(title: '1', number: 1),
    CollectionBean(title: '1', number: 1),
    CollectionBean(title: '1', number: 1),
    CollectionBean(title: '1', number: 1),
    CollectionBean(title: '1', number: 1),
    CollectionBean(title: '1', number: 1),
    CollectionBean(title: '1', number: 1),
  ];
  int moveAction = MotionEvent.actionUp;
  bool _canDelete = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: size.height * 0.08,
              margin: EdgeInsets.symmetric(
                vertical: defaultPadding,
                horizontal: defaultPadding * 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(20),
                    child: Ink(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black54,
                            spreadRadius: -2,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.settings,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(20),
                    child: Ink(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black54,
                            spreadRadius: -2,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.search,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Expanded(
            //   child: StaggeredGridView.countBuilder(
            //     crossAxisCount: 4,
            //     itemCount: 8,
            //     itemBuilder: (BuildContext context, int index) => index == 0
            //         ? Container(
            //             alignment: Alignment.center,
            //             child: Text(
            //               'Collections',
            //               style: GoogleFonts.sourceSansPro(
            //                 textStyle: TextStyle(
            //                   color: primaryColor,
            //                   fontSize: 32,
            //                   fontWeight: FontWeight.w300,
            //                 ),
            //               ),
            //             ),
            //             decoration: BoxDecoration(
            //               border: Border(
            //                 bottom: BorderSide(color: primaryColor, width: 1),
            //               ),
            //             ),
            //           )
            //         : Container(
            //             padding: EdgeInsets.symmetric(
            //               vertical: defaultPadding,
            //               horizontal: defaultPadding * 2,
            //             ),
            //             child: Stack(
            //               children: [
            //                 Positioned(
            //                   child: Align(
            //                     alignment: Alignment.center,
            //                     child: Text(
            //                       '$index',
            //                       textAlign: TextAlign.center,
            //                       style: GoogleFonts.openSans(
            //                         textStyle: TextStyle(
            //                           color: Colors.white,
            //                           fontSize: 24,
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //                 Positioned(
            //                   bottom: defaultPadding,
            //                   right: defaultPadding,
            //                   child: Text(
            //                     '$index',
            //                     style: GoogleFonts.openSans(
            //                       textStyle: TextStyle(
            //                         color: Colors.white,
            //                         fontSize: 16,
            //                         fontWeight: FontWeight.w700,
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //             decoration: BoxDecoration(
            //               borderRadius: BorderRadius.circular(22),
            //               boxShadow: [
            //                 BoxShadow(
            //                   color: Colors.black.withOpacity(0.2),
            //                   blurRadius: 4,
            //                   offset: Offset(0, 4),
            //                 )
            //               ],
            //               gradient: LinearGradient(
            //                 begin: Alignment.bottomLeft,
            //                 end: Alignment.topRight,
            //                 colors: [
            //                   primaryColor,
            //                   secondaryColor,
            //                 ],
            //               ),
            //             ),
            //           ),
            //     staggeredTileBuilder: (int index) => StaggeredTile.count(
            //         index == 0 ? 4 : 2, index == 0 ? 1 : 2.5),
            //     mainAxisSpacing: defaultPadding * 2,
            //     crossAxisSpacing: defaultPadding * 4,
            //   ),
            // ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  // DragSortView(
                  //   collectionList,
                  //   space: 5,
                  //   margin: EdgeInsets.all(20),
                  //   padding: EdgeInsets.all(0),
                  //   itemBuilder: (BuildContext context, int index) {
                  //     CollectionBean bean = collectionList[index];
                  //     // It is recommended to use a thumbnail picture
                  //     return Container(color: Colors.red);
                  //   },
                  //   onDragListener: (MotionEvent event, double itemWidth) {
                  //     switch (event.action) {
                  //       case MotionEvent.actionDown:
                  //         moveAction = event.action!;
                  //         setState(() {});
                  //         break;
                  //       case MotionEvent.actionMove:
                  //         double x = event.globalX! + itemWidth;
                  //         double y = event.globalY! + itemWidth;
                  //         double maxX =
                  //             MediaQuery.of(context).size.width - 1 * 100;
                  //         double maxY =
                  //             MediaQuery.of(context).size.height - 1 * 100;
                  //         print(
                  //             'Sky24n maxX: $maxX, maxY: $maxY, x: $x, y: $y');
                  //         if (_canDelete && (x < maxX || y < maxY)) {
                  //           setState(() {
                  //             _canDelete = false;
                  //           });
                  //         } else if (!_canDelete && x > maxX && y > maxY) {
                  //           setState(() {
                  //             _canDelete = true;
                  //           });
                  //         }
                  //         break;
                  //       case MotionEvent.actionUp:
                  //         moveAction = event.action!;
                  //         if (_canDelete) {
                  //           setState(() {
                  //             _canDelete = false;
                  //           });
                  //           return true;
                  //         } else {
                  //           setState(() {});
                  //         }
                  //         break;
                  //     }
                  //     return false;
                  //   },
                  // ),
                  SingleChildScrollView(
                    child: DragSortView(
                      collectionList,
                      space: defaultPadding,
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.all(0),
                      itemBuilder: (BuildContext context, int index) {
                        CollectionBean bean = collectionList[index];
                        // It is recommended to use a thumbnail picture
                        return Container(
                          color: Colors.red,
                          child: Text(bean.title!),
                        );
                      },
                      initBuilder: (BuildContext context) {
                        return InkWell(
                          onTap: () {
                            // _loadAssets(context);
                          },
                          child: Container(
                            color: Color(0XFFCCCCCC),
                            child: Center(
                              child: Icon(
                                Icons.add,
                              ),
                            ),
                          ),
                        );
                      },
                      onDragListener: (MotionEvent event, double itemWidth) {
                        switch (event.action) {
                          case MotionEvent.actionDown:
                            moveAction = event.action!;
                            setState(() {});
                            break;
                          case MotionEvent.actionMove:
                            double x = event.globalX! + itemWidth;
                            double y = event.globalY! + itemWidth;
                            double maxX =
                                MediaQuery.of(context).size.width - 1 * 100;
                            double maxY =
                                MediaQuery.of(context).size.height - 1 * 100;
                            if (_canDelete && (x < maxX || y < maxY)) {
                              setState(() {
                                _canDelete = false;
                              });
                            } else if (!_canDelete && x > maxX && y > maxY) {
                              setState(() {
                                _canDelete = true;
                              });
                            }
                            break;
                          case MotionEvent.actionUp:
                            moveAction = event.action!;
                            if (_canDelete) {
                              setState(() {
                                _canDelete = false;
                              });
                              return true;
                            } else {
                              setState(() {});
                            }
                            break;
                        }
                        return false;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: moveAction == MotionEvent.actionUp
          ? null
          : FloatingActionButton(
              onPressed: () {},
              child: Icon(_canDelete ? Icons.delete : Icons.delete_outline),
            ),
    );
  }
}
