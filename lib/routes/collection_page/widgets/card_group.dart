import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/models/memory_card.dart';
import 'package:lingua_eidetic/services/card_service.dart';
import 'package:lingua_eidetic/routes/collection_page/collection_page.dart';
import 'package:lingua_eidetic/utilities/firestore_path.dart';

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
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardService = CardService();

    return Column(
      children: [
        _buildHeading(CollectionPage.titles[widget.index]),
        AnimatedContainer(
          duration: Duration(milliseconds: 600),
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

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              }

              final data = snapshot.data!;
              final docs = data.docs;
              final List<MemoryCard> gridItems = [];

              for (int i = 0; i < data.docs.length; i++) {
                final item = docs[i].data() as Map<String, dynamic>;

                if (widget.isExpand &&
                    widget.index + 1 == item['level'] as int) {
                  gridItems.add(MemoryCard.fromMap(item));
                }
              }

              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                  childAspectRatio: 1 / 1,
                  mainAxisSpacing: defaultPadding * 2,
                  crossAxisSpacing: defaultPadding * 2,
                ),
                itemBuilder: (context, index) {
                  final memoryCard = gridItems[index];
                  int level = memoryCard.level;
                  final id = snapshot.data!.docs[index].id;

                  return Offstage(
                    offstage: !widget.isExpand,
                    child: Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: FutureBuilder<Image>(
                          future: cardService.getImage(cardId: id),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return snapshot.data!;
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          },
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
        SizedBox(height: defaultPadding * 2),
      ],
    );
  }

  Widget _buildHeading(title) {
    return Stack(
      children: [
        Positioned.fill(
          child: Divider(
            color: Color(0xFFB2CDFF),
          ),
        ),
        Positioned(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: defaultPadding,
                horizontal: defaultPadding * 2,
              ),
              decoration: BoxDecoration(
                color: Color(0xFF8FA6FA),
                borderRadius: BorderRadius.circular(200),
              ),
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
