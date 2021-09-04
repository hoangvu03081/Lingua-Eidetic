import 'dart:io';

import 'package:card_swiper/card_swiper.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/routes/routes.dart';
import 'package:lingua_eidetic/routes/share_collection/models/image_model.dart';
import 'package:lingua_eidetic/routes/share_collection/widgets/appbar.dart';
import 'package:lingua_eidetic/services/upload_service.dart';

class ShareCollectionPage extends StatefulWidget {
  const ShareCollectionPage({Key? key}) : super(key: key);

  @override
  _ShareCollectionPageState createState() => _ShareCollectionPageState();
}

class _ShareCollectionPageState extends State<ShareCollectionPage> {
  final headerStyle = const TextStyle(
    color: Color(0xFF172853),
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  final List<ItemModel> imagePaths = [];
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final uploadService = UploadService();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        floatingActionButton: CircleAvatar(
          backgroundColor: const Color(0xFF172853),
          child: IconButton(
            onPressed: () async {
              // TODO: Check Upload
              await uploadService.uploadCollection(
                name: nameController.text,
                description: descriptionController.text,
                imagePath: imagePaths
                    .map<String>((ItemModel item) => item.path)
                    .toList(),
              );
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_right_alt),
            color: Colors.white,
            padding: const EdgeInsets.all(defaultPadding),
          ),
        ),
        appBar: getCustomAppBar(context, 'Anatomy'),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader('Collection Name'),
                _buildTextField(
                  maxLines: 1,
                  hintMaxLines: 2,
                  height: 50,
                  controller: nameController,
                ),
                const SizedBox(height: defaultPadding * 3),
                _buildHeader('Description'),
                _buildTextField(
                  hintMaxLines: 5,
                  height: 100,
                  controller: descriptionController,
                ),
                const SizedBox(height: defaultPadding * 2),
                _buildHeader('Description images'),
                const SizedBox(height: defaultPadding),
                if (imagePaths.isNotEmpty)
                  SizedBox(
                    height: 300,
                    child: Swiper(
                      itemBuilder: (BuildContext context, int index) {
                        return Image.file(
                          File(imagePaths[index].path),
                          fit: BoxFit.cover,
                        );
                      },
                      itemCount: imagePaths.length,
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
                else
                  DottedBorder(
                    color: const Color(0xFFDDDDDD),
                    strokeWidth: 3,
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(22),
                    dashPattern: const [12, 12],
                    child: GestureDetector(
                      onTap: () async {
                        final result = await Navigator.of(context).pushNamed(
                                RouteGenerator.DESCRIPTION_IMAGES_PAGE)
                            as List<ItemModel>;
                        setState(() {
                          imagePaths.addAll(result);
                        });
                      },
                      child: Container(
                        width: size.width,
                        padding: const EdgeInsets.symmetric(
                            vertical: defaultPadding * 2),
                        child: Column(
                          children: [
                            Container(
                              child: const Icon(
                                Icons.add,
                                color: Color(0xFFCECDCD),
                              ),
                              padding: const EdgeInsets.all(defaultPadding / 2),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color(0xFFCECDCD), width: 2),
                                borderRadius: BorderRadius.circular(500),
                              ),
                            ),
                            const SizedBox(height: defaultPadding),
                            const Text(
                              'Select at least 2 description images',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFFCECDCD),
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        top: defaultPadding,
        left: defaultPadding,
        bottom: defaultPadding / 4,
      ),
      child: Text(
        title,
        style: headerStyle,
      ),
    );
  }

  Widget _buildTextField({
    int? maxLines,
    required int hintMaxLines,
    required double height,
    required TextEditingController controller,
  }) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F7F9),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            offset: const Offset(0, 4),
            color: Colors.black.withOpacity(0.25),
          ),
        ],
      ),
      child: TextField(
        maxLines: maxLines,
        controller: controller,
        decoration: InputDecoration(
          hintMaxLines: hintMaxLines,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(defaultPadding),
          hintText: 'Please write your collection\'s name here',
        ),
      ),
    );
  }
}
