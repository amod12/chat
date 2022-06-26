import 'package:chat1/chatScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'text.dart';
import 'constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chatScreen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'reg';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String e = '';
  String p = '';
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ProgressHUD(
        child: Builder(
          builder: (context) => Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Flexible(
                    child: Hero(
                      tag: 'logo',
                      child: Container(
                        height: 200.0,
                        child: Image.asset('images/chatLogo.jpg'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 48.0,
                  ),
                  TextField(
                    style: const TextStyle(color: Colors.black54),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      e = value;
                    },
                    decoration: kInputDecoration.copyWith(
                        hintText: 'Enter your e-mail'),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    style: const TextStyle(color: Colors.pinkAccent),
                    obscureText: true,
                    onChanged: (value) {
                      p = value;
                    },
                    decoration: kInputDecoration.copyWith(
                        hintText: 'Enter your password'),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  RoundedButton(
                    title: 'Register',
                    colour: Colors.blueAccent,
                    onPressed: () async {
                      final progress = ProgressHUD.of(context);
                      progress?.show();
                      try {
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                          email: e,
                          password: p,
                        );
                        progress?.dismiss();
                        if (newUser != null) {
                          Navigator.pushNamed(context, ChatScreen.id);
                        }
                      } catch (e) {
                        print('e');
                      }
                    },
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
