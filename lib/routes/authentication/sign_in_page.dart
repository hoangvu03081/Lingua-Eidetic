import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/model/Auth.dart';
import 'package:lingua_eidetic/routes/authentication/authentication_page.dart';
import 'package:lingua_eidetic/routes/authentication/register_page.dart';
import 'package:lingua_eidetic/routes/authentication/widgets/error_toast.dart';
import 'package:lingua_eidetic/routes/authentication/widgets/gradient_button_with_grey_color.dart';
import 'package:lingua_eidetic/routes/authentication/widgets/sign_in_text_field.dart';
import 'package:lingua_eidetic/routes/routes.dart';
import 'package:lingua_eidetic/utilities/validator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _submitted = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final validator = EmailPasswordValidator('', '');

  String get _email => emailController.text;

  String get _password => passwordController.text;

  late final Function() onEmailEditingComplete;

  late final FToast fToast;

  Future<void> _submit() async {
    if (validator.errors.emailError.isNotEmpty ||
        validator.errors.passwordError.isNotEmpty) return;
    try {
      setState(() {
        _submitted = true;
      });
      final auth = Provider.of<Auth>(context, listen: false);
      await auth.signInWithMailAndPassword(_email, _password);
    } on FirebaseAuthException catch (e) {
      showToast(
        fToast,
        ErrorToast(errorText: e.code),
        5,
        left: 0,
        right: 0,
        bottom: defaultPadding * 4 + MediaQuery.of(context).viewInsets.bottom,
      );

      emailController.clear();
      passwordController.clear();
    } finally {}
  }

  @override
  void initState() {
    super.initState();
    onEmailEditingComplete = () {
      passwordFocusNode.requestFocus();
    };

    fToast = FToast();
    fToast.init(context);
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
    final bool isError =
        errors.emailError.isNotEmpty || errors.passwordError.isNotEmpty;
    final bool _enableSubmit = (!_submitted) || (_submitted && !isError);

    return AuthenticationPage(
      navigateTitle: "Don't have an account?",
      navigateSubtitle: "Register now!",
      onPressNavigate: () {
        Navigator.of(context).pushReplacementNamed(RouteGenerator.REGISTER_PAGE);
      },
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
            validator.validateEmail(_email);
            setState(() {});
          },
        ),
        SizedBox(height: defaultPadding * 2),
        SignInTextField(
          label: 'Password',
          controller: passwordController,
          focusNode: passwordFocusNode,
          onEditingComplete: _submit,
          errorText: (errors.passwordError != '' && _submitted)
              ? errors.passwordError
              : null,
          onChanged: (_) {
            validator.validatePassword(_password);
            setState(() {});
          },
        ),
        SizedBox(height: 40),
        GradientButtonWithGreyBorder(
          text: 'LOGIN',
          press: _enableSubmit ? _submit : null,
        ),
      ],
    );
  }
}
