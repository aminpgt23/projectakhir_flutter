import 'package:finalproject/widget/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Balance extends StatelessWidget {
  Balance({super.key, required this.norek, required this.date});

  final String norek;
  final String date;
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: softpurpleColorTextStyle.color,
          borderRadius: BorderRadius.circular(25),
        ),
        padding: EdgeInsets.all(20),
        height: 150,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Balance",
              style: blueTextStyle,
            ),
            SizedBox(
              height: 20,
            ),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Row(children: [
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      snapshot.data!['balance'].toString(),
                      style: TextStyle(
                        fontSize: 26,
                      ),
                    )
                  ]);
                } else {
                  return Text("loading");
                }
              },
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(norek,
                    style: TextStyle(fontSize: 10, color: blueTextStyle.color)),
                Text(
                  date,
                  style: TextStyle(fontSize: 10),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
