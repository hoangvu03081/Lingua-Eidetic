import 'package:flutter/material.dart';
import 'package:lingua_eidetic/routes/collection_page/widgets/card_group.dart';
import 'package:lingua_eidetic/routes/collection_page/widgets/header.dart';
import 'package:lingua_eidetic/routes/routes.dart';
import 'package:lingua_eidetic/services/collection_service.dart';
import 'package:lingua_eidetic/services/image_service.dart';
import 'package:lingua_eidetic/widgets/collection_navbar.dart';
import 'package:lingua_eidetic/widgets/custom_header.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({Key? key, required this.id, required this.title})
      : super(key: key);

  final String id;
  final String title;
  static const Map<int, String> titles = {
    1: 'Newcomer',
    2: 'Spirited',
    3: 'Seasoned',
    4: 'Sage',
    5: 'Onii chan'
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
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                floating: true,
                titleSpacing: 0,
                title: CustomHeader(
                  leadingIcon: Icon(
                    Icons.chevron_left,
                    color: Theme.of(context).accentColor,
                    size: 32,
                  ),
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
