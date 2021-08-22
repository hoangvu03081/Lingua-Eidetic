import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/routes/authentication/widgets/error_toast.dart';
import 'package:lingua_eidetic/routes/collection_page/collection_page.dart';
import 'package:lingua_eidetic/routes/homepage/widgets/add_btn.dart';
import 'package:lingua_eidetic/routes/homepage/widgets/collection_list.dart';
import 'package:lingua_eidetic/routes/homepage/widgets/header.dart';
import 'package:lingua_eidetic/services/auth_service.dart';
import 'package:lingua_eidetic/services/collection_service.dart';
import 'package:lingua_eidetic/widgets/collection_navbar.dart';
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

  var _query = '';

  void onQuery(String query) {
    setState(() {
      _query = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    final collectionService = CollectionService();
    final size = MediaQuery.of(context).size;
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    if (!isAdding) titleFocusNode.unfocus();

    return WillPopScope(
      onWillPop: () async {
        setState(() {
          isAdding = false;
        });
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFEDF2F5),
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  titleSpacing: 0,
                  title: Header(height: 200, onQuery: onQuery),
                  toolbarHeight: 200,
                  backgroundColor: Colors.transparent,
                  leading: const SizedBox(),
                  leadingWidth: 0,
                )
              ];
            },
            body: Stack(children: [
              // TODO: provider for query
              CollectionList(
                data: collectionService.data,
                query: _query,
              ),
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
                    decoration: const BoxDecoration(
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
                bottom: defaultPadding,
                left: 0,
                right: 0,
                child: Offstage(
                  offstage: isAdding || isKeyboardOpen,
                  child: AddBtn(onTap: () {
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
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(22), topRight: Radius.circular(22)),
        child: Container(
          height: size.height * 0.5,
          padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding * 2, vertical: defaultPadding * 2),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
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
                  child: const Text('Add'),
                ),
              ),
              const SizedBox(height: defaultPadding * 2),
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
                style: const TextStyle(
                  fontSize: 18,
                ),
                decoration: const InputDecoration(
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
            const Icon(Icons.check),
            const SizedBox(width: 12.0),
            const Text("Successfully added the collection"),
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
}
