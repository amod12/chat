import 'package:flutter/material.dart';
import 'reg.dart';
import 'login.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'text.dart';



class WelcomeScreen extends StatefulWidget {
  static const String id = 'wel';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/chatLogo.jpg'),
                    height: 60.0,
                  ),
                ),
                DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 30.0,
                    fontFamily: 'Agne',
                    color: Colors.black,
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText('Chat App'),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),

            RoundedButton(title: 'Log In', colour: Colors.lightBlueAccent,
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },),

            RoundedButton(
              title:'Register',
              colour: Colors.blueAccent,
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}


