import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/routes/authentication/models/anim_trigger.dart';
import 'package:lingua_eidetic/routes/authentication/widgets/nav_button.dart';
import 'package:lingua_eidetic/routes/routes.dart';
import 'package:lingua_eidetic/services/auth_service.dart';
import 'package:lingua_eidetic/routes/authentication/widgets/auth_with_google_facebook.dart';
import 'package:lingua_eidetic/widgets/custom_toast.dart';
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

class AuthSignInForm extends StatefulWidget {
  const AuthSignInForm({
    Key? key,
  }) : super(key: key);

  @override
  _AuthSignInFormState createState() => _AuthSignInFormState();
}

class _AuthSignInFormState extends State<AuthSignInForm>
    with SingleTickerProviderStateMixin {
  late final fToast = FToast();

  late final anim = Provider.of<AnimTriggerModel>(context);
  String title = 'Welcome\n';
  String subtitle = 'Sign in to continue!';
  String navigateSubtitle = "Don't have an account?\n";
  String navigateTitle = 'Register now!';
  String buttonText = 'LOGIN';
  PageState pageState = PageState.sign_in;

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

  bool _loading = false;

  String get _email => emailController.text;

  String get _password => passwordController.text;

  String get _rPassword => rPasswordController.text;

  Future<void> _submit() async {
    setState(() => _submitted = true);
    if (validator.errors.emailError.isNotEmpty ||
        validator.errors.passwordError.isNotEmpty ||
        (pageState == PageState.register && _password != _rPassword)) return;
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      setState(() {
        _loading = true;
      });
      if (pageState == PageState.register) {
        rPasswordFocusNode.unfocus();
        await auth.createUserWithEmailAndPassword(_email, _password);
        Navigator.of(context).pushReplacementNamed(RouteGenerator.LANDING_PAGE);
      } else {
        passwordFocusNode.unfocus();
        await auth.signInWithMailAndPassword(_email, _password);
      }
    } on FirebaseAuthException catch (e) {
      showToast(
        fToast: fToast,
        child: ErrorToast(errorText: e.code),
        seconds: 5,
        left: 0,
        right: 0,
        bottom: defaultPadding * 4 + MediaQuery.of(context).viewInsets.bottom,
      );
      clearText();
      validator.validateEmail('');
      validator.validatePassword('');
      setState(() {
        _loading = false;
        _submitted = false;
      });
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

    emailController.addListener(() {
      validator.validateEmail(_email);
      setState(() {
        /// email
        _enableSubmit = (!_submitted) || (_submitted && !isError());
      });
    });

    passwordController.addListener(() {
      validator.validatePassword(_password);
      setState(() {
        /// password
        _enableSubmit = (!_submitted) || (_submitted && !isError());
      });
    });

    rPasswordController.addListener(() {
      setState(() {
        /// rpassword
        _enableSubmit = (!_submitted) || (_submitted && !isError());
      });
    });
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

  bool _enableSubmit = true;

  bool isError() {
    return validator.errors.emailError.isNotEmpty ||
        validator.errors.passwordError.isNotEmpty ||
        (pageState == PageState.register && _password != _rPassword);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final errors = validator.errors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WelcomeText(
          title: title,
          subtitle: subtitle,
        ),
        const SizedBox(height: defaultPadding * 2),
        SignInTextField(
          label: 'Email ID',
          controller: emailController,
          onEditingComplete: onEmailEditingComplete,
          textInputAction: TextInputAction.next,
          focusNode: emailFocusNode,
          errorText: (errors.emailError.isNotEmpty && _submitted)
              ? errors.emailError
              : null,
        ),
        const SizedBox(height: defaultPadding),
        SignInTextField(
          label: 'Password',
          obscureText: true,
          controller: passwordController,
          focusNode: passwordFocusNode,
          textInputAction: pageState == PageState.sign_in
              ? TextInputAction.done
              : TextInputAction.next,
          onEditingComplete: onPasswordEditingComplete,
          errorText: (errors.passwordError.isNotEmpty && _submitted)
              ? errors.passwordError
              : null,
        ),
        const SizedBox(height: defaultPadding * 1.5),
        AnimatedContainer(
          duration: Duration(milliseconds: anim.duration),
          curve: Curves.ease,
          height: removeRPassword ? 170 : 230,
          child: Stack(
            fit: StackFit.loose,
            children: [
              AnimatedPositioned(
                top: removeRPassword ? -63 : 0,
                left: 0,
                right: 0,
                duration: Duration(milliseconds: anim.duration),
                curve: Curves.ease,
                child: Column(
                  children: [
                    AnimatedOpacity(
                      opacity: removeRPassword ? 0 : 1,
                      duration: Duration(milliseconds: anim.duration),
                      curve: Curves.ease,
                      child: SignInTextField(
                        obscureText: true,
                        label: 'Input your password again',
                        controller: rPasswordController,
                        focusNode: rPasswordFocusNode,
                        textInputAction: TextInputAction.done,
                        onEditingComplete: onRPasswordEditingComplete,
                        errorText: (_submitted &&
                                pageState == PageState.register &&
                                passwordController.text !=
                                    rPasswordController.text)
                            ? 'Password must be the same'
                            : null,
                      ),
                    ),
                    const SizedBox(height: defaultPadding * 2),
                    GradientButtonWithGreyBorder(
                      text: buttonText,
                      loading: _loading,
                      press: _enableSubmit
                          ? () {
                              /// button login
                              setState(() {
                                _enableSubmit = !isError();
                              });
                              _submit();
                            }
                          : null,
                    ),
                    const SizedBox(height: defaultPadding),
                    AuthWithGoogleFacebook(
                        enable: !_loading,
                        onLogin: () {
                          setState(() {
                            _loading = true;
                          });
                        },
                        onDoneLogin: () {
                          setState(() {
                            _loading = false;
                          });
                        }),
                    Container(
                      margin: const EdgeInsets.only(top: defaultPadding),
                      width: double.infinity,
                      child: NavButton(
                        navigateTitle: navigateTitle,
                        onPressNavigate: onPressNavigate,
                        navigateSubtitle: navigateSubtitle,
                        transition: !_loading,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void focusRPassword() {
    if (validator.errors.passwordError.isEmpty) {
      rPasswordFocusNode.requestFocus();
    }
  }

  void onPressNavigate() {
    setState(() {
      _submitted = false;
      _enableSubmit = true;
      _loading = true;

      /// if current page state is sign_in => prepare to change to register
      if (pageState == PageState.sign_in) {
        pageState = PageState.register;
        onPasswordEditingComplete = focusRPassword;
        removeRPassword = false;
        anim.setTrigger(removeRPassword);
        Future.delayed(Duration(milliseconds: anim.duration), () {
          setState(() {
            _loading = false;
          });
        });
        title = 'Welcome\n';
        subtitle = 'Register to learn now!';
        buttonText = 'REGISTER';
        navigateTitle = 'Sign in now!';
        navigateSubtitle = 'Already have an account?\n';
        clearFocus();
      } else {
        onPasswordEditingComplete = _submit;
        pageState = PageState.sign_in;
        rPasswordController.clear();
        title = 'Welcome\n';
        subtitle = 'Sign in to continue!';
        buttonText = 'LOGIN';
        navigateTitle = 'Register now!';
        navigateSubtitle = 'Don\'t have an account?\n';
        removeRPassword = true;
        anim.setTrigger(removeRPassword);
        Future.delayed(Duration(milliseconds: anim.duration), () {
          setState(() {
            _loading = false;
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
