import 'package:flutter/material.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/routes/authentication/authentication_page.dart';
import 'package:lingua_eidetic/routes/authentication/widgets/gradient_button_with_grey_color.dart';
import 'package:lingua_eidetic/routes/authentication/widgets/sign_in_text_field.dart';
import 'package:lingua_eidetic/utilities/validator.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _submitted = false;
  bool _enableSubmit = true;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final validator = EmailPasswordValidator('', '');

  late final Function() onEmailEditingComplete;
  late final Function() onPasswordEditingComplete;

  @override
  void initState() {
    super.initState();
    onEmailEditingComplete = () {
      passwordFocusNode.requestFocus();
    };
    onPasswordEditingComplete = () {
      setState(() {
        _submitted = true;
      });
    };
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final errors = validator.errors;
    return AuthenticationPage(
      height: 900,
      title: 'Welcome,\n',
      subtitle: 'Sign in to continue!',
      children: [
        SignInTextField(
          label: 'Email ID',
          controller: emailController,
          focusNode: emailFocusNode,
          onEditingComplete: onEmailEditingComplete,
          textInputAction: TextInputAction.next,
          errorText: (errors.emailError != '' && _submitted)
              ? errors.emailError
              : null,
          onChanged: (_) {
            validator.validateEmail(emailController.text);
            setState(() {});
          },
        ),
        SizedBox(height: defaultPadding * 2),
        SignInTextField(
          label: 'Password',
          controller: passwordController,
          focusNode: passwordFocusNode,
          onEditingComplete: onPasswordEditingComplete,
          errorText: (errors.passwordError != '' && _submitted)
              ? errors.passwordError
              : null,
          onChanged: (_) {
            validator.validatePassword(passwordController.text);
            setState(() {});
          },
        ),
        SizedBox(height: 40),
        GradientButtonWithGreyBorder(
          text: 'LOGIN',
          press: _enableSubmit
              ? () => setState(() {
                    _submitted = true;
                  })
              : null,
        ),
      ],
    );
  }
}
