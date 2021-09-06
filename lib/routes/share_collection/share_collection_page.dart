import 'dart:io';

import 'package:card_swiper/card_swiper.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/routes/routes.dart';
import 'package:lingua_eidetic/routes/share_collection/models/image_model.dart';
import 'package:lingua_eidetic/routes/share_collection/widgets/appbar.dart';
import 'package:lingua_eidetic/services/upload_service.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class ShareCollectionPage extends StatefulWidget {
  const ShareCollectionPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _ShareCollectionPageState createState() => _ShareCollectionPageState();
}

class _ShareCollectionPageState extends State<ShareCollectionPage> {
  final List<ItemModel> imagePaths = [];
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final uploadService = UploadService();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: _scaffoldKey,
        floatingActionButton: CircleAvatar(
          backgroundColor: Theme.of(context).accentColor,
          child: IconButton(
            onPressed: () async {
              uploadService.uploadCollection(
                name: nameController.text,
                description: descriptionController.text,
                imagePath: imagePaths
                    .map<String>((ItemModel item) => item.path)
                    .toList(),
              );
              showDialog(
                  context: _scaffoldKey.currentContext!,
                  builder: (context) {
                    return AlertDialog(
                      contentPadding: EdgeInsets.zero,
                      insetPadding: EdgeInsets.symmetric(
                        vertical: (size.height - 100) / 2,
                        horizontal: (size.width - 100) / 2,
                      ),
                      content: const SizedBox(
                        width: 100,
                        height: 100,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  });
              await Future.delayed(const Duration(seconds: 1));
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_right_alt),
            color: Colors.white,
            padding: const EdgeInsets.all(defaultPadding),
          ),
        ),
        appBar: getCustomAppBar(context, widget.title),
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
                    height: size.height * 0.1,
                    controller: nameController,
                    hint: 'Please write your collection\'s name here'),
                const SizedBox(height: defaultPadding * 3),
                _buildHeader('Description'),
                _buildTextField(
                    hintMaxLines: 5,
                    height: size.height * 0.2,
                    controller: descriptionController,
                    hint:
                        'Please write your description for the collection here.'),
                const SizedBox(height: defaultPadding * 2),
                _buildHeader('Description images'),
                const SizedBox(height: defaultPadding),
                if (imagePaths.isNotEmpty)
                  SizedBox(
                    height: size.height * 0.7,
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
                            as List<ItemModel>?;
                        if (result != null) {
                          setState(() {
                            imagePaths.addAll(result);
                          });
                        }
                      },
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: size.height * 0.3),
                        child: Container(
                          width: size.width,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultPadding * 2),
                          child: Column(
                            children: [
                              Container(
                                child: const Icon(
                                  Icons.add,
                                  color: Color(0xFFCECDCD),
                                ),
                                padding:
                                    const EdgeInsets.all(defaultPadding / 2),
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
        style: TextStyle(
          color: Theme.of(context).accentColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextField({
    int? maxLines,
    required int hintMaxLines,
    required double height,
    required TextEditingController controller,
    required String hint,
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
          hintText: hint,
        ),
      ),
    );
  }
}
