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
import 'package:lingua_eidetic/services/review_service.dart';

class EditingCollectionPage extends StatefulWidget {
  const EditingCollectionPage({
    Key? key,
    required this.title,
    required this.card,
    required this.imagePath,
  }) : super(key: key);
  final String title;
  final MemoryCard card;
  final String imagePath;

  @override
  _EditingCollectionPageState createState() => _EditingCollectionPageState();
}

class _EditingCollectionPageState extends State<EditingCollectionPage> {
  final _generateCap = GenerationCap();
  final List<String> captionList = [];

  @override
  void initState() {
    super.initState();
    _generateCap.makeCaptionfromImg(0, widget.imagePath);
    captionList.addAll(widget.card.caption);
  }

  void autoGenerateCaption() {
    final caption = _generateCap.getStringCaption(0);
    setState(() {
      for (String value in caption) {
        if (!(captionList.contains(value) || value.trim() == '')) {
          captionList.add(value);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final availIn = widget.card.available.difference(DateTime.now());
    final hours = availIn.inHours;
    final minutes = availIn.inMinutes;
    final size = MediaQuery.of(context).size;

    /// TODO: them button
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: getCustomAppBar(context, widget.title),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding * 2,
              vertical: defaultPadding * 2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                TitleHeader(
                  title: hours < 0
                      ? 'Available'
                      : hours == 0
                          ? minutes < 0
                              ? 'Available'
                              : 'Cooldown: $minutes minutes'
                          : 'Cooldown: $hours hours',
                  backColor: const Color(0xFF2A3387),
                ),
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
                  child: CaptionTextField(key: UniqueKey(), items: captionList),
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
