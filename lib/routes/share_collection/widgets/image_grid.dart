import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/routes/share_collection/models/image_model.dart';
import 'package:lingua_eidetic/services/card_service.dart';
import 'package:provider/provider.dart';

class ImageGrid extends StatefulWidget {
  const ImageGrid({Key? key, required this.docs}) : super(key: key);
  final List<QueryDocumentSnapshot<Object?>> docs;
  @override
  _ImageGridState createState() => _ImageGridState();
}

class _ImageGridState extends State<ImageGrid> {
  final List<String> imagePaths = [];
  final cardService = CardService();

  @override
  void initState() {
    super.initState();
    imagePaths.addAll(List<String>.generate(widget.docs.length, (index) => ''));
  }

  @override
  Widget build(BuildContext context) {
    final imageModel = Provider.of<ImageModel>(context);

    return GridView.builder(
      padding: const EdgeInsets.all(defaultPadding * 2),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 1 / 1,
        mainAxisSpacing: defaultPadding * 2,
        crossAxisSpacing: defaultPadding * 2,
      ),
      itemBuilder: (BuildContext context, int index) {
        final id = widget.docs[index].id;
        bool isSelected = false;
        for (int i = 0; i < imageModel.imagePaths.length; i++) {
          if (imageModel.imagePaths[i].index == index) isSelected = true;
        }
        return GestureDetector(
          onLongPress: () {
            selectIndex(imageModel, index);
          },
          onTap: () {
            if (imageModel.imagePaths.isNotEmpty) {
              selectIndex(imageModel, index);
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                border: isSelected
                    ? Border.all(
                        width: 4,
                        color: const Color(0xFF755FFF),
                      )
                    : Border.all(
                        width: 4,
                        color: const Color(0xFFCDCDCD),
                      ),
              ),
              child: FutureBuilder<String>(
                future: cardService.getImage(cardId: id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (imagePaths[index] == '') {
                      imagePaths[index] = snapshot.data!;
                    }

                    return Stack(
                      children: [
                        Positioned.fill(
                          child: Image.file(
                            File(snapshot.data!),
                            fit: BoxFit.cover,
                          ),
                        ),
                        if (isSelected)
                          Container(color: const Color(0x508978F0)),
                        if (isSelected)
                          const Center(
                            child: CircleAvatar(
                              child: Icon(
                                Icons.check,
                                size: 32,
                              ),
                              radius: 24,
                            ),
                          )
                      ],
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
        );
      },
      itemCount: widget.docs.length,
    );
  }

  void selectIndex(ImageModel imageModel, int index) {
    bool isNew = true;
    for (int i = 0; i < imageModel.imagePaths.length; i++) {
      if (imageModel.imagePaths[i].index == index) {
        imageModel.remove(ItemModel(index: index, path: imagePaths[index]));
        isNew = false;
        break;
      }
    }
    if (isNew) {
      imageModel.add(ItemModel(index: index, path: imagePaths[index]));
    }
  }
}
