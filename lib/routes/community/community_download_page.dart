import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/models/comment.dart';
import 'package:lingua_eidetic/models/shared_collection.dart';
import 'package:lingua_eidetic/routes/homepage/widgets/text_badge.dart';
import 'package:lingua_eidetic/services/comment_service.dart';
import 'package:lingua_eidetic/services/community_service.dart';
import 'package:lingua_eidetic/widgets/custom_header.dart';

class CommunityDownloadPage extends StatefulWidget {
  const CommunityDownloadPage({
    Key? key,
    required this.collection,
  }) : super(key: key);
  final SharedCollection collection;

  @override
  _CommunityDownloadPageState createState() => _CommunityDownloadPageState();
}

class _CommunityDownloadPageState extends State<CommunityDownloadPage> {
  bool isDownloaded = false;
  int cLove = 0;
  bool? isAlreadyLoved;
  final controller = TextEditingController();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    cLove = widget.collection.love;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final communityService = CommunityService();
    final commentService = CommentService();
    communityService.current = widget.collection.id!;

    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            height: size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xB8CDCFFF),
                  Color(0xFFE8F7FF),
                ],
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding * 2,
                    ),
                    child: Column(
                      children: [
                        CustomHeader(
                          leadingIcon: const Icon(
                            Icons.chevron_left,
                            size: 30,
                          ),
                          title: 'title',
                          action: GestureDetector(
                            onTap: () {
                              communityService.downloadCollection();
                              setState(() {
                                isDownloaded = true;
                              });
                            },
                            child: const CircleAvatar(
                              backgroundColor: Color(0xFF172853),
                              child: Icon(
                                Icons.arrow_downward,
                                color: Colors.white,
                              ),
                              radius: 15,
                            ),
                          ),
                        ),

                        /// row statistic
                        Row(
                          children: [
                            FutureBuilder<bool>(
                              future: communityService
                                  .isAlreadyLoved(widget.collection.id!),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return const Text('Something went wrong');
                                }
                                if (snapshot.hasData) {
                                  isAlreadyLoved ??= snapshot.data!;
                                  return TextBadge(
                                    onTap: () {
                                      communityService.love();
                                      setState(() {
                                        if (isAlreadyLoved!) {
                                          cLove--;
                                        } else {
                                          cLove++;
                                        }
                                        isAlreadyLoved = !isAlreadyLoved!;
                                      });
                                    },
                                    hasBoxShadow: true,
                                    backColor: const Color(0xFFE4E6FB),
                                    textColor: Colors.black,
                                    icon: Icon(
                                      isAlreadyLoved!
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      size: 16,
                                      color: isAlreadyLoved!
                                          ? const Color(0xFFFF2358)
                                          : null,
                                    ),
                                    text: ' $cLove',
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: defaultPadding,
                                      vertical: defaultPadding / 2,
                                    ),
                                  );
                                }
                                return const SizedBox();
                              },
                            ),
                            const SizedBox(width: defaultPadding),
                            TextBadge(
                              hasBoxShadow: true,
                              backColor: const Color(0xFFE4E6FB),
                              textColor: Colors.black,
                              icon: const Icon(
                                Icons.arrow_downward,
                                size: 16,
                              ),
                              // widget.isDownloaded ? widget.collection.download + 1 : widget.collection.download
                              text:
                                  ' ${isDownloaded ? widget.collection.download + 1 : widget.collection.download}',
                              padding: const EdgeInsets.symmetric(
                                horizontal: defaultPadding,
                                vertical: defaultPadding / 2,
                              ),
                            ),
                            const Expanded(child: SizedBox()),
                            const Text(
                              'John Leo',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: defaultPadding * 2),
                        ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 200,
                            minHeight: 50,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              _showFullMessage(
                                  context, widget.collection.description);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(defaultPadding * 2),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFEBF0FD),
                                    Color(0xFFEEF4FE),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                    color: Colors.black.withOpacity(0.25),
                                  ),
                                ],
                              ),
                              child: Text(
                                widget.collection.description,
                                overflow: TextOverflow.fade,
                                maxLines: 9,
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 1.2,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: defaultPadding * 2),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 300,
                    child: Swiper(
                      itemBuilder: (BuildContext context, int index) {
                        return _buildSwiperItem(index);
                      },
                      itemCount: widget.collection.image.length,
                      viewportFraction: 0.6,
                      scale: 0.8,
                      loop: false,
                    ),
                  ),
                  const SizedBox(height: defaultPadding * 3),

                  // TODO: comment
                  StreamBuilder<QuerySnapshot>(
                    stream: commentService.data,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }
                      if (snapshot.hasData) {
                        final docs = snapshot.data!.docs;

                        return ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: 100,
                            maxHeight: size.height,
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(
                              left: defaultPadding * 2,
                              right: defaultPadding * 2,
                              bottom: defaultPadding * 2,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 4,
                                  offset: Offset(0, 4),
                                  color: Colors.black26,
                                )
                              ],
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFFEEF4FE),
                                  Color(0xFFF2FBFF),
                                ],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: defaultPadding,
                                horizontal: defaultPadding * 2,
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  if (index == 0) {
                                    return Column(
                                      children: [
                                        const Text(
                                          'Comment',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: defaultPadding),
                                        Container(
                                          height: 50,
                                          padding: const EdgeInsets.all(
                                              defaultPadding),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const CircleAvatar(
                                                backgroundColor: Colors.blue,
                                                radius: 12,
                                              ),
                                              const SizedBox(
                                                  width: defaultPadding),
                                              Expanded(
                                                child: SizedBox(
                                                  height: 24,
                                                  child: TextField(
                                                    controller: controller,
                                                    decoration: InputDecoration(
                                                      suffixIcon:
                                                          GestureDetector(
                                                        onTap: () {
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                          commentService
                                                              .comment(
                                                                  controller
                                                                      .text);
                                                        },
                                                        child: const Icon(
                                                          Icons.send,
                                                          color: Colors.blue,
                                                          size: 20,
                                                        ),
                                                      ),
                                                      suffixIconConstraints:
                                                          const BoxConstraints(
                                                        maxWidth: 20,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            gradient: const LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Color(0xFFF6FAFF),
                                                Color(0xFFF8FBFF),
                                              ],
                                            ),
                                            boxShadow: const [
                                              BoxShadow(
                                                blurRadius: 4,
                                                offset: Offset(0, 2),
                                                color: Colors.black26,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                            height: defaultPadding * 2),
                                      ],
                                    );
                                  }
                                  final comment = Comment.fromMap(
                                      docs[index - 1].data()
                                          as Map<String, dynamic>);
                                  return ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(minHeight: 50),
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          bottom: defaultPadding * 2),
                                      padding:
                                          const EdgeInsets.all(defaultPadding),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        gradient: const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xFFF6FAFF),
                                            Color(0xFFF8FBFF),
                                          ],
                                        ),
                                        boxShadow: const [
                                          BoxShadow(
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                            color: Colors.black26,
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            flex: 3,
                                            child: Text(
                                              comment.content,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 5,
                                            ),
                                          ),
                                          Flexible(
                                            flex: 2,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  formatter.format(
                                                      comment.commentDate),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    height: 1.3,
                                                    color: Colors.grey[500],
                                                  ),
                                                ),
                                                CircleAvatar(
                                                  radius: 12,
                                                  child: Image.network((comment
                                                                  .avatar !=
                                                              null &&
                                                          comment.avatar!
                                                              .isNotEmpty)
                                                      ? comment.avatar!
                                                      : 'https://github.com/hoangvu03081/Lingua-Eidetic/blob/main/assets/images/hacker.png?raw=true'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                itemCount: docs.length + 1,
                              ),
                            ),
                          ),
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showFullMessage(BuildContext context, String message) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Description'),
          titlePadding: const EdgeInsets.all(defaultPadding * 2),
          contentPadding: const EdgeInsets.only(
            bottom: defaultPadding * 2,
            left: defaultPadding * 2,
            right: defaultPadding * 2,
          ),
          content: SingleChildScrollView(
            child: Text(
              message,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSwiperItem(int index) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: defaultPadding * 2,
        horizontal: defaultPadding,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            blurRadius: 4,
            offset: Offset(0, 2),
            color: Colors.black12,
            spreadRadius: -12,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          widget.collection.image[index],
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
