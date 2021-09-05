import 'dart:io';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/models/memory_card.dart';
import 'package:lingua_eidetic/services/card_service.dart';
import 'package:lingua_eidetic/services/collection_service.dart';
import 'package:lingua_eidetic/routes/add_memory_card_page/utilities/generate_word.dart';

class AddMemoryCardPage extends StatefulWidget {
  const AddMemoryCardPage({Key? key, required this.images}) : super(key: key);
  final List<String>? images;

  @override
  _AddMemoryCardPageState createState() => _AddMemoryCardPageState();
}

class _AddMemoryCardPageState extends State<AddMemoryCardPage> {
  int _activeIndex = 0;
  late final List<TextEditingController> _captionController;
  final focusNode = FocusNode();
  final _generateCap = GenerationCap();
  @override
  void initState() {
    super.initState();
    _generateCap.makeCaptionfromList(widget.images!);
    _captionController = List.generate(
        widget.images!.length, (index) => TextEditingController());
  }

  @override
  void dispose() {
    super.dispose();
    for (int i = 0; i < _captionController.length; i++) {
      _captionController[i].dispose();
    }
    focusNode.dispose();
  }
  void autoGenerateCaption() {
    setState(() {
      _captionController[_activeIndex].text = _generateCap.getStringCaption();
    });
    print(_generateCap.getStringCaption());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardService = CardService();
    final collectionService = CollectionService();



    return Scaffold(
      backgroundColor: const Color(0xFFEDF2F5),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.west),
              color: const Color(0xFF172853),
            ),
            const Expanded(
              child: Text(
                'Add to your collection',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF172853),
                ),
              ),
            ),
            SizedBox(
              width: 40,
              child: IconButton(
                splashRadius: 15,
                onPressed: () {
                  focusNode.unfocus();
                  for (int i = 0; i < _captionController.length; i++) {
                    cardService.addCard(
                        MemoryCard(
                            imagePath: '',
                            caption: _captionController[i].text.split(' '),
                            available: DateTime.now()),
                        widget.images![i]);
                  }
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.done),
                color: const Color(0xFF172853),
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
                height: 200,
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
                    pagination: const SwiperPagination(
                      builder:
                          DotSwiperPaginationBuilder(color: Color(0xFFCDCDCD)),
                    ),
                    control: const SwiperControl(
                      iconPrevious: Icons.arrow_left,
                      iconNext: Icons.arrow_right,
                      size: 50,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  // TODO: Change to tag textfield
                  Container(
                    height: 100,
                    child: TextField(
                      focusNode: focusNode,
                      controller: _captionController[_activeIndex],
                      maxLines: 5,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(defaultPadding),
                      ),
                      style: const TextStyle(fontSize: 20),
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        left: BorderSide(
                          color: Color(0xFF172853),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: defaultPadding),
                  GestureDetector(
                    onTap: autoGenerateCaption,
                   child: Row(
                      children: [
                        SizedBox(
                          height: 40,
                          child: Image.asset(
                            'assets/images/spinner.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: defaultPadding),
                        const Text(
                          'Auto generate caption',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
