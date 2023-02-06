import 'package:finalproject/home/balance.dart';
import 'package:finalproject/home/history.dart';
import 'package:finalproject/home/topup.dart';
import 'package:finalproject/home/transaksi.dart';
import 'package:finalproject/home/transfer.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:finalproject/screen/registrasi.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../widget/theme.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

User? user = FirebaseAuth.instance.currentUser;

final item = ["BRI", "BCA ", "CIMB NIAGA", 'PULSA'];

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final balance = TextEditingController();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Hello',
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
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
                              snapshot.data!['nama'],
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
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 2,
                        color: Colors.black,
                      )
                    ],
                    image: DecorationImage(
                        image: AssetImage("assets/icon/notifikasi.png"),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(25),
                  ),
                )
              ],
            ),
          ),
          Balance(
            norek: '****243',
            date: DateTime.now().toString(),
          ),
          SizedBox(
            width: 10,
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Column(
                            children: [
                              Image(
                                  height: 50,
                                  image: AssetImage("assets/icon/p5.png")),
                              Text('terima'),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      actions: [
                                        ElevatedButton(
                                            onPressed: () {
                                              AwesomeDialog(
                                                context: context,
                                                dialogType: DialogType.success,
                                                animType: AnimType.rightSlide,
                                                title: 'SUCCESS',
                                                desc:
                                                    'lihat detailnya di history anda!',
                                                // btnCancelOnPress: () {},
                                                btnOkOnPress: () {
                                                  Navigator.pop(context);
                                                },
                                              )..show();
                                              setState(() {
                                                users.doc(user!.uid).update({
                                                  "balance":
                                                      FieldValue.increment(
                                                          int.parse(
                                                              balance.text))
                                                });
                                              });
                                            },
                                            child: Text("isi saldo"))
                                      ],
                                      icon: Icon(Icons.money_off_csred_rounded),
                                      scrollable: true,
                                      title: Center(
                                          child: Text(
                                              'Silahkan mengisi saldo anda')),
                                      content: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Form(
                                          child: Column(
                                            children: <Widget>[
                                              SizedBox(
                                                height: 10,
                                              ),
                                              DropdownSearch<String>(
                                                popupProps: PopupProps.dialog(
                                                  showSelectedItems: true,
                                                ),
                                                items: item,
                                                dropdownDecoratorProps:
                                                    DropDownDecoratorProps(
                                                  dropdownSearchDecoration:
                                                      InputDecoration(
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16)),
                                                    labelText: "Menu mode",
                                                    hintText:
                                                        "country in menu mode",
                                                  ),
                                                ),
                                                onChanged: print,
                                                // selectedItem: "Brazil",
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              TextFormField(
                                                controller: balance,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              width: 3,
                                                              color:
                                                                  Colors.grey,
                                                              strokeAlign:
                                                                  StrokeAlign
                                                                      .center)),
                                                  labelText: 'jumlah uang',
                                                ),
                                                // controller: qtyconts,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ));
                                });
                          },
                          child: Column(
                            children: [
                              Image(
                                  height: 50,
                                  image: AssetImage("assets/icon/p4.png")),
                              Text('isi saldo'),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TransferPage(),
                                ));
                            print("object");
                          },
                          child: Column(
                            children: [
                              Image(
                                  height: 50,
                                  image: AssetImage("assets/icon/p3.png")),
                              Text("transfer"),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print('dompetku');
                          },
                          child: Column(
                            children: [
                              Image(
                                  height: 40,
                                  image: AssetImage("assets/icon/Wallet.png")),
                              SizedBox(
                                height: 8,
                              ),
                              Text('dompetku'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(13),
              decoration: BoxDecoration(
                  color: blueColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25))),
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "transaksi terakhir",
                        style: TextStyle(
                            fontSize: 18,
                            color: boltwhiteTextStyle.color,
                            fontWeight: FontWeight.bold),
                      ),
                      // Text(DateTime.utc().toString())
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    child: History(
                      imageUrl: "assets/icon/profile.png",
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
