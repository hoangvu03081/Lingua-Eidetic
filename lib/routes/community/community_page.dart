import 'package:flutter/material.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/routes/community/widgets/c_card.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({Key? key}) : super(key: key);

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final scrollController = ScrollController();
  double top = 0;
  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.offset <= 100) {
        setState(() {
          top = -scrollController.offset;
        });
      } else {
        setState(() {
          top = -100;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  height: size.height,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0x48CDCFFF),
                        Color(0xFFE8F7FF),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: top,
                left: 0,
                right: 0,
                child: Container(
                  height: 100,
                  padding: const EdgeInsets.symmetric(
                    vertical: defaultPadding,
                    horizontal: defaultPadding * 2,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.chevron_left,
                            size: 30,
                          ),
                          Container(
                            child: Text(
                              'Community',
                              style: TextStyle(
                                color: Color(0xFF637BDB),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_left,
                            color: Colors.transparent,
                          ),
                        ],
                      ),
                      SizedBox(height: defaultPadding),
                      SizedBox(
                        height: 30,
                        child: TextField(
                          style: TextStyle(fontSize: 13),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding:
                                EdgeInsets.only(left: defaultPadding),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 100 + top,
                left: 0,
                right: 0,
                bottom: 0,
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding * 2),
                    child: Column(
                      children: [
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
            ],
          ),
        ),
      ),
    );
  }
}
