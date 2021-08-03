import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lingua_eidetic/routes/routes.dart';
import 'package:lingua_eidetic/services/collection_service.dart';
import 'package:lingua_eidetic/widgets/collection_navbar.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionService collectionService = context.watch<CollectionService>();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(RouteGenerator.TEST),
              icon: Icon(Icons.tab))
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.red,
            height: size.height * 0.5,
            width: size.width,
            child: Center(
                child: Text(
              'welcome'.tr(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 44,
              ),
            )),
          ),
          ElevatedButton(
            onPressed: () => context.setLocale(Locale('vi')),
            child: Text('vi'),
          ),
          ElevatedButton(
            onPressed: () => context.setLocale(Locale('en')),
            child: Text('en'),
          ),
          ElevatedButton(
              onPressed: () {
                collectionService.current = '1';
                print(collectionService.current);
              },
              child: Text('Change value'))
        ],
      ),
    );
  }
}
