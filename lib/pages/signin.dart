import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
              child: Column(
                children: [
                  const _Logo(),
                  const _FormContent(),
                  ElevatedButton(
                    child: const Text("Sign in with Google"),
                    onPressed: () async {
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
                      final googleUser = await googleSignIn.signIn();
                      final googleAuth = await googleUser!.authentication;
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
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
  final bool _isPasswordVisible = false;
  final bool _rememberMe = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      // constraints: const BoxConstraints(maxWidth: 380),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              // style: const TextStyle(color: Colors.white),

              validator: (value) {
                // add email validation
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
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
                labelText: 'Email',
                // hintText: 'Enter your email',
                prefixIcon: Icon(Icons.email_outlined),
                // border: OutlineInputBorder(),
                filled: true,
                fillColor: Color.fromARGB(255, 255, 250, 250),
              ),
            ),
            _gap(),

            /*TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }

                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  )),
            ),
            _gap(),
            CheckboxListTile(
              value: _rememberMe,
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _rememberMe = value;
                });
              },
              title: const Text('Remember me'),
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
              contentPadding: const EdgeInsets.all(0),
            ),
            _gap(),*/
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
                    /// do something
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
          ],
        ),
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
