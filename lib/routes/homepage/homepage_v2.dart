import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/routes/authentication/widgets/error_toast.dart';
import 'package:lingua_eidetic/routes/homepage/widgets/add_btn.dart';
import 'package:lingua_eidetic/routes/homepage/widgets/collection_list.dart';
import 'package:lingua_eidetic/routes/homepage/widgets/header.dart';
import 'package:lingua_eidetic/services/auth_service.dart';
import 'package:lingua_eidetic/services/collection_service.dart';
import 'package:lingua_eidetic/widgets/search_box.dart';

class HomePageV2 extends StatefulWidget {
  const HomePageV2({Key? key}) : super(key: key);

  @override
  _HomePageV2State createState() => _HomePageV2State();
}

class _HomePageV2State extends State<HomePageV2> {
  bool isAdding = false;

  FocusNode titleFocusNode = FocusNode();
  TextEditingController titleController = TextEditingController();
  late final FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  void dispose() {
    titleController.dispose();
    titleFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final collectionService = CollectionService();
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        setState(() {
          isAdding = false;
        });
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xFFEDF2F5),
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  floating: true,
                  titleSpacing: 0,
                  title: Header(height: 70),
                  backgroundColor: Colors.transparent,
                  toolbarHeight: 70,
                  leading: SizedBox(),
                  leadingWidth: 0,
                )
              ];
            },
            body: Stack(children: [
              _buildColumn(collectionService, size),
              Positioned(
                top: isAdding ? 0 : size.height,
                child: GestureDetector(
                  onTapDown: (TapDownDetails details) {
                    if (details.globalPosition.dy < size.height / 2) {
                      titleFocusNode.unfocus();
                      setState(() {
                        isAdding = false;
                      });
                    }
                  },
                  child: Container(
                    width: size.width,
                    height: size.height,
                    decoration: BoxDecoration(
                      color: Colors.black38,
                    ),
                    child: Stack(
                      children: [
                        _buildAddForm(size, context, collectionService),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                child: Offstage(
                  offstage: isAdding,
                  child: AddBtn(onTap: () {
                    titleFocusNode.requestFocus();
                    setState(() {
                      isAdding = true;
                    });
                  }),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }

  AnimatedPositioned _buildAddForm(
      Size size, BuildContext context, CollectionService collectionService) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 400),
      left: 0,
      right: 0,
      top: isAdding
          ? size.height * 0.5 - MediaQuery.of(context).viewInsets.bottom
          : size.height,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(22), topRight: Radius.circular(22)),
        child: Container(
          height: size.height * 0.5,
          padding: EdgeInsets.symmetric(
              horizontal: defaultPadding * 2, vertical: defaultPadding * 2),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Adding your own collection',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
              ),
              Align(
                alignment: Alignment.topRight,
                child: ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isEmpty) {
                      _titleEmptyToast();
                      return;
                    }
                    _addingSuccessfully(collectionService);
                  },
                  child: Text('Add'),
                ),
              ),
              SizedBox(height: defaultPadding * 2),
              TextField(
                focusNode: titleFocusNode,
                controller: titleController,
                onEditingComplete: () {
                  if (titleController.text.isEmpty) {
                    _titleEmptyToast();
                    return;
                  }
                  _addingSuccessfully(collectionService);
                },
                style: TextStyle(
                  fontSize: 18,
                ),
                decoration: InputDecoration(
                  labelText: 'Your title',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black54, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black38, width: 1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addingSuccessfully(CollectionService collectionService) {
    collectionService.addCollection(name: titleController.text);
    titleFocusNode.unfocus();
    setState(() {
      isAdding = false;
    });
    showToast(
      fToast,
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.greenAccent,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check),
            SizedBox(
              width: 12.0,
            ),
            Text("Successfully added the collection"),
          ],
        ),
      ),
      3,
      bottom: defaultPadding * 4,
      left: 0,
      right: 0,
    );
    titleController.clear();
  }

  void _titleEmptyToast() {
    showToast(fToast, ErrorToast(errorText: 'Title must not be empty'), 1);
  }

  var _query = '';

  Widget _buildColumn(CollectionService collectionService, size) {
    final child = SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(defaultPadding),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: size.height),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchBox(filterFunc: (query) {
                setState(() {
                  _query = query;
                });
              }),
              SizedBox(height: defaultPadding * 4),
              Text(
                'Collections',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: defaultPadding * 3),
              Expanded(
                child: CollectionList(
                  data: collectionService.data,
                  query: _query,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return child;
  }
}
