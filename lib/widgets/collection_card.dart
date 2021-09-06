import 'package:flutter/material.dart';
import 'package:lingua_eidetic/constants.dart';

class CollectionCard extends StatelessWidget {
  const CollectionCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: defaultPadding * 2, horizontal: defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Anatomy',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
            ),
          ),
          Spacer(),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Color(0xFF0E1B3D),
                radius: 14.5,
                child: Text(
                  '1',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Text('available'),
              CircleAvatar(
                backgroundColor: Color(0xFF0E1B3D),
                radius: 14.5,
                child: Text(
                  '1',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Text('total'),
            ],
          ),
          SizedBox(height: defaultPadding),
        ],
      ),
      height: 120,
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.circular(9),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            offset: Offset(0, 4),
            color: Color(0x40000000),
          ),
        ],
      ),
    );
  }
}
