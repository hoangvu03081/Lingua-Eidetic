import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/models/shared_collection.dart';
import 'package:lingua_eidetic/routes/homepage/widgets/text_badge.dart';
import 'package:lingua_eidetic/routes/share_collection/widgets/appbar.dart';
import 'package:lingua_eidetic/widgets/custom_header.dart';

class CommunityDownloadPage extends StatelessWidget {
  const CommunityDownloadPage({
    Key? key,
    required this.collection,
  }) : super(key: key);
  final SharedCollection collection;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
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
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: defaultPadding * 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomHeader(
                    leadingIcon: Icon(
                      Icons.chevron_left,
                      size: 30,
                    ),
                    title: 'title',
                    action: CircleAvatar(
                      backgroundColor: Color(0xFF172853),
                      child: Icon(
                        Icons.arrow_downward,
                        color: Colors.white,
                      ),
                      radius: 15,
                    ),
                  ),
                  Row(
                    children: [
                      TextBadge(
                        hasBoxShadow: true,
                        backColor: const Color(0xFFE4E6FB),
                        textColor: Colors.black,
                        icon: const Icon(
                          Icons.favorite_border,
                          size: 16,
                        ),
                        text: ' ${collection.love}',
                        padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding,
                          vertical: defaultPadding / 2,
                        ),
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
                        text: ' ${collection.download}',
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
                        _showFullMessage(context, collection.description);
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
                          collection.description,
                          overflow: TextOverflow.fade,
                          maxLines: 9,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: defaultPadding * 2),
                  SizedBox(
                    height: 300,
                    child: Swiper(
                      onIndexChanged: (index) {},
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                          children: [
                            _buildSwiperItem(index * 2),
                            const SizedBox(width: defaultPadding * 3),
                            if (collection.image.length > index * 2 + 1)
                              _buildSwiperItem(index * 2 + 1),
                          ],
                        );
                      },
                      itemCount: collection.image.length ~/ 2,
                      outer: true,
                      pagination: const SwiperPagination(
                        builder: DotSwiperPaginationBuilder(
                            color: Color(0xFFCDCDCD)),
                      ),
                      control: const SwiperControl(
                        iconPrevious: Icons.arrow_left,
                        iconNext: Icons.arrow_right,
                        size: 50,
                      ),
                    ),
                  )
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
          content: SingleChildScrollView(
            child: Text(
              message,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSwiperItem(int index) {
    return Expanded(
      child: Container(
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
            collection.image[index],
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
