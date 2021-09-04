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
  String query = '';
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final communityService = CommunityService();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerScroll) {
              return [
                SliverAppBar(
                  floating: true,
                  titleSpacing: 0,
                  title: Container(
                    height: 100,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xB8CDCFFF),
                          Color(0xC9D3D8FF),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: defaultPadding,
                      horizontal: defaultPadding * 2,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: const Icon(
                                Icons.chevron_left,
                                color: Color(0xFF172853),
                                size: 30,
                              ),
                            ),
                            const Text(
                              'Community',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xFF637BDB),
                                fontSize: 20,
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
                                query = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  leading: const SizedBox(),
                  leadingWidth: 0,
                  toolbarHeight: 100,
                )
              ];
            },
            body: Container(
              decoration: const BoxDecoration(
                color: Colors.blue,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xC9D3D8FF),
                    Color(0xFFE8F7FF),
                  ],
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: defaultPadding * 2),
                child: Builder(
                  builder: (context) {
                    if (query == '') {
                      return FutureBuilder<List<SharedCollection>>(
                        future: communityService.getCollection(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Something went wrong');
                          }

                          if (snapshot.hasData) {
                            return ListView.builder(
                              itemBuilder: (context, index) {
                                return CCard(collection: snapshot.data![index]);
                              },
                              itemCount: snapshot.data!.length,
                            );
                          }

                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      );
                    }
                    return FutureBuilder<List<SharedCollection>>(
                      future: communityService.search(query),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }

                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemBuilder: (context, index) {
                              return CCard(collection: snapshot.data![index]);
                            },
                            itemCount: snapshot.data!.length,
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
      ),
    );
  }
}
