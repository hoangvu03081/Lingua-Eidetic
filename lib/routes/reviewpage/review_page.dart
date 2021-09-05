import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lingua_eidetic/routes/routes.dart';
import 'package:lingua_eidetic/services/card_service.dart';
import 'package:lingua_eidetic/services/collection_service.dart';
import 'package:lingua_eidetic/services/review_service.dart';
import 'package:lingua_eidetic/utilities/firestore_path.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocus = FocusNode();
  late final AnimationController _animationController;
  late final OverlayEntry _animationOverlay;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _animationOverlay = _initAnimation();
      Overlay.of(context)!.insert(_animationOverlay);
    });
  }

  OverlayEntry _initAnimation() {
    return OverlayEntry(builder: (_) {
      {
        final renderBox = context.findRenderObject() as RenderBox;
        final size = renderBox.size;
        final offset = renderBox.localToGlobal(Offset.zero);
        return Positioned(
            left: offset.dx,
            bottom: offset.dy,
            child: IgnorePointer(
              ignoring: true,
              child: SizedBox(
                width: size.width,
                height: size.height * 0.5,
                child: Lottie.asset('assets/sparkle.json',
                    controller: _animationController),
              ),
            ));
      }
      ;
    });
  }

  void displayAnimation() async {
    _animationController
        .forward()
        .then((value) => _animationController.reset());
  }

  @override
  Widget build(BuildContext context) {
    final cardService = CardService();
    final reviewService = context.watch<ReviewService>();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFEDF2F5),
      body: FutureBuilder<List<QueryDocumentSnapshot<Object?>>>(
        future: reviewService.data,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SizedBox(
              height: size.height,
              width: size.width,
              child: const Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator()),
            );
          }

          reviewService.size = snapshot.data!.length;
          final cardList = snapshot.data!;
          int current = reviewService.current;
          int length = snapshot.data!.length;

          return SingleChildScrollView(
            child: SizedBox(
              height: size.height,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: size.height * 0.1),
                      Text(
                        '$current/$length',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: const Color(0xFF172853),
                        ),
                      ),
                      Row(
                        children: [
                          const Spacer(flex: 5),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Icon(
                              Icons.close,
                              color: const Color(0xFF3C5BA5),
                              size: 35,
                            ),
                          ),
                          const Spacer(flex: 5),
                          Flexible(
                            flex: 65,
                            child: SizedBox(
                                width: size.width * 0.65,
                                child: LinearProgressIndicator(
                                  value: current / length,
                                  color: const Color(0xFF87ABFF),
                                  backgroundColor: const Color(0xFFCFD9FF),
                                )),
                          ),
                          const Spacer(flex: 20)
                        ],
                      ),
                      SizedBox(height: size.height * 0.03),
                      SizedBox(
                        width: size.width * 0.75,
                        height: size.height * 0.6,
                        child: Card(
                          child: FutureBuilder<String>(
                              future: cardService.getImage(
                                  cardId: cardList[current].id),
                              builder: (_, snapshot) {
                                if (snapshot.hasData) {
                                  return Image(
                                    image: FileImage(File(snapshot.data!)),
                                    fit: BoxFit.contain,
                                  );
                                }
                                return const Center(
                                    child: CircularProgressIndicator());
                              }),
                        ),
                      ),
                      SizedBox(height: size.height * 0.05),
                      Container(
                          width: size.width * 0.6,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: TextField(
                                controller: _textController,
                                focusNode: _textFocus,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  hintText: 'Input here',
                                  hintStyle: TextStyle(
                                      color: Colors.grey.withOpacity(0.5)),
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                ),
                                style: const TextStyle(
                                    color: Color(0xFF242343),
                                    fontWeight: FontWeight.bold),
                                onSubmitted: (text) async {
                                  if (reviewService.checkCorrect(
                                    input: text,
                                    memoryCard: cardList[current],
                                  )) {
                                    _textController.text = '';
                                    if (current >= length - 1)
                                      Navigator.of(context).pop();
                                    else {
                                      reviewService.updateCurrent(current + 1);
                                      displayAnimation();
                                    }
                                    return;
                                  }
                                  ReviewStatus reviewStatus =
                                      await Navigator.of(context).pushNamed(
                                    RouteGenerator.WRONG_REVIEW_PAGE,
                                    arguments: {
                                      'text': text,
                                      'card': cardList[current],
                                    },
                                  ) as ReviewStatus;
                                  switch (reviewStatus) {
                                    case ReviewStatus.CONTINUE:
                                      reviewService.updateWrongCard(
                                          memoryCard: cardList[current]);
                                      break;
                                    case ReviewStatus.ADD:
                                      reviewService.addCaptionWrongCard(
                                          memoryCard: cardList[current],
                                          text: text);
                                      break;
                                    case ReviewStatus.IGNORE:
                                      print('ignore');
                                      break;
                                    default:
                                  }
                                  _textController.text = '';
                                  if (current >= length - 1)
                                    Navigator.of(context).pop();
                                  else
                                    reviewService.updateCurrent(current + 1);
                                }),
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFFFF),
                            border: Border.all(color: const Color(0xFFE4E4E4)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 0,
                                  blurRadius: 4,
                                  offset: const Offset(0, 4))
                            ],
                            borderRadius: BorderRadius.circular(0),
                          )),
                    ],
                  ),
                  // Positioned(
                  //   height: size.height * 0.1,
                  //   width: size.width,
                  //   bottom: size.height * 0.1,
                  //   child: Lottie.network(
                  //     'https://assets6.lottiefiles.com/packages/lf20_b7rQjC.json',
                  //     fit: BoxFit.cover,
                  //     controller: _animationController,
                  //   ),
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _textFocus.dispose();
    _animationController.dispose();
    _animationOverlay.remove();
    super.dispose();
  }
}
