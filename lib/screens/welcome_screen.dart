import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/rounded_button.dart';
class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}



class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{

  AnimationController controller; // Controller
  Animation animation; // Used for different curve animations

  @override void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this, // Ticker
      //upperBound: 100.0,
    );

    //animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);
    //controller.reverse(from: 1.0);

    controller.forward();
    //animation.addStatusListener((status) {
    //  print(status);
    //  if (status == AnimationStatus.completed) {
    //    controller.reverse(from:1.0);
    //  } else if (status == AnimationStatus.dismissed) {
    //    controller.forward();
    //  }
    //});

    animation = ColorTween(begin: Colors.deepPurple, end: Colors.blueAccent).animate(controller);

    controller.addListener(() {
      setState(() {

      });
      print(animation.value);
    });
  }

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value, //Colors.red.withOpacity(controller.value),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0, //animation.value*100,
                  ),
                ),
                TyperAnimatedTextKit(
                  //'${(controller.value).toInt()}%',
                  text: ['Flash Chat'],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            MyRoundedButton(color: Colors.lightBlueAccent, text: "Log In", onPressed: () { Navigator.pushNamed(context, LoginScreen.id); },),
            MyRoundedButton(color: Colors.blueAccent, text: "Register", onPressed: () { Navigator.pushNamed(context, RegistrationScreen.id); },),
          ],
        ),
      ),
    );
  }
}

