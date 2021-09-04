import 'package:flutter/material.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/routes/community/widgets/c_card.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
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
                          Text(
                            'Community',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Color(0xFF637BDB),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.chevron_left,
                            color: Colors.transparent,
                          ),
                        ],
                      ),
                      const SizedBox(height: defaultPadding),
                      SizedBox(
                        height: 30,
                        child: TextField(
                          style: const TextStyle(fontSize: 13),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding:
                                const EdgeInsets.only(left: defaultPadding),
                          ),
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
          body: SingleChildScrollView(
            child: Container(
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
              padding:
                  const EdgeInsets.symmetric(horizontal: defaultPadding * 2),
              child: Column(
                children: const [
                  CCard(),
                  SizedBox(height: defaultPadding * 2),
                  CCard(),
                  SizedBox(height: defaultPadding * 2),
                  CCard(),
                  SizedBox(height: defaultPadding * 2),
                  CCard(),
                  SizedBox(height: defaultPadding * 2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
