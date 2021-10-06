import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project1/animation.dart';
import 'package:project1/authentication/authservice.dart';
import 'package:project1/home.dart';
import 'package:project1/registraion.dart';

class Authentication extends StatefulWidget {
  //const Authentication({Key? key}) : super(key: key);
  static String id = 'authentication';

  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {



  TextEditingController _emailField = TextEditingController();
  TextEditingController _passwordField = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.indigo,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 1.3,
              child: TextFormField(
                style: TextStyle(color: Colors.white),
                controller: _emailField,
                decoration: InputDecoration(
                  hintText: "example@gmail.com",
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                  labelText: "Email",
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 35),
            Container(
              width: MediaQuery.of(context).size.width / 1.3,
              child: TextFormField(
                style: TextStyle(color: Colors.white),
                controller: _passwordField,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "password",
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                  labelText: "Password",
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 35),
            Container(
              width: MediaQuery.of(context).size.width / 2.8,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.amberAccent,
              ),
              child: MaterialButton(
                onPressed: () async {
                  bool? shouldNavigate = await register(_emailField.text, _passwordField.text);
                  if(shouldNavigate!){
                    //navigate
                    Navigator.push(context, BouncyPageRoute(widget: RegistrationForm()));
                    print('registerd successfully');
                  }
                },
                child: Text("Register"),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 35),
            Container(
              width: MediaQuery.of(context).size.width / 2.8,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.cyan,
              ),
              child: MaterialButton(
                  onPressed: () async {
                    bool? shouldNavigate = await signin(_emailField.text, _passwordField.text);
                    if(shouldNavigate!){
                      //navigate
                      Navigator.push(context, BouncyPageRoute(widget: Home_screen()));
                      print('logged in successfully');
                    }
                  },
                  child: Text("Login")),
            ),
          ],
        ),
      ),
    );
  }
}

