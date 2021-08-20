import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/routes/homepage/widgets/collection_card.dart';
import 'package:lingua_eidetic/routes/homepage/widgets/header.dart';
import 'package:lingua_eidetic/widgets/drag_view.dart';

class CollectionBean extends DragBean {
  final IconData iconData;
  final String title;
  final int left;
  final int done;
  final Color color;

  CollectionBean({
    required this.color,
    required this.iconData,
    required this.title,
    required this.left,
    required this.done,
  });
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final collectionData = <CollectionBean>[
    CollectionBean(
      iconData: Icons.work,
      title: "Work",
      left: 2,
      done: 8,
      color: Color(0x80F8B195),
    ),
    CollectionBean(
      iconData: Icons.animation,
      title: "Spring",
      left: 2,
      done: 8,
      color: Color(0xFFF67280),
    ),
  ];

  @override
  void initState() {
    super.initState();
    final data = <String>['Personal', 'Work', 'Health'];
    title.addAll(data);

    _searchController.addListener(() {
      final filteredData = <String>[];
      data.forEach((title) {
        final isContained =
            title.contains(RegExp(_searchText, caseSensitive: false));
        if (isContained) {
          filteredData.add(title);
        }
      });
      setState(() {
        title = filteredData;
      });
    });
    _searchFocusNode.addListener(() {
      if (_searchFocusNode.hasFocus) {
        searchBoxColor = Color(0xFFFFFFFF);
      } else {
        searchBoxColor = Color(0xD3E8E7E7);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  final defaultTextStyle = GoogleFonts.montserrat(
    textStyle: TextStyle(fontWeight: FontWeight.w700),
  );

  var title = <String>[];
  var searchBoxColor = Color(0xD3E8E7E7);
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  String get _searchText => _searchController.text;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Column(
                  children: [
                    Header(
                      urlImage:
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSF6jKor8bzwTj_8iQ2cOC00B80uejzC6LQ1w&usqp=CAU',
                      username: 'Amanda',
                    ),
                    SizedBox(height: defaultPadding * 2),
                    TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      decoration: InputDecoration(
                        fillColor: searchBoxColor,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: defaultPadding * 3,
                          vertical: defaultPadding * 2,
                        ),
                        hintText: 'Search',
                        hintStyle: TextStyle(color: Colors.black54),
                      ),
                    ),
                    SizedBox(height: defaultPadding * 2),
                    Text(
                      'Tasks',
                      style: defaultTextStyle.copyWith(fontSize: 26),
                    ),
                  ],
                ),
              ),
              SizedBox(height: defaultPadding * 2),
              // _buildChild(context),
              DragView(
                data: collectionData,
                itemBuilder: (context, index) {
                  return CollectionCard(
                    readOnly: true,
                    defaultTextStyle: defaultTextStyle,
                    iconData: collectionData[index].iconData,
                    left: collectionData[index].left,
                    done: collectionData[index].done,
                    title: collectionData[index].title,
                    color: collectionData[index].color,
                  );
                },
                itemRowCount: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isAddNew = false;

  Widget _buildChild(BuildContext context) {
    List<Widget> children = [];
    final width = MediaQuery.of(context).size.width;
    final gapX = defaultPadding * 2;
    final gapY = defaultPadding * 2;
    double childHeight = 192;
    var childWidth = (width - defaultPadding * 2 - gapX) / 2;
    for (int i = 0; i < title.length; i++) {
      double dx = i % 2 == 0 ? 0 : childWidth + gapX;
      double dy = (childHeight + gapY) * (i ~/ 2);

      children.add(
        Positioned(
          left: dx,
          top: dy,
          child: CollectionCard(
            readOnly: true,
            color: Color(0xFFFFFFFF),
            defaultTextStyle: defaultTextStyle,
            iconData: Icons.work,
            left: 1,
            done: 8,
            title: title[i],
          ),
        ),
      );
    }
    Widget addBox = DottedBorder(
      color: Color(0xFFDDDDDD),
      strokeWidth: 3,
      borderType: BorderType.RRect,
      radius: Radius.circular(22),
      dashPattern: [12, 12],
      child: GestureDetector(
        onTap: () {
          setState(() {
            isAddNew = true;
          });
        },
        child: Container(
          height: childHeight - 6,
          width: childWidth - 6,
          child: Center(
            child: Text(
              '+ Add',
              style: defaultTextStyle.copyWith(fontSize: 22),
            ),
          ),
        ),
      ),
    );
    if (!isAddNew)
      children.add(
        Positioned(
          left: title.length % 2 == 0 ? 0 : childWidth + gapX,
          top: (childHeight + gapY) * (title.length ~/ 2),
          child: addBox,
        ),
      );
    else {
      children.add(
        Positioned(
          left: title.length % 2 == 0 ? 0 : childWidth + gapX,
          top: (childHeight + gapY) * (title.length ~/ 2),
          child: Stack(
            children: [
              CollectionCard(
                readOnly: false,
                color: Color(0xFFFFFFFF),
                defaultTextStyle: defaultTextStyle,
                iconData: Icons.work,
                left: 1,
                done: 8,
                title: '',
                doneEditing: (val) {
                  setState(() {
                    title.add(val);
                    isAddNew = false;
                  });
                },
              ),
              Positioned(
                right: 0,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      isAddNew = false;
                    });
                  },
                  icon: Icon(
                    Icons.cancel,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Container(
      height: ((title.length + 1) / 2).ceil() * (childHeight + gapY),
      child: Stack(children: children),
    );
  }
}
