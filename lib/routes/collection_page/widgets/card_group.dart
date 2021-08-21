import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/services/card_service.dart';
import 'package:lingua_eidetic/routes/collection_page/collection_page.dart';

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
  // var levels = Map<int, List<String>>();
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
            color: Color(0xFFD9E4FF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: StreamBuilder<QuerySnapshot>(
            stream: cardService.data,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox();
              }

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                  childAspectRatio: 1 / 1,
                  mainAxisSpacing: defaultPadding * 2,
                  crossAxisSpacing: defaultPadding * 2,
                ),
                itemBuilder: (context, index) {
                  final memoryCard =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;

                  int level = memoryCard['level'] as int;
                  String imagePath = memoryCard['imagePath'];

                  if (widget.isExpand && level - 1 == widget.index) {
                    return Offstage(
                      offstage: !widget.isExpand,
                      child: Padding(
                        padding: const EdgeInsets.all(defaultPadding),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Image.network(
                            memoryCard['imagePath'],
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    );
                  }
                  // if (levels[level] == null) levels[level] = [];
                  // if (!levels[level]!.contains(imagePath)) levels[level]!.add(
                  //     imagePath);
                  return SizedBox();
                },
                itemCount: snapshot.data!.docs.length,
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
