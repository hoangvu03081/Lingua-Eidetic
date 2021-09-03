import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/models/memory_card.dart';
import 'package:lingua_eidetic/services/card_service.dart';
import 'package:lingua_eidetic/routes/collection_page/collection_page.dart';
import 'package:lingua_eidetic/utilities/firestore_path.dart';
import 'package:lingua_eidetic/widgets/outer_box_shadow.dart';

class CardGroup extends StatefulWidget {
  const CardGroup({
    Key? key,
    required this.index,
    required this.isExpand,
  }) : super(key: key);
  final int index;
  final bool isExpand;

  @override
  _CardGroupState createState() => _CardGroupState();
}

class _CardGroupState extends State<CardGroup> {
  final List<MemoryCard> gridItems = [];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardService = CardService();

    return Column(
      children: [
        _buildHeading(context, CollectionPage.titles[widget.index]!),
        AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          height: widget.isExpand ? size.height * 0.5 : 0,
          margin: EdgeInsets.all(widget.isExpand ? defaultPadding * 2 : 0),
          decoration: BoxDecoration(
            color: const Color(0xFFD9E4FF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: StreamBuilder<QuerySnapshot>(
            stream: cardService.data,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting ||
                  !snapshot.hasData) {
                return const SizedBox();
              }

              final data = snapshot.data!;
              final docs = data.docs;
              gridItems.clear();

              for (int i = 0; i < data.docs.length; i++) {
                final item = docs[i].data() as Map<String, dynamic>;

                if (widget.isExpand &&
                    widget.index + 1 == item['level'] as int) {
                  gridItems.add(MemoryCard.fromMap(item));
                }
              }
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 1 / 1,
                  mainAxisSpacing: defaultPadding,
                  crossAxisSpacing: defaultPadding,
                ),
                itemBuilder: (context, index) {
                  // final memoryCard = gridItems[index];
                  // int level = memoryCard.level;
                  final id = docs[index].id;

                  return Offstage(
                    offstage: !widget.isExpand,
                    child: Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          decoration: BoxDecoration(boxShadow: [
                            OuterBoxShadow(
                                blurRadius: 4,
                                offset: const Offset(0, 4),
                                color: Colors.black.withOpacity(0.25))
                          ]),
                          child: FutureBuilder<String>(
                            future: cardService.getImage(cardId: id),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Image.file(
                                  File(snapshot.data!),
                                  fit: BoxFit.cover,
                                );
                              }
                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: gridItems.length,
              );
            },
          ),
        ),
        const SizedBox(height: defaultPadding * 2),
      ],
    );
  }

  Widget _buildHeading(BuildContext context, String title) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Positioned.fill(
          left: size.width / 8,
          right: size.width / 8,
          child: const Divider(
            color: Color(0xFFB2CDFF),
          ),
        ),
        Positioned(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: defaultPadding,
                horizontal: defaultPadding * 2,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF8FA6FA),
                borderRadius: BorderRadius.circular(200),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
