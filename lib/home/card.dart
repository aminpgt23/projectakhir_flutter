import 'package:finalproject/home/balance.dart';
import 'package:finalproject/home/history.dart';
import 'package:finalproject/home/topup.dart';
import 'package:finalproject/home/Setting.dart';
import 'package:finalproject/home/transfer.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:finalproject/home/trimasaldo.dart';

import 'package:finalproject/screen/registrasi.dart';
import 'package:finalproject/widget/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../widget/theme.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final item = [
  "BRI",
  "BCA ",
  "CIMB NIAGA",
  'BRI LINK',
  'DANA',
  'E-WALLET',
  'MANDIRI',
  'BANK GANESA'
];

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    Future _openScanner(BuildContext context) async {
      // final _result;
      final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (c) => QrisPage(),
          ));
      // ignore: unnecessary_null_comparison
      var _result = result;
    }

    final balance = TextEditingController();
    final ket = TextEditingController();
    String nama = "";
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
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QRCLASS(),
                            ));
                      },
                      child: CircleAvatar(
                        backgroundImage: AssetImage("assets/icon/iconqris.png"),
                      ),
                    ),
                    // SizedBox(
                    //   width: 10,
                    // ),
                    SizedBox(
                      width: 10,
                    ),
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
                          onTap: () => _openScanner(context),
                          child: Column(
                            children: [
                              Image(
                                  height: 50,
                                  image: AssetImage("assets/icon/qris.png")),
                              Text('Terima'),
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
                                                users.doc(user.uid).update({
                                                  "balance":
                                                      FieldValue.increment(
                                                          int.parse(
                                                              balance.text))
                                                });
                                                users
                                                    .doc(user.uid)
                                                    .collection('History')
                                                    .add({
                                                  "id": user.uid,
                                                  "nama": nama,
                                                  "keterangan": ket.text,
                                                  "method": "topup",
                                                  "cashe_out": balance.text,
                                                });
                                              });
                                            },
                                            child: Text("Isi Saldo"))
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
                                                onChanged: (value) {
                                                  nama = value!;
                                                },

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
                                              SizedBox(
                                                height: 10,
                                              ),
                                              TextFormField(
                                                controller: ket,
                                                keyboardType:
                                                    TextInputType.text,
                                                decoration: InputDecoration(
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 3,
                                                        color: Colors.grey,
                                                        strokeAlign:
                                                            StrokeAlign.center),
                                                  ),
                                                  labelText: 'keterangan',
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
                              Text('Tambah'),
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SettingPage(),
                                ));
                          },
                          child: Column(
                            children: [
                              Image(
                                  height: 40,
                                  image: AssetImage("assets/icon/Setting.png")),
                              SizedBox(
                                height: 8,
                              ),
                              Text('setting account'),
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

class QRCLASS extends StatelessWidget {
  const QRCLASS({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 10),
        child: Center(
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        snapshot.data!['nama'],
                        style: TextStyle(
                          fontSize: 26,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      QrImage(
                          version: 6,
                          backgroundColor: Colors.white,
                          foregroundColor: Color.fromARGB(255, 3, 10, 23),
                          errorCorrectionLevel: QrErrorCorrectLevel.M,
                          padding: EdgeInsets.all(15),
                          size: 300,
                          data:
                              "https://i.pinimg.com/originals/46/a3/67/46a3674a9d9a33282accbb2559c87697.jpg"
                          //  user1!.uid.length.toString(),
                          ),
                    ]);
              } else {
                return Text("loading");
              }
            },
          ),
        ),
      ),
    );
  }
}
