import 'package:flutter/material.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/routes/authentication/models/anim_trigger.dart';
import 'package:lingua_eidetic/routes/authentication/widgets/auth_sign_in_form.dart';
import 'package:provider/provider.dart';

class AuthCard extends StatelessWidget {
  const AuthCard({
    Key? key,
    required this.padding,
  }) : super(key: key);
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: padding,
        child: ChangeNotifierProvider(
          create: (context) => AnimTriggerModel(trigger: true, duration: 800),
          child: const AuthSignInForm(),
        ),
      ),
    );
  }
}
