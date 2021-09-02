import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/routes/homepage/widgets/add_btn.dart';
import 'package:lingua_eidetic/widgets/custom_toast.dart';
import 'package:lingua_eidetic/routes/homepage/widgets/collection_list.dart';
import 'package:lingua_eidetic/routes/homepage/widgets/header.dart';
import 'package:lingua_eidetic/services/collection_service.dart';

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
  double topOffset = 0;

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
    final headerHeight = size.height * 0.23 + defaultPadding * 8;
    if (!isAdding) titleFocusNode.unfocus();

    return WillPopScope(
      onWillPop: () async {
        setState(() {
          isAdding = false;
        });
        return false;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFEDF2F5),
          bottomNavigationBar: !isAdding
              ? AddBtn(
                  openAddForm: () {
                    setState(() {
                      isAdding = true;
                    });
                  },
                )
              : null,
          body: SafeArea(
            child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    titleSpacing: 0,
                    title: SizedBox(
                      height: headerHeight + defaultPadding * 2,
                      child: Stack(
                        children: [
                          Positioned(
                            top: isAdding ? 0 : -headerHeight,
                            bottom: 0,
                            child: Container(
                              width: size.width,
                              height: headerHeight,
                              color: isAdding
                                  ? Colors.black38
                                  : Colors.transparent,
                            ),
                          ),
                          Positioned(
                            top: defaultPadding * 2,
                            left: defaultPadding,
                            right: defaultPadding,
                            child:
                                Header(height: headerHeight, onQuery: onQuery),
                          ),
                        ],
                      ),
                    ),
                    toolbarHeight:
                        isAdding ? 0 : headerHeight + defaultPadding * 2,
                    backgroundColor: Colors.transparent,
                    leading: const SizedBox(),
                    leadingWidth: 0,
                  )
                ];
              },
              body: Stack(children: [
                CollectionList(
                  data: collectionService.data,
                  query: _query,
                ),
                Positioned(
                  top: isAdding ? 0 : size.height,
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          titleFocusNode.unfocus();
                          setState(() {
                            isAdding = false;
                          });
                        },
                        child: Container(
                          width: size.width,
                          height: size.height,
                          decoration: const BoxDecoration(
                            color: Colors.black38,
                          ),
                        ),
                      ),
                      _buildAddForm(context, collectionService, headerHeight),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddForm(BuildContext context,
      CollectionService collectionService, double headerHeight) {
    final size = MediaQuery.of(context).size;
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 400),
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
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Adding your own collection',
                      style: TextStyle(
                          fontSize: size.width * 0.07,
                          fontWeight: FontWeight.w600),
                    ),
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
                ],
              ),
              const SizedBox(height: defaultPadding * 2),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 80, minHeight: 40),
                child: TextField(
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
                    fontSize: size.height * 0.05,
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
          children: const [
            Icon(Icons.check),
            SizedBox(width: 12.0),
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
    showToast(
        fToast, const ErrorToast(errorText: 'Title must not be empty'), 1);
  }
}
