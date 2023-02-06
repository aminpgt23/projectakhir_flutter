import 'package:finalproject/screen/login.dart';
import 'package:finalproject/service/authservice.dart';
import 'package:finalproject/widget/main.dart';
import 'package:finalproject/widget/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
                "Register",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 3,
              ),
              Text("input your email & password to connect")
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
                      color: Color.fromARGB(255, 13, 80, 114),
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
                        return 'nama harus diisi';
                      }
                    },
                    controller: _nama,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 3,
                              color: Color.fromARGB(255, 195, 227, 242),
                              strokeAlign: StrokeAlign.center)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 3,
                            color: Color.fromARGB(255, 13, 80, 114),
                          ),
                          borderRadius: BorderRadius.circular(50.0)),
                      labelText: 'nama',
                    ),
                  ),
                ),
              ],
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
                            color: Color.fromARGB(255, 13, 80, 114),
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

  Widget authInput() {
    FirebaseAuth user = FirebaseAuth.instance;
    var userregis = user.currentUser;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return Container(
      padding: EdgeInsets.only(top: 20),
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
                  animType: AnimType.scale,
                  dialogType: DialogType.success,
                  // body: Center(
                  //   child: Text(
                  //     'If the body is specified, then title and description will be ignored, this allows to 											further customize the dialogue.',
                  //     style: TextStyle(fontStyle: FontStyle.italic),
                  //   ),
                  // ),
                  // title: 'This is Ignored',
                  // desc: 'This is also Ignored',
                  btnOkOnPress: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeApk(),
                        ));
                  },
                )..show();
                User? user = await authRegister.RegisterUser(
                    email: _email.text,
                    password: _password.text,
                    context: context);
                await users.doc(user!.uid).set({
                  "id": user.uid,
                  "nama": _nama.text,
                  "no_rek": "",
                  "balance": 0,
                });
                print(user.uid);
                if (_key.currentState!.validate()) {}
              },
              child: Center(child: const Text('Sign Up')),
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

  final _idGenerate = TextEditingController();
  final _nama = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  late bool _obscureText = true;
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: softpurpleColor,
        centerTitle: true,
        title: Text("E-wallet", textAlign: TextAlign.center),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            _authTitle(),
            authEmail(),
            authInput(),
            authDivider(),
            goggleSignIn(),
          ]),
        ),
      ),
    );
  }
}
