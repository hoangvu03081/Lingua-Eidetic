import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lingua_eidetic/routes/routes.dart';
import 'package:lingua_eidetic/services/auth_service.dart';
import 'package:lingua_eidetic/widgets/custom_toast.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  bool _submitted = false;
  bool _isLoginForm = true;

  final authService = Auth();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [Color(0xFFB2CDFF), Color(0xFFC0E8FF)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            )),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Card(
                  elevation: 3,
                  child: Column(
                    children: [
                      SizedBox(height: size.height * 0.04),
                      SvgPicture.asset(
                        'assets/images/water_drop.svg',
                        color: const Color(0xFF8FA6FA),
                        height: 68,
                      ),
                      SizedBox(height: size.height * 0.04),
                      Text(_isLoginForm ? 'LOG IN' : 'REGISTER',
                          style: const TextStyle(
                              fontSize: 24, fontFamily: 'Montserrat')),
                      SizedBox(height: size.height * 0.08),
                      SizedBox(
                        width: size.width * 0.68,
                        child: Theme(
                          data: Theme.of(context).copyWith(
                              inputDecorationTheme: const InputDecorationTheme(
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF8FA6FA))),
                          )),
                          child: TextField(
                            controller: emailController,
                            focusNode: emailFocusNode,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                                prefixIcon:
                                    Icon(Icons.person, color: Colors.grey),
                                hintText: 'Email',
                                hintStyle: const TextStyle(fontFamily: 'Sen')),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      SizedBox(
                        width: size.width * 0.68,
                        child: Theme(
                          data: Theme.of(context).copyWith(
                              inputDecorationTheme: const InputDecorationTheme(
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF8FA6FA))),
                          )),
                          child: TextField(
                            controller: passwordController,
                            focusNode: passwordFocusNode,
                            obscureText: true,
                            decoration: const InputDecoration(
                                prefixIcon:
                                    Icon(Icons.lock, color: Colors.grey),
                                hintText: 'Password',
                                hintStyle: TextStyle(fontFamily: 'Sen')),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Text(''),
                      SizedBox(height: size.height * 0.02),
                      ElevatedButton(
                        onPressed: !_submitted ? () => _submit() : null,
                        child: _submitted
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(_isLoginForm ? 'Login' : 'Register',
                                style:
                                    TextStyle(fontFamily: 'Sen', fontSize: 20)),
                        style: ElevatedButton.styleFrom(
                            primary: const Color(0xFF8FA6FA),
                            minimumSize: const Size(109, 42),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(37))),
                      ),
                      SizedBox(height: size.height * 0.012),
                      TextButton(
                        onPressed: () => setState(() => toggleForm(context)),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: const TextStyle(
                                fontSize: 14.0, color: Color(0xFF8FA6FA)),
                            children: <TextSpan>[
                              TextSpan(
                                  text: _isLoginForm
                                      ? 'Don\'t have an account?\n'
                                      : 'Already have an account?\n'),
                              TextSpan(
                                  text: _isLoginForm
                                      ? 'Register now!'
                                      : 'Login now!',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF7490F3)))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: size.width * 0.16,
                              child: const Divider(
                                  thickness: 2, color: Color(0xFFB2CDFF))),
                          const SizedBox(width: 10),
                          const Text(
                            'or connect with',
                            style: TextStyle(
                                color: Color(0xFF7592FA), fontFamily: 'Roboto'),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                              width: size.width * 0.16,
                              child: const Divider(
                                  thickness: 2, color: Color(0xFFB2CDFF))),
                        ],
                      ),
                      SizedBox(height: size.height * 0.015),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: signInFacebook,
                              child: SvgPicture.asset('assets/images/fb.svg')),
                          SizedBox(width: size.width * 0.085),
                          TextButton(
                              onPressed: signInGoogle,
                              child: SvgPicture.asset('assets/images/gg.svg')),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    try {
      setState(() => _submitted = true);
      _isLoginForm
          ? await authService.signInWithMailAndPassword(
              emailController.text, passwordController.text)
          : await authService.createUserWithEmailAndPassword(
              emailController.text, passwordController.text);
    } on FirebaseAuthException catch (e) {
      //TODO: throw toast?
      print(e.message);
      setState(() => _submitted = false);
    }
  }

  Future<void> signInFacebook() async {
    try {
      setState(() => _submitted = true);
      await authService.signInWithFacebook();
    } catch (e) {
      print(e);
      setState(() => _submitted = false);
    }
  }

  Future<void> signInGoogle() async {
    try {
      setState(() => _submitted = true);
      await authService.signInWithGoogle();
    } catch (e) {
      print(e);
      setState(() => _submitted = false);
    }
  }

  void toggleForm(BuildContext context) {
    emailController.text = '';
    passwordController.text = '';
    setState(() => _isLoginForm = !_isLoginForm);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }
}
