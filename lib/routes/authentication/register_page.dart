import 'package:flutter/material.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/routes/authentication/authentication_page.dart';
import 'package:lingua_eidetic/routes/authentication/widgets/gradient_button_with_grey_color.dart';
import 'package:lingua_eidetic/routes/authentication/widgets/sign_in_text_field.dart';
import 'package:lingua_eidetic/utilities/validator.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _submitted = false;
  bool _enableSubmit = true;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final rPasswordController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final rPasswordFocusNode = FocusNode();
  final validator = EmailPasswordValidator('', '');

  late final Function() onEmailEditingComplete;
  late final Function() onPasswordEditingComplete;
  late final Function() onRPasswordEditingComplete;

  @override
  void initState() {
    super.initState();
    onEmailEditingComplete = () {
      passwordFocusNode.requestFocus();
    };
    onPasswordEditingComplete = () {
      rPasswordFocusNode.requestFocus();
    };
    onRPasswordEditingComplete = () {
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
    rPasswordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    rPasswordFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final errors = validator.errors;
    return AuthenticationPage(
      height: 900,
      title: 'Welcome,\n',
      subtitle: 'Register to learn now!',
      children: [
        SignInTextField(
          label: 'Email ID',
          controller: emailController,
          onEditingComplete: onEmailEditingComplete,
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
          onEditingComplete: onPasswordEditingComplete,
          errorText: (errors.passwordError != '' && _submitted)
              ? errors.passwordError
              : null,
          onChanged: (_) {
            validator.validatePassword(passwordController.text);
            setState(() {});
          },
        ),
        SizedBox(height: defaultPadding * 2),
        SignInTextField(
          label: 'Input your password again',
          controller: rPasswordController,
          onEditingComplete: onRPasswordEditingComplete,
          errorText: (_submitted &&
                  passwordController.text == rPasswordController.text)
              ? 'Password must be the same'
              : null,
          onChanged: (_) {
            setState(() {});
          },
        ),
        SizedBox(height: 40),
        GradientButtonWithGreyBorder(
          text: 'REGISTER',
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
