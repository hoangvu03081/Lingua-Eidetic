import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/models/memory_card.dart';
import 'package:lingua_eidetic/routes/collection_page/widgets/caption_textfield.dart';
import 'package:lingua_eidetic/routes/collection_page/widgets/title_header.dart';
import 'package:lingua_eidetic/routes/share_collection/widgets/appbar.dart';

class EditingCollectionPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final availIn = card.available.difference(DateTime.now());
    final hours = availIn.inHours;
    final minutes = availIn.inMinutes;

    return Scaffold(
      appBar: getCustomAppBar(context, 'Collection name'),
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
                height: 300,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Image.file(
                    File(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding * 2),
              TitleHeader(
                title: hours < 0
                    ? 'Available'
                    : hours == 0
                        ? minutes < 0
                            ? 'Available'
                            : 'Cooldown: $minutes'
                        : 'Cooldown: $hours',
                backColor: const Color(0xFF2A3387),
              ),
              const SizedBox(height: defaultPadding * 2),
              const Padding(
                padding: EdgeInsets.only(left: defaultPadding),
                child: Text(
                  'Captions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172853),
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),
              const CaptionTextField(),
            ],
          ),
        ),
      ),
    );
  }
}
