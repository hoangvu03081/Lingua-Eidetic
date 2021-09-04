import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/models/memory_card.dart';
import 'package:lingua_eidetic/routes/collection_page/widgets/card_group.dart';
import 'package:lingua_eidetic/routes/collection_page/widgets/header.dart';
import 'package:lingua_eidetic/routes/routes.dart';
import 'package:lingua_eidetic/services/card_service.dart';
import 'package:lingua_eidetic/services/collection_service.dart';
import 'package:lingua_eidetic/services/image_service.dart';
import 'package:lingua_eidetic/widgets/collection_navbar.dart';

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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      bottomNavigationBar: CollectionNavbar(galleryButtonFunction: () async {
        final List<String>? temp = await imageService.getMutlipleImages();
        if (temp != null) {
          Navigator.of(context)
              .pushNamed(RouteGenerator.ADD_COLLECTION_PAGE, arguments: temp);
        }
      }, cameraButtonFunction: () async {
        final String? temp = await imageService.getImageFromCamera();
        if (temp != null) {
          Navigator.of(context)
              .pushNamed(RouteGenerator.ADD_COLLECTION_PAGE, arguments: [temp]);
        }
      }),
      backgroundColor: const Color(0xFFEDF2F5),
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                floating: true,
                titleSpacing: 0,
                title: Header(
                  height: 75,
                  title: widget.title,
                ),
                backgroundColor: Colors.transparent,
                toolbarHeight: 75,
                leading: const SizedBox(),
                leadingWidth: 0,
              )
            ];
          },
          body: SingleChildScrollView(
            child: Column(
              children:
                  List.generate(expandArr.length, (index) => _buildCard(index))
                      .toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (prevActive == index && expandArr[prevActive]) {
            expandArr[prevActive] = false;
          } else {
            expandArr[prevActive] = false;
            expandArr[index] = true;
            prevActive = index;
          }
        });
      },
      child: CardGroup(
        index: index,
        isExpand: expandArr[index],
        collectionTitle: widget.title,
      ),
    );
  }
}
