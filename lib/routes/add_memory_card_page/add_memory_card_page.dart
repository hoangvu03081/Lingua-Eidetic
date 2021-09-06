import 'dart:io';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/models/memory_card.dart';
import 'package:lingua_eidetic/routes/collection_page/widgets/caption_textfield.dart';
import 'package:lingua_eidetic/routes/community/widgets/auto_gen_btn.dart';
import 'package:lingua_eidetic/services/card_service.dart';
import 'package:lingua_eidetic/routes/add_memory_card_page/utilities/generate_word.dart';

class AddMemoryCardPage extends StatefulWidget {
  const AddMemoryCardPage({Key? key, required this.images}) : super(key: key);
  final List<String>? images;

  @override
  _AddMemoryCardPageState createState() => _AddMemoryCardPageState();
}

class _AddMemoryCardPageState extends State<AddMemoryCardPage> {
  int _activeIndex = 0;
  final focusNode = FocusNode();
  final _generateCap = GenerationCap();
  List<List<String>> captionLists = [];

  @override
  void initState() {
    super.initState();
    _generateCap.makeCaptionfromList(widget.images!);
    captionLists.addAll(List.generate(widget.images!.length, (index) => []));
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
  }

  void autoGenerateCaption() {
    setState(() {
      final captions = _generateCap.getStringCaption(_activeIndex);
      for (String value in captions) {
        if (!(captionLists[_activeIndex].contains(value) ||
            value.trim() == '')) {
          captionLists[_activeIndex].add(value);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardService = CardService();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.west),
              color: Theme.of(context).accentColor,
            ),
            Expanded(
              child: Text(
                'Add to your collection',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
            SizedBox(
              width: 40,
              child: IconButton(
                splashRadius: 15,
                onPressed: () {
                  focusNode.unfocus();
                  for (int i = 0; i < captionLists.length; i++) {
                    cardService.addCard(
                        MemoryCard(
                          imagePath: '',
                          caption: captionLists[i],
                          available: DateTime.now(),
                        ),
                        widget.images![i]);
                  }
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.done),
                color: Theme.of(context).accentColor,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 70,
        leading: const SizedBox(),
        leadingWidth: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding * 2),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: size.width,
                decoration: BoxDecoration(
                  color: const Color(0xFFD9E4FF),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 4,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Swiper(
                      onIndexChanged: (index) {
                        setState(() {
                          _activeIndex = index;
                        });
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return Image.file(
                          File(widget.images![index]),
                          fit: BoxFit.cover,
                        );
                      },
                      itemCount: widget.images!.length,
                      outer: true,
                      loop: false,
                      control: const SwiperControl(
                        iconPrevious: Icons.arrow_left,
                        iconNext: Icons.arrow_right,
                        size: 50,
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: defaultPadding * 2),
                  const Text(
                    'Captions',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: defaultPadding),
                  CaptionTextField(
                    key: UniqueKey(),
                    items: captionLists[_activeIndex],
                    onChange: (items) {
                      captionLists[_activeIndex] = items;
                    },
                  ),
                  const SizedBox(height: defaultPadding),
                  AutoGenBtn(onPressed: autoGenerateCaption),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
