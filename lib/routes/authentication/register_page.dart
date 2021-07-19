import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/model/Auth.dart';
import 'package:lingua_eidetic/routes/authentication/authentication_page.dart';
import 'package:lingua_eidetic/routes/authentication/sign_in_page.dart';
import 'package:lingua_eidetic/routes/authentication/widgets/error_toast.dart';
import 'package:lingua_eidetic/routes/authentication/widgets/gradient_button_with_grey_color.dart';
import 'package:lingua_eidetic/routes/authentication/widgets/sign_in_text_field.dart';
import 'package:lingua_eidetic/routes/routes.dart';
import 'package:lingua_eidetic/utilities/validator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _submitted = false;

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

  String get _email => emailController.text;

  String get _password => passwordController.text;

  String get _rPassword => rPasswordController.text;

  late final FToast fToast;

  Future<void> _submit() async {
    if (validator.errors.emailError.isNotEmpty ||
        validator.errors.passwordError.isNotEmpty ||
        _password != _rPassword) return;
    try {
      setState(() => _submitted = true);
      final auth = Provider.of<Auth>(context);
      await auth.createUserWithEmailAndPassword(_email, _password);
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
      rPasswordController.clear();
    }
  }

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
    fToast = FToast();
    fToast.init(context);
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
    final bool isError =
        errors.emailError.isNotEmpty || errors.passwordError.isNotEmpty;
    final bool _enableSubmit = (!_submitted) || (_submitted && !isError);

    return AuthenticationPage(
      height: 1000,
      navigateTitle: 'Sign in now!',
      navigateSubtitle: 'Already have an account?\n',
      onPressNavigate: () {
        Navigator.of(context).pushReplacementNamed(RouteGenerator.SIGN_IN_PAGE);
      },
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
            validator.validateEmail(_email);
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
            validator.validatePassword(_password);
            setState(() {});
          },
        ),
        SizedBox(height: defaultPadding * 2),
        SignInTextField(
          label: 'Input your password again',
          controller: rPasswordController,
          onEditingComplete: onRPasswordEditingComplete,
          errorText: (_submitted &&
                  passwordController.text != rPasswordController.text)
              ? 'Password must be the same'
              : null,
          onChanged: (_) {
            setState(() {});
          },
        ),
        SizedBox(height: 40),
        GradientButtonWithGreyBorder(
          text: 'REGISTER',
          press: _enableSubmit ? _submit : null,
        ),
      ],
    );
  }
}
