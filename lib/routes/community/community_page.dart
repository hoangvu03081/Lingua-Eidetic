import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/models/shared_collection.dart';
import 'package:lingua_eidetic/routes/community/widgets/c_card.dart';
import 'package:lingua_eidetic/services/community_service.dart';
import 'package:lingua_eidetic/widgets/search_box.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({Key? key}) : super(key: key);

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final communityService = CommunityService();
  Future<List<SharedCollection>>? future;
  @override
  void initState() {
    super.initState();
    future = communityService.getCollection();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.blue,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xB8CDCFFF),
                  Color(0xFFE8F7FF),
                ],
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: defaultPadding * 2),
              child: Builder(
                builder: (context) {
                  return FutureBuilder<List<SharedCollection>>(
                    future: future,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }

                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                  top: defaultPadding,
                                  bottom: defaultPadding * 2,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Icon(
                                            Icons.chevron_left,
                                            color:
                                                Theme.of(context).accentColor,
                                            size: 30,
                                          ),
                                        ),
                                        Text(
                                          'Community',
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5!
                                              .copyWith(
                                                color: const Color(0xFF637BDB),
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        const Icon(
                                          Icons.chevron_left,
                                          size: 30,
                                          color: Colors.transparent,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: defaultPadding),
                                    SizedBox(
                                      height: 40,
                                      child: SearchBox(
                                        filterFunc: (value) {
                                          setState(() {
                                            if (value == '') {
                                              future = communityService
                                                  .getCollection();
                                            } else {
                                              future = communityService
                                                  .search(value);
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return CCard(
                              collection: snapshot.data![index - 1],
                              setParentState: () {
                                Timer.periodic(
                                    const Duration(milliseconds: 400),
                                    (Timer t) {
                                  if (mounted) {
                                    setState(() {});
                                    t.cancel();
                                  }
                                });
                              },
                            );
                          },
                          itemCount: snapshot.data!.length + 1,
                        );
                      }

                      return const Center(child: CircularProgressIndicator());
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
