import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/model/Auth.dart';
import 'package:lingua_eidetic/routes/authentication/widgets/auth_with_google_facebook.dart';
import 'package:lingua_eidetic/routes/authentication/widgets/error_toast.dart';
import 'package:lingua_eidetic/routes/authentication/widgets/gradient_button_with_grey_color.dart';
import 'package:lingua_eidetic/routes/authentication/widgets/sign_in_text_field.dart';
import 'package:lingua_eidetic/routes/authentication/widgets/welcome_text.dart';
import 'package:lingua_eidetic/utilities/validator.dart';
import 'package:provider/provider.dart';

enum PageState {
  sign_in,
  register,
}

/// 1. not submit
///   a) sign in -> register
///     * not written => not written
///     * written => written
///   b) register -> sign in
///     * clear rPasswordController
/// 2. submitted but error
///   a) sign in -> register
///     * keep errors && animate text field
///   b) register -> sign in
///     * keep errors && animate remove text field
///     * clear rPasswordController
/// 3. submit success -> home

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({
    Key? key,
  }) : super(key: key);

  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage>
    with SingleTickerProviderStateMixin {
  String title = 'Welcome\n';
  String subtitle = 'Sign in to continue!';
  double height = 900;
  String navigateSubtitle = "Don't have an account?\n";
  String navigateTitle = 'Register now!';
  String buttonText = 'LOGIN';
  PageState pageState = PageState.sign_in;
  double offset = 0;

  bool _submitted = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final rPasswordController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final rPasswordFocusNode = FocusNode();
  final validator = EmailPasswordValidator('', '');

  late final Function() onEmailEditingComplete;
  late Function() onPasswordEditingComplete;
  late final Function() onRPasswordEditingComplete;

  bool removeRPassword = true;

  double _opacity = 0;

  bool _transition = true;

  String get _email => emailController.text;

  String get _password => passwordController.text;

  String get _rPassword => rPasswordController.text;

  late final FToast fToast;

  Future<void> _submit() async {
    setState(() => _submitted = true);
    if (validator.errors.emailError.isNotEmpty ||
        validator.errors.passwordError.isNotEmpty ||
        (pageState == PageState.register && _password != _rPassword)) return;
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      if (pageState == PageState.register) {
        rPasswordFocusNode.unfocus();
        await auth.createUserWithEmailAndPassword(_email, _password);
      } else {
        passwordFocusNode.unfocus();
        await auth.signInWithMailAndPassword(_email, _password);
      }
    } on FirebaseAuthException catch (e) {
      showToast(
        fToast,
        ErrorToast(errorText: e.code),
        5,
        left: 0,
        right: 0,
        bottom: defaultPadding * 4 + MediaQuery.of(context).viewInsets.bottom,
      );
    } finally {
      validator.validateEmail('');
      validator.validatePassword('');
      clearText();
    }
  }

  @override
  void initState() {
    super.initState();
    onEmailEditingComplete = () {
      if (validator.errors.emailError.isEmpty) passwordFocusNode.requestFocus();
    };
    onPasswordEditingComplete = _submit;
    onRPasswordEditingComplete = _submit;
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
    final size = MediaQuery.of(context).size;
    final errors = validator.errors;
    final bool isError = errors.emailError.isNotEmpty ||
        errors.passwordError.isNotEmpty ||
        (pageState == PageState.register && _password != _rPassword);
    final bool _enableSubmit = (!_submitted) || (_submitted && !isError);
    return Scaffold(
      backgroundColor: Color(0xFFE5E5E5),
      // singleChildScrollView
      // SizedBox height height
      body: Stack(
        children: [
          // background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Image.asset(
                'assets/images/sign_in_page.png',
                width: size.width,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // background

          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(
                  top: size.height * 0.1, bottom: defaultPadding * 2),
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: size.width * 0.9,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: defaultPadding * 8,
                        bottom: defaultPadding * 4,
                        left: defaultPadding * 4,
                        right: defaultPadding * 4,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WelcomeText(
                            title: title,
                            subtitle: subtitle,
                          ),
                          SizedBox(height: 60),

                          /// children
                          SignInTextField(
                            label: 'Email ID',
                            controller: emailController,
                            onEditingComplete: onEmailEditingComplete,
                            textInputAction: TextInputAction.next,
                            focusNode: emailFocusNode,
                            errorText:
                                (errors.emailError.isNotEmpty && _submitted)
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
                            obscureText: true,
                            controller: passwordController,
                            focusNode: passwordFocusNode,
                            textInputAction: pageState == PageState.sign_in
                                ? TextInputAction.done
                                : TextInputAction.next,
                            onEditingComplete: onPasswordEditingComplete,
                            errorText:
                                (errors.passwordError.isNotEmpty && _submitted)
                                    ? errors.passwordError
                                    : null,
                            onChanged: (_) {
                              validator.validatePassword(_password);
                              setState(() {});
                            },
                          ),
                          SizedBox(height: defaultPadding * 2),

                          if (!removeRPassword)
                            TweenAnimationBuilder(
                              tween: Tween<double>(
                                begin: -35,
                                end: offset,
                              ),
                              curve: Curves.easeInOut,
                              duration: Duration(milliseconds: 750),
                              child: SignInTextField(
                                obscureText: true,
                                label: 'Input your password again',
                                controller: rPasswordController,
                                focusNode: rPasswordFocusNode,
                                textInputAction: TextInputAction.done,
                                onEditingComplete: onRPasswordEditingComplete,
                                errorText: (_submitted &&
                                        passwordController.text !=
                                            rPasswordController.text)
                                    ? 'Password must be the same'
                                    : null,
                                onChanged: (_) {
                                  setState(() {});
                                },
                              ),
                              builder: (_, double offsetY, child) {
                                return Transform(
                                  transform:
                                      Matrix4.translationValues(0, offsetY, 0),
                                  child: AnimatedOpacity(
                                    duration: Duration(milliseconds: 325),
                                    opacity: _opacity,
                                    curve: Curves.easeIn,
                                    child: child,
                                  ),
                                );
                              },
                            ),

                          ///
                          if (!removeRPassword)
                            SizedBox(height: defaultPadding * 2),

                          GradientButtonWithGreyBorder(
                            text: buttonText,
                            press: _enableSubmit ? _submit : null,
                          ),
                          SizedBox(height: defaultPadding * 2),

                          AuthWithGoogleFacebook(),
                          Container(
                            margin: EdgeInsets.only(top: defaultPadding * 2),
                            width: double.infinity,
                            child: TextButton(
                              onPressed: _transition ? onPressNavigate : null,
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: GoogleFonts.openSans(
                                    textStyle: TextStyle(color: Colors.black54),
                                  ),
                                  children: [
                                    TextSpan(text: navigateSubtitle),
                                    TextSpan(
                                      text: navigateTitle,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onPressNavigate() {
    setState(() {
      _transition = false;

      /// if current page state is sign_in => prepare to change to register
      if (pageState == PageState.sign_in) {
        _opacity = 1;
        pageState = PageState.register;
        onPasswordEditingComplete = () {
          if (validator.errors.passwordError.isEmpty) {
            rPasswordFocusNode.requestFocus();
          }
        };
        offset = 0;
        removeRPassword = false;
        Future.delayed(Duration(milliseconds: 500), () {
          setState(() {
            _transition = true;
          });
        });
        title = 'Welcome\n';
        subtitle = 'Register to learn now!';
        buttonText = 'REGISTER';
        navigateTitle = 'Sign in now!';
        navigateSubtitle = 'Already have an account?\n';
        clearFocus();
      } else {
        _opacity = 0;
        offset = -35;
        onPasswordEditingComplete = _submit;
        pageState = PageState.sign_in;
        rPasswordController.clear();
        title = 'Welcome\n';
        subtitle = 'Sign in to continue!';
        buttonText = 'LOGIN';
        navigateTitle = 'Register now!';
        navigateSubtitle = 'Don\'t have an account?\n';
        Future.delayed(Duration(milliseconds: 500), () {
          setState(() {
            removeRPassword = true;
            _transition = true;
          });
        });
        clearFocus();
      }
    });
  }

  void clearFocus() {
    emailFocusNode.unfocus();
    passwordFocusNode.unfocus();
    rPasswordFocusNode.unfocus();
  }

  void clearText() {
    emailController.clear();
    passwordController.clear();
    rPasswordController.clear();
  }
}
