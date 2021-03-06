import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/models/memory_card.dart';
import 'package:lingua_eidetic/routes/add_memory_card_page/utilities/generate_word.dart';
import 'package:lingua_eidetic/routes/collection_page/collection_page.dart';
import 'package:lingua_eidetic/routes/collection_page/widgets/caption_textfield.dart';
import 'package:lingua_eidetic/routes/collection_page/widgets/title_header.dart';
import 'package:lingua_eidetic/routes/community/widgets/auto_gen_btn.dart';
import 'package:lingua_eidetic/routes/homepage/widgets/text_badge.dart';
import 'package:lingua_eidetic/routes/share_collection/widgets/appbar.dart';
import 'package:lingua_eidetic/services/card_service.dart';
import 'package:lingua_eidetic/services/review_service.dart';
import 'package:lingua_eidetic/widgets/custom_header.dart';

class EditingCollectionPage extends StatefulWidget {
  const EditingCollectionPage({
    Key? key,
    required this.title,
    required this.card,
    required this.imagePath,
    required this.id,
  }) : super(key: key);
  final String title;
  final MemoryCard card;
  final String imagePath;
  final String id;

  @override
  _EditingCollectionPageState createState() => _EditingCollectionPageState();
}

class _EditingCollectionPageState extends State<EditingCollectionPage> {
  final _generateCap = GenerationCap();
  final cardService = CardService();
  var captionTextFieldKey = UniqueKey();
  List<String> captionList = [];

  @override
  void initState() {
    super.initState();
    _generateCap.makeCaptionfromImg(0, widget.imagePath);
    captionList.addAll(widget.card.caption);
  }

  void autoGenerateCaption() {
    setState(() {
      final caption = _generateCap.getStringCaption(0);
      for (String value in caption) {
        if (!(captionList.contains(value) || value.trim() == '')) {
          captionList.add(value);
        }
      }
      captionTextFieldKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding * 2,
              vertical: defaultPadding * 2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomHeader(
                  leadingIcon: Icon(
                    Icons.chevron_left,
                    color: Theme.of(context).accentColor,
                    size: 32,
                  ),
                  title: widget.title,
                  height: 75,
                  action: GestureDetector(
                    onTap: () {
                      cardService.addCardCaption(
                          cardId: widget.id, captions: captionList);
                      Navigator.of(context).pop();
                    },
                    child: const Icon(Icons.done, size: 32),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        offset: const Offset(0, 4),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Image.file(
                      File(widget.imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: defaultPadding * 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextBadge(
                      text:
                          'Level: ${CollectionPage.titles[widget.card.level]}',
                      fontSize: 14,
                      padding: const EdgeInsets.symmetric(
                        vertical: defaultPadding,
                        horizontal: defaultPadding * 1.5,
                      ),
                      backColor: const Color(0xFF75A4FF),
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(width: defaultPadding * 2),
                    TextBadge(
                      text:
                          'Exp: ${widget.card.exp}/${ReviewService.levelSystem[widget.card.level]?.maxExp}',
                      fontSize: 14,
                      padding: const EdgeInsets.symmetric(
                        vertical: defaultPadding,
                        horizontal: defaultPadding * 1.5,
                      ),
                      backColor: const Color(0xFF75A4FF),
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                const SizedBox(height: defaultPadding * 2),
                FutureBuilder<String>(
                    future: cardService.getTimeCoolDown(
                        timeAvailable: widget.card.available),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }
                      if (snapshot.hasData) {
                        final availIn = snapshot.data!;
                        return TitleHeader(
                          title: availIn == ''
                              ? 'Available Now'
                              : 'Cooldown: $availIn',
                          backColor: const Color(0xFF2A3387),
                        );
                      }
                      return const SizedBox();
                    }),
                const SizedBox(height: defaultPadding * 2),
                Padding(
                  padding: const EdgeInsets.only(left: defaultPadding),
                  child: Text(
                    'Captions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
                const SizedBox(height: defaultPadding),
                ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 155),
                  child: CaptionTextField(
                    key: captionTextFieldKey,
                    items: captionList,
                    onChange: (items) {
                      captionList = items;
                    },
                  ),
                ),
                const SizedBox(height: defaultPadding),
                AutoGenBtn(onPressed: autoGenerateCaption),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
