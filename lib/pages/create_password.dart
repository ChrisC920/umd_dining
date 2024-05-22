import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:umd_dining/pages/home.dart';
import 'package:umd_dining/utils/constants.dart';

const bgcolor = Color.fromARGB(255, 255, 101, 101);

class CreatePasswordPage extends StatefulWidget {
  const CreatePasswordPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreatePasswordPageState();
}

class _CreatePasswordPageState extends State<CreatePasswordPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(210, 0, 0, 0),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.keyboard_arrow_left_rounded,
            size: 34,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Create an account",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          CustomPaint(
            size: size,
            painter: BackgroundGradient(),
          ),
          const Padding(
            padding: EdgeInsets.all(30.0),
            child: Column(
              children: [
                SizedBox(height: 140),
                _FormContent(),
              ],
            ),
          ),
        ],
      ),
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
  static bool passwordVisible = false;
  static bool passwordValid = false;
  static bool passwordHasEnoughChars = false;
  static bool passwordHasTooManyChars = false;
  static bool passwordContainsLowercase = false;
  static bool passwordContainsUppercase = false;
  static bool passwordContainsNumber = false;
  static bool passwordContainsSpace = false;

  @override
  void initState() {
    super.initState();
    passwordVisible = false;
    passwordValid = false;
    passwordHasEnoughChars = false;
    passwordHasTooManyChars = false;
    passwordContainsLowercase = false;
    passwordContainsUppercase = false;
    passwordContainsNumber = false;
    passwordContainsSpace = false;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text(
                "Create a password",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 27,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 90,
            child: TextFormField(
              obscureText: !passwordVisible,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a valid password';
                }

                passwordValid = RegExp(
                        r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?!.* )[a-zA-Z\d\w\W]{8,}$")
                    .hasMatch(value);
                passwordHasEnoughChars = RegExp(r"^.{8,}$").hasMatch(value);
                passwordHasTooManyChars =
                    !(RegExp(r"^.{0,20}$").hasMatch(value));
                passwordContainsLowercase =
                    RegExp(r"^(?=.*[a-z]$)").hasMatch(value);
                passwordContainsUppercase =
                    RegExp(r"^(?=.*[A-Z]$)").hasMatch(value);
                passwordContainsNumber = !(RegExp(r"\d").hasMatch(value));
                passwordContainsSpace = RegExp(r"^(?=.* )").hasMatch(value);

                if (passwordHasTooManyChars) {
                  return 'Password must be less than 20 characters';
                }
                if (passwordContainsSpace) {
                  return 'Password may not contain spaces';
                }
                if (!passwordValid) {
                  return 'Please enter a valid password';
                }

                return null;
              },
              onChanged: (value) {
                setState(
                  () {
                    passwordValid = RegExp(
                            r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?!.* )[a-zA-Z\d\w\W]{8,20}$")
                        .hasMatch(value);
                    passwordHasEnoughChars = RegExp(r"^.{8,}$").hasMatch(value);
                    passwordHasTooManyChars =
                        !(RegExp(r"^.{0,20}$").hasMatch(value));
                    passwordContainsLowercase =
                        RegExp(r"^(?=.*[a-z])").hasMatch(value);
                    passwordContainsUppercase =
                        RegExp(r"^(?=.*[A-Z])").hasMatch(value);
                    passwordContainsNumber = RegExp(r"\d").hasMatch(value);
                    passwordContainsSpace = RegExp(r"^(?!.* )").hasMatch(value);
                  },
                );
              },
              decoration: InputDecoration(
                border: const UnderlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(passwordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(
                      () {
                        passwordVisible = !passwordVisible;
                      },
                    );
                  },
                ),
                filled: true,
                fillColor: const Color.fromARGB(255, 255, 250, 250),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              passwordHasEnoughChars ? const Check() : const Cross(),
              const Text(
                "Must contain at least 8 characters",
              ),
            ],
          ),
          Row(
            children: [
              passwordContainsUppercase ? const Check() : const Cross(),
              const Text(
                "Must contain at least one uppercase letter",
              ),
            ],
          ),
          Row(
            children: [
              passwordContainsLowercase ? const Check() : const Cross(),
              const Text(
                "Must contain at least one lowercase letter",
              ),
            ],
          ),
          Row(
            children: [
              passwordContainsNumber ? const Check() : const Cross(),
              const Text(
                "Must contain at least one number",
              ),
            ],
          ),
          const SizedBox(height: 20),
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
                  _formKey.currentState?.reset();
                  Navigator.of(context).pushNamed('/confirm');
                }
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          _gap(),
        ],
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}

class Cross extends StatelessWidget {
  const Cross({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Icon(
        Icons.close,
        color: Colors.red,
      ),
    );
  }
}

class Check extends StatelessWidget {
  const Check({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Icon(
        Icons.check,
        color: Colors.green,
      ),
    );
  }
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
