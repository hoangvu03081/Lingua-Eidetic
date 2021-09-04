import 'package:flutter/material.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/routes/authentication/widgets/auth_card.dart';

class AuthenticationPageBody extends StatelessWidget {
  const AuthenticationPageBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFEDF2F5),
        body: SizedBox(
          height: size.height,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: size.height * 0.4 - bottom,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(size.height * 0.04),
                      bottomRight: Radius.circular(size.height * 0.04),
                    ),
                  ),
                ),
              ),
              // background

              SingleChildScrollView(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double marginHorizontal = 0;
                    var padding = const EdgeInsets.only(
                      top: defaultPadding * 2.5,
                      bottom: defaultPadding * 2,
                      left: defaultPadding * 2,
                      right: defaultPadding * 2,
                    );

                    if (constraints.maxWidth >= 576 &&
                        constraints.maxWidth < 768) {
                      marginHorizontal = size.width * 0.05;
                      padding = const EdgeInsets.only(
                        top: defaultPadding * 4,
                        bottom: defaultPadding * 2,
                        left: defaultPadding * 2,
                        right: defaultPadding * 2,
                      );
                    } else if (constraints.maxWidth >= 768) {
                      marginHorizontal = size.width * 0.1;
                      padding = const EdgeInsets.only(
                        top: defaultPadding * 8,
                        bottom: defaultPadding * 6.4,
                        left: defaultPadding * 6.4,
                        right: defaultPadding * 6.4,
                      );
                    }
                    return Container(
                      margin: EdgeInsets.only(
                        top: size.height * 0.1,
                        bottom: defaultPadding * 2,
                        left: marginHorizontal,
                        right: marginHorizontal,
                      ),
                      child: AuthCard(
                        padding: padding,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
