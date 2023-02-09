import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:finalproject/screen/registrasi.dart';
import 'package:finalproject/service/authservice.dart';
import 'package:finalproject/widget/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../home/card.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Widget _authTitle() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            foregroundImage: AssetImage(
              "assets/icon/ft.png",
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Login",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 3,
              ),
              Text("input your email & password")
            ],
          ),
        ],
      ),
    );
  }

  Widget authEmail() {
    return Container(
      child: Form(
        key: _key,
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'email harus diisi';
                }
              },
              controller: _email,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 3,
                        color: Color.fromARGB(255, 195, 227, 242),
                        strokeAlign: StrokeAlign.center)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 3,
                      color: blackColor,
                    ),
                    borderRadius: BorderRadius.circular(50.0)),
                labelText: 'email',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Stack(
              children: [
                Container(
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'password harus diisi';
                      }
                    },
                    controller: _password,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 3,
                              color: Color.fromARGB(255, 195, 227, 242),
                              strokeAlign: StrokeAlign.center)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 3,
                            color: blackColor,
                          ),
                          borderRadius: BorderRadius.circular(50.0)),
                      labelText: 'password',
                    ),
                  ),
                ),
                Align(
                    heightFactor: 1.3,
                    // widthFactor: 11.0,
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(_obscureText
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget authForget() {
    return GestureDetector(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
            color: Colors.transparent,
            padding: EdgeInsets.fromLTRB(0, 20, 20, 20),
            child: Text(
              'Lupa password?',
              style: TextStyle(color: Colors.blue),
            )),
      ),
      onTap: (() {
        print('forget password?');
      }),
    );
  }

  Widget authInput() {
    return Container(
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color(0xff74D8FE),
                      Color(0xff74D8FE),
                      Color(0xff74D8FE),
                    ],
                  ),
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16.0),
                textStyle: TextStyle(fontSize: 15),
              ),
              onPressed: () async {
                AwesomeDialog(
                    context: context,
                    dialogType: DialogType.noHeader,
                    headerAnimationLoop: true,
                    body: Center(
                      child: CircularProgressIndicator(color: softblueColor),
                    ),
                    animType: AnimType.rightSlide,
                    title: "Loading....",
                    titleTextStyle: TextStyle(color: softblueTextStyle.color)
                    // btnOkOnPress: () {},
                    )
                  ..show();
                User? user = await authService.loginUsingEmailPassword(
                    email: _email.text,
                    password: _password.text,
                    context: context);
                print(user);
                if (user != null) {
                  print('masuk');
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ));
                }
                if (_key.currentState!.validate()) {}
              },
              child: Center(child: const Text('Sign In')),
            ),
          ],
        ),
      ),
    );
  }

  Widget authDivider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Row(children: [
        Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            'OR CONNECT WITH',
            style: TextStyle(fontSize: 12),
          ),
        ),
        Expanded(child: Divider()),
      ]),
    );
  }

  Widget goggleSignIn() {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color(0xff74D8FE),
                      Color(0xff74D8FE),
                      Color(0xff74D8FE)
                    ],
                  ),
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16.0),
                textStyle: TextStyle(fontSize: 15),
              ),
              onPressed: () {},
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.adb),
                  Text('Google'),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget titleRegister() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Dont have an acount yet?'),
          GestureDetector(
            child: Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Register',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            onTap: () {
              setState(() {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterPage(),
                    ));
              });
              print('object');
            },
          )
        ],
      ),
    );
  }

  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  late bool _obscureText = true;
  final _key = GlobalKey<FormState>();

  // Future<FirebaseApp> initializeFirebase() async {
  //   FirebaseApp firebaseApp = await Firebase.initializeApp();
  //   return firebaseApp;
  // }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          _authTitle(),
          authEmail(),
          authForget(),
          authInput(),
          authDivider(),
          goggleSignIn(),
          titleRegister(),
        ]),
      ),
    );
  }
}
