import 'package:flutter/material.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/routes/authentication/models/anim_trigger.dart';
import 'package:lingua_eidetic/routes/authentication/widgets/auth_sign_in_form.dart';
import 'package:provider/provider.dart';

class AuthCard extends StatelessWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.only(
          top: defaultPadding * 8,
          bottom: defaultPadding * 4,
          left: defaultPadding * 4,
          right: defaultPadding * 4,
        ),
        child: ChangeNotifierProvider(
          create: (context) => AnimTriggerModel(trigger: true, duration: 800),
          child: AuthSignInForm(),
        ),
      ),
    );
  }
}
