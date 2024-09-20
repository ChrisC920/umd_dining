import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:umd_dining/pages/home.dart';
import 'package:umd_dining/utils/constants.dart';

const bgcolor = Color.fromARGB(255, 255, 101, 101);

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String? _userId;

  @override
  void initState() {
    super.initState();
    supabase.auth.onAuthStateChange.listen((data) {
      setState(() {
        _userId = data.session?.user.id;
      });
      final event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        Navigator.of(context).pushReplacementNamed('/start');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Stack(
          children: [
            CustomPaint(
              size: size,
              painter: BackgroundGradient(),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    const _Logo(),
                    const _FormContent(),
                    ElevatedButton(
                      onPressed: () async {
                        if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
                          return _nativeGoogleSignin();
                        }
                        await supabase.auth
                            .signInWithOAuth(OAuthProvider.google);
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: const Color.fromARGB(1, 255, 255, 255),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Image.asset(
                              'assets/images/google_logo.png',
                              height: 25,
                            ),
                          ),
                          const Text(
                            "Continue with Google",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    SignInWithAppleButton(
                      text: "Continue with Apple",
                      style: SignInWithAppleButtonStyle.black,
                      height: 50,
                      borderRadius: BorderRadius.circular(8),

                      // DOESNT WORK RN CUZ I DONT HAVE DEV ACCOUNT
                      onPressed: () async {
                        final credential =
                            await SignInWithApple.getAppleIDCredential(
                          scopes: [
                            AppleIDAuthorizationScopes.email,
                            AppleIDAuthorizationScopes.fullName,
                          ],
                        );

                        // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
                        // after they have been validated with Apple (see `Integration` section for more information on how to do this)
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _nativeGoogleSignin() async {
    /// Web Client ID that you registered with Google Cloud.
    const webClientId =
        '373883096692-t5smhtjli3uqa7etgteree38e1rshio0.apps.googleusercontent.com';

    /// iOS Client ID that you registered with Google Cloud.
    const iosClientId =
        '373883096692-h867plauslu0js5je5vr404sjq7n8bgi.apps.googleusercontent.com';

    // Google sign in on Android will work without providing the Android
    // Client ID registered on Google Cloud.

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;
        final accessToken = googleAuth.accessToken;
        final idToken = googleAuth.idToken;

        if (accessToken == null) {
          throw 'No Access Token found.';
        }
        if (idToken == null) {
          throw 'No ID Token found.';
        }

        await supabase.auth.signInWithIdToken(
          provider: OAuthProvider.google,
          idToken: idToken,
          accessToken: accessToken,
        );
      }
    } on Exception catch (e) {}
  }
}

class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 100,
        ),
        Image.asset(
          'assets/images/Logo.png',
          width: isSmallScreen ? 200 : 300,
        ),
        const SizedBox(
          height: 40,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Log in or sign up",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmallScreen ? 24 : 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

class _FormContent extends StatefulWidget {
  const _FormContent({Key? key}) : super(key: key);

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            validator: (value) {
              // add email validation
              if (value == null || value.isEmpty) {
                return 'Please enter a valid email';
              }

              bool emailValid = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(value);
              if (!emailValid) {
                return 'Please enter a valid email';
              }

              return null;
            },
            decoration: const InputDecoration(
              border: UnderlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
              labelText: 'Email Address',
              prefixIcon: Icon(Icons.email),
              filled: true,
              fillColor: Color.fromARGB(255, 255, 250, 250),
            ),
          ),
          _gap(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 42, 42, 42),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Continue',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  Navigator.of(context).pushNamed('/signup');
                }
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              _divider(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  "or",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),
                ),
              ),
              _divider(),
            ],
          ),
          _gap(),
        ],
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
  Widget _divider() => const Expanded(
        child: Divider(
          color: Colors.black54,
        ),
      );
}

class BackgroundGradient extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    const RadialGradient yellowGradient = RadialGradient(
      center: Alignment(3.9, -0.8),
      radius: 2.1,
      colors: <Color>[
        Color.fromARGB(200, 255, 255, 0),
        Color.fromARGB(0, 255, 255, 0),
      ],
      stops: <double>[0.4, 1.0],
    );
    const RadialGradient otherGradient = RadialGradient(
      center: Alignment(-3.5, 0.8),
      radius: 2.1,
      colors: <Color>[
        Color.fromARGB(200, 255, 101, 101),
        Color.fromARGB(0, 255, 101, 101)
      ],
      stops: <double>[0.4, 1.0],
    );
    canvas.drawRect(
      rect,
      Paint()..shader = yellowGradient.createShader(rect),
    );
    canvas.drawRect(
      rect,
      Paint()..shader = otherGradient.createShader(rect),
    );
  }

  @override
  bool shouldRepaint(BackgroundGradient oldDelegate) => false;
  @override
  bool shouldRebuildSemantics(BackgroundGradient oldDelegate) => false;
}
