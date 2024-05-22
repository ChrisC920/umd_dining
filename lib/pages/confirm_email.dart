import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:umd_dining/pages/home.dart';
import 'package:umd_dining/utils/constants.dart';

const bgcolor = Color.fromARGB(255, 255, 101, 101);

class ConfirmEmailPage extends StatefulWidget {
  const ConfirmEmailPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ConfirmEmailPageState();
}

class _ConfirmEmailPageState extends State<ConfirmEmailPage> {
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
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      }
    });
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
          "Confirm your account",
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
                // _Logo(),
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

  @override
  void initState() {
    super.initState();
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
                "Enter the confirmation code",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 27,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Row(children: [
              Flexible(
                child: Text(
                  "To confirm your account, enter the 6-digit code we sent to example@gmail.com.",
                ),
              ),
            ]),
          ),
          SizedBox(
            height: 90,
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a valid password';
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
                labelText: 'Confirmation code',
                prefixIcon: Icon(Icons.lock),
                filled: true,
                fillColor: Color.fromARGB(255, 255, 250, 250),
              ),
            ),
          ),
          const SizedBox(height: 6),
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
                  Navigator.of(context).pushNamed('/home');
                }
              },
            ),
          ),
          _gap(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 114, 159, 255),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Resend Code',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  Navigator.of(context).pushNamed('/home');
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
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
