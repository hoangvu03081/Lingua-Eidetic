import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/routes/homepage/widgets/add_btn.dart';
import 'package:lingua_eidetic/widgets/custom_toast.dart';
import 'package:lingua_eidetic/routes/homepage/widgets/collection_list.dart';
import 'package:lingua_eidetic/services/collection_service.dart';

class HomePageV2 extends StatefulWidget {
  const HomePageV2({Key? key}) : super(key: key);

  @override
  _HomePageV2State createState() => _HomePageV2State();
}

class _HomePageV2State extends State<HomePageV2> {
  late final fToast = FToast();

  @override
  void initState() {
    super.initState();
    fToast.init(context);
  }

  String title = '';

  String _query = '';

  void onQuery(String query) {
    setState(() {
      _query = query;
    });
  }

  final collectionService = CollectionService();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        bottomNavigationBar: AddBtn(
          openAddForm: () {
            _buildAddFormV2(context);
          },
        ),
        body: SafeArea(
          // child: NestedScrollView(
          //   headerSliverBuilder:
          //       (BuildContext context, bool innerBoxIsScrolled) {
          //     return [
          //       SliverAppBar(
          //         titleSpacing: 0,
          //         title: SizedBox(
          //           height: headerHeight + defaultPadding * 2,
          //           child: Padding(
          //             padding: const EdgeInsets.only(
          //               top: defaultPadding * 2,
          //               left: defaultPadding,
          //               right: defaultPadding,
          //             ),
          //             child: Header(height: headerHeight, onQuery: onQuery),
          //           ),
          //         ),
          //         toolbarHeight: headerHeight + defaultPadding * 2,
          //         backgroundColor: Colors.transparent,
          //         leading: const SizedBox(),
          //         leadingWidth: 0,
          //       )
          //     ];
          //   },
          //   body: CollectionList(
          //     data: collectionService.data,
          //     query: _query,
          //   ),
          // ),
          child: CollectionList(
            data: collectionService.data,
            query: _query,
            onQuery: onQuery,
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

  void _addingSuccessfully(String title) {
    collectionService.addCollection(name: title);
    showToast(
      fToast: fToast,
      child:
          const SuccessToast(successText: 'Successfully added the collection'),
      seconds: 3,
      bottom: defaultPadding * 4,
      left: 0,
      right: 0,
    );
  }

  void _titleEmptyToast() {
    showToast(
      fToast: fToast,
      child: const ErrorToast(errorText: 'Title must not be empty'),
      seconds: 2,
      bottom: defaultPadding * 4,
      left: 0,
      right: 0,
    );
  }

  Future<void> _buildAddFormV2(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Input your collection name below:',
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontWeight: FontWeight.bold),
          ),
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
                    autofocus: true,
                    onChanged: (String value) {
                      title = value;
                    },
                    onSubmitted: (String value) {
                      _addCollection(value);
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
                    _addCollection(title);
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

  void _addCollection(String title) {
    print('Not error yet');
    if (title.trim() == '') {
      _titleEmptyToast();
      return;
    }
    _addingSuccessfully(title);
    Navigator.of(context).pop();
  }
}
