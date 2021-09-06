import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/routes/share_collection/models/image_model.dart';
import 'package:lingua_eidetic/routes/share_collection/widgets/appbar.dart';
import 'package:lingua_eidetic/routes/share_collection/widgets/image_grid.dart';
import 'package:lingua_eidetic/services/card_service.dart';
import 'package:lingua_eidetic/widgets/custom_toast.dart';
import 'package:provider/provider.dart';

class DescriptionImagesPage extends StatefulWidget {
  const DescriptionImagesPage({Key? key}) : super(key: key);

  @override
  _DescriptionImagesPageState createState() => _DescriptionImagesPageState();
}

class _DescriptionImagesPageState extends State<DescriptionImagesPage> {
  late final fToast = FToast();
  @override
  void initState() {
    super.initState();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    final cardService = CardService();
    return ChangeNotifierProvider(
      create: (context) => ImageModel(),
      child: Scaffold(
        floatingActionButton: Consumer<ImageModel>(
          builder: (context, images, child) {
            return GestureDetector(
              child: child!,
              onTap: () {
                if (images.imagePaths.length < 2) {
                  showToast(
                    fToast: fToast,
                    child: const ErrorToast(
                        errorText: 'Please choose at least 2 images'),
                  );
                  return;
                }
                Navigator.of(context).pop(images.imagePaths);
              },
            );
          },
          child: CircleAvatar(
            backgroundColor: Theme.of(context).accentColor,
            child: const Icon(
              Icons.check,
              color: Colors.white,
            ),
          ),
        ),
        appBar: getCustomAppBar(
          context,
          'Images',
          actions: [
            Padding(
              padding: const EdgeInsets.only(
                right: defaultPadding,
                top: 2,
              ),
              child: Center(
                child: Consumer<ImageModel>(
                  builder: (context, images, child) {
                    return Text(
                      '${images.length} Selected',
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            const Divider(
              indent: defaultPadding * 4,
              endIndent: defaultPadding * 4,
              color: Color(0xFFB2CDFF),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: cardService.data,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      !snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final data = snapshot.data!;
                  final docs = data.docs;

                  return ImageGrid(docs: docs);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
