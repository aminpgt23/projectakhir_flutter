import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/home/card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:finalproject/widget/theme.dart';

import '../widget/main.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');
    final norek = TextEditingController();
    User? user2 = FirebaseAuth.instance.currentUser;
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: softpurpleColor)),
            height: MediaQuery.of(context).size.height,
            // color: softblueColor,
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(user!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                child: Image.asset("assets/icon/profile.png"),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(snapshot.data!['nama'],
                                  style: TextStyle(
                                      color: softpurpleColor, fontSize: 30)),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: softpurpleColor)),
                                child: Text("+ Email",
                                    style: TextStyle(
                                        color: softpurpleColor, fontSize: 20)),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        actions: [
                                          ElevatedButton(
                                              onPressed: () {
                                                users.doc(user.uid).update(
                                                    {"no_rek": norek.text});
                                                Navigator.pop(context);
                                              },
                                              child: Text("submit"))
                                        ],
                                        content: TextField(
                                            controller: norek,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16)),
                                                label: Text("Input nomor"))),
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border:
                                          Border.all(color: softpurpleColor)),
                                  child: Text("+ nomor rekening",
                                      style: TextStyle(
                                          color: softpurpleColor,
                                          fontSize: 20)),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                  GestureDetector(
                    onTap: (() async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => HomeApk(),
                      ));
                    }),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Container(
                          width: 300,
                          height: 50,
                          child: Center(
                              child: Text(
                            'Logout?',
                            style: TextStyle(color: blueColor, fontSize: 20),
                          )),
                          decoration: BoxDecoration(
                            image: DecorationImage(

                                // alignment: Alignment.bottomCenter,
                                image: AssetImage("assets/icon/title.png"),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),
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
