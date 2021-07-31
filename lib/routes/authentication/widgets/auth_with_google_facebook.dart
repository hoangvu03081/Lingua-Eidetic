import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/services/auth_service.dart';
import 'package:lingua_eidetic/routes/authentication/widgets/error_toast.dart';
import 'package:lingua_eidetic/widgets/custom_overlay.dart';
import 'package:provider/provider.dart';

typedef SignInMethod = Future<User?> Function();

class AuthWithGoogleFacebook extends StatefulWidget {
  final bool enable;
  final VoidCallback onLogin;
  final VoidCallback onDoneLogin;

  const AuthWithGoogleFacebook({
    Key? key,
    required this.enable,
    required this.onLogin,
    required this.onDoneLogin,
  }) : super(key: key);

  @override
  _AuthWithGoogleFacebookState createState() => _AuthWithGoogleFacebookState();
}

class _AuthWithGoogleFacebookState extends State<AuthWithGoogleFacebook> {
  late final FToast fToast;

  Future<User?> _signIn(SignInMethod signInMethod) async {
    try {
      widget.onLogin();
      final user = await signInMethod();
      showOverlay(context);
      return user;
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
      widget.onDoneLogin();
    }
    return null;
  }

  Future<void> _signInWithGoogle() async {
    final auth = Provider.of<Auth>(context, listen: false);
    final user = await _signIn(auth.signInWithGoogle);
  }

  void _signInWithFacebook() async {
    final auth = Provider.of<Auth>(context, listen: false);
    final user = await _signIn(auth.signInWithFacebook);
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: widget.enable ? _signInWithFacebook : null,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF0C3A7E),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  width: 1,
                  color: Color(0xFF0C3A7E),
                ),
              ),
              padding: EdgeInsets.only(
                left: defaultPadding * 2,
                right: defaultPadding * 2,
                bottom: defaultPadding * 1.5,
                top: defaultPadding * 1.2,
              ),
              child: SvgPicture.asset(
                'assets/images/facebook-square-brands.svg',
                height: 25,
              ),
            ),
          ),
        ),
        SizedBox(width: defaultPadding * 3),
        Expanded(
          child: InkWell(
            onTap: widget.enable ? _signInWithGoogle : null,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  width: 1,
                  color: Color(0x66000000),
                ),
              ),
              padding: EdgeInsets.only(
                left: defaultPadding * 2,
                right: defaultPadding * 2,
                bottom: defaultPadding * 1.5,
                top: defaultPadding * 1.2,
              ),
              child: SvgPicture.asset(
                'assets/images/google.svg',
                height: 25,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
