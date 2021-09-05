import 'dart:async';

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

  final collectionService = CollectionService();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const headerHeight = 114 + defaultPadding * 6;

    return WillPopScope(
      onWillPop: () async {
        removeOverlay();
        return false;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFEDF2F5),
          bottomNavigationBar: AddBtn(
            openAddForm: () {
              _buildAddFormV2(context);
            },
          ),
          body: SafeArea(
            child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    titleSpacing: 0,
                    title: SizedBox(
                      height: headerHeight + defaultPadding * 2,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: defaultPadding * 2,
                          left: defaultPadding,
                          right: defaultPadding,
                        ),
                        child: Header(height: headerHeight, onQuery: onQuery),
                      ),
                    ),
                    toolbarHeight: headerHeight + defaultPadding * 2,
                    backgroundColor: Colors.transparent,
                    leading: const SizedBox(),
                    leadingWidth: 0,
                  )
                ];
              },
              body: CollectionList(
                data: collectionService.data,
                query: _query,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildAddForm(BuildContext context,
  //     CollectionService collectionService, double headerHeight) {
  //   final size = MediaQuery.of(context).size;
  //   double top = size.height * 0.4 - MediaQuery.of(context).viewInsets.bottom;

  //   return AnimatedPositioned(
  //     duration: const Duration(milliseconds: 400),
  //     left: 0,
  //     right: 0,
  //     top: isAdding ? top : size.height,
  //     child: ClipRRect(
  //       borderRadius: const BorderRadius.only(
  //           topLeft: Radius.circular(22), topRight: Radius.circular(22)),
  //       child: Container(
  //         height: size.height,
  //         padding: const EdgeInsets.symmetric(
  //             horizontal: defaultPadding * 2, vertical: defaultPadding * 2),
  //         decoration: const BoxDecoration(
  //           color: Colors.white,
  //         ),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             const Text(
  //               'Adding your own collection',
  //               style: TextStyle(
  //                 fontSize: 24,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //             const SizedBox(height: defaultPadding * 2),
  //             Row(
  //               children: [
  //                 Expanded(
  //                   child: SizedBox(
  //                     height: 38,
  //                     child: TextField(
  //                       focusNode: titleFocusNode,
  //                       controller: titleController,
  //                       onEditingComplete: () {
  //                         if (titleController.text.isEmpty) {
  //                           _titleEmptyToast();
  //                           return;
  //                         }
  //                         _addingSuccessfully(collectionService);
  //                       },
  //                       style: const TextStyle(
  //                         fontSize: 16,
  //                       ),
  //                       decoration: const InputDecoration(
  //                         labelText: 'Your title',
  //                         focusedBorder: OutlineInputBorder(
  //                           borderSide:
  //                               BorderSide(color: Colors.black54, width: 1),
  //                         ),
  //                         contentPadding:
  //                             EdgeInsets.symmetric(horizontal: defaultPadding),
  //                         enabledBorder: OutlineInputBorder(
  //                           borderSide:
  //                               BorderSide(color: Colors.black38, width: 1),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(width: defaultPadding),
  //                 ElevatedButton(
  //                   onPressed: () {
  //                     if (titleController.text.isEmpty) {
  //                       _titleEmptyToast();
  //                       return;
  //                     }
  //                     _addingSuccessfully(collectionService);
  //                   },
  //                   child: const Text('Add'),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  void _addingSuccessfully() {
    collectionService.addCollection(name: titleController.text);
    titleFocusNode.unfocus();
    showToast(
      fToast,
      const SuccessToast(successText: 'Successfully added the collection'),
      3,
      bottom: defaultPadding * 4,
      left: 0,
      right: 0,
    );
    titleController.clear();
  }

  void _titleEmptyToast() {
    showToast(
      fToast,
      const ErrorToast(errorText: 'Title must not be empty'),
      2,
      bottom: defaultPadding * 4,
      left: 0,
      right: 0,
    );
  }

  OverlayEntry? overlayEntry;
  void removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry!.remove();
      overlayEntry = null;
    }
  }

  Future<void> _buildAddFormV2(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Input your collection name below:'),
          titlePadding: const EdgeInsets.only(
            top: defaultPadding * 2,
            left: defaultPadding * 2,
            right: defaultPadding * 2,
            bottom: 0,
          ),
          contentPadding: const EdgeInsets.only(
            left: defaultPadding * 2,
            right: defaultPadding * 2,
            bottom: defaultPadding * 2,
            top: defaultPadding,
          ),
          content: SingleChildScrollView(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: titleController,
                    onSubmitted: (String value) {
                      _addCollection();
                    },
                    style: const TextStyle(fontSize: 16),
                    decoration: const InputDecoration(
                      hintText: 'Collection name',
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: defaultPadding,
                        vertical: defaultPadding / 2,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _addCollection();
                  },
                  child: const Text('Add'),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _addCollection() {
    if (titleController.text.isEmpty) {
      _titleEmptyToast();
      return;
    }
    _addingSuccessfully();
    Navigator.of(context).pop();
  }
}
