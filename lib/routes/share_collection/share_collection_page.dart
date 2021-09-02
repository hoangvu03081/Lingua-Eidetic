import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:lingua_eidetic/constants.dart';

class ShareCollectionPage extends StatelessWidget {
  const ShareCollectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        floatingActionButton: ElevatedButton(
          onPressed: () {},
          child: const Icon(Icons.arrow_right_alt),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(const Color(0xFF172853)),
            padding: MaterialStateProperty.all(
              const EdgeInsets.all(defaultPadding),
            ),
            shape:
                MaterialStateProperty.all<CircleBorder>(const CircleBorder()),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const Icon(
            Icons.chevron_left,
            color: Color(0xFF172853),
            size: 30,
          ),
          leadingWidth: 30,
          title: const Text(
            'Anatomy',
            style: TextStyle(
              color: Color(0xFF172853),
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Collection Name'),
                _buildTextField(hintMaxLines: 2, height: 50),
                const SizedBox(height: defaultPadding * 4),
                const Text('Collection Name'),
                _buildTextField(maxLines: 5, hintMaxLines: 5, height: 100),
                const SizedBox(height: defaultPadding * 2),
                const Text('Images'),
                const SizedBox(height: defaultPadding),
                DottedBorder(
                  color: const Color(0xFFDDDDDD),
                  strokeWidth: 3,
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(22),
                  dashPattern: const [12, 12],
                  child: GestureDetector(
                    onTap: () {},
                    child: SizedBox(
                      height: size.height * 1 / 5,
                      child: const Center(
                        child: Text(
                          '+ Add',
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

  Widget _buildTextField(
      {int? maxLines, required int hintMaxLines, required double height}) {
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
