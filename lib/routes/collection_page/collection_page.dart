import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/models/memory_card.dart';
import 'package:lingua_eidetic/routes/collection_page/widgets/card_group.dart';
import 'package:lingua_eidetic/routes/collection_page/widgets/header.dart';
import 'package:lingua_eidetic/routes/homepage/widgets/add_btn.dart';
import 'package:lingua_eidetic/routes/routes.dart';
import 'package:lingua_eidetic/services/card_service.dart';
import 'package:lingua_eidetic/services/collection_service.dart';
import 'package:lingua_eidetic/services/image_service.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({Key? key, required this.id, required this.title})
      : super(key: key);
  final String id;
  final String title;
  static const Map<int, String> titles = {
    0: 'Newcomer',
    1: 'Spirited',
    2: 'Seasoned',
    3: 'Sage',
    4: 'Onii chan'
  };

  @override
  _CollectionPageState createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  List<bool> expandArr = List.generate(
      CollectionPage.titles.length, (index) => index == 0 ? true : false);
  int prevActive = 0;

  @override
  Widget build(BuildContext context) {
    final collectionService = CollectionService();
    collectionService.current = widget.id;

    final ImageService imageService = ImageService();

    // final cardService = CardService();
    // final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFFEDF2F5),
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                floating: true,
                titleSpacing: 0,
                title: Header(
                  onPrevClicked: () {
                    Navigator.of(context).pop();
                  },
                  height: 70,
                  title: widget.title,
                ),
                backgroundColor: Colors.transparent,
                toolbarHeight: 70,
                leading: SizedBox(),
                leadingWidth: 0,
              )
            ];
          },
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: List.generate(
                      expandArr.length, (index) => _buildCard(index)).toList(),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: defaultPadding * 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final List<String>? temp =
                            await imageService.getMutlipleImages();
                        if (temp != null)
                          Navigator.of(context).pushNamed(
                              RouteGenerator.ADD_COLLECTION_PAGE,
                              arguments: temp);
                      },
                      child: Text('Add from storage'),
                    ),
                    SizedBox(width: defaultPadding * 2),
                    ElevatedButton(
                      onPressed: () async {
                        final String? temp =
                            await imageService.getImageFromCamera();
                        if (temp != null)
                          Navigator.of(context).pushNamed(
                              RouteGenerator.ADD_COLLECTION_PAGE,
                              arguments: [temp]);
                      },
                      child: Text('Add from camera'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          expandArr[prevActive] = false;
          expandArr[index] = true;
          prevActive = index;
        });
      },
      child: CardGroup(
        index: index,
        isExpand: expandArr[index],
      ),
    );
  }
}
