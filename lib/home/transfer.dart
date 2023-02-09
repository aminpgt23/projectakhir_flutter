import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/home/card.dart';
// import 'package:finalproject/home/card.dart';
import 'package:finalproject/widget/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TransferPage extends StatefulWidget {
  TransferPage({super.key});

  @override
  State<TransferPage> createState() => _TransferPageState();
}

User? user1 = FirebaseAuth.instance.currentUser;
var _result;
TransferPage? result;

class _TransferPageState extends State<TransferPage> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    final balance = TextEditingController();
    final ket = TextEditingController();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');
    final key = GlobalKey();

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Text('Siapa yang ingin anda transfer?'),
              // Text(_result.toString() != _result ? _result : Text('data')),
            ],
          )),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(25),
          child: StreamBuilder<QuerySnapshot>(
            stream: users.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user!.uid)
                        .snapshots(),
                    builder: (context, snapshotdata) {
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot data = snapshot.data!.docs[index];

                            if (data.id == user1!.uid) {
                              return Container();
                            }
                            return GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                          actions: [
                                            ElevatedButton(
                                                onPressed: () async {
                                                  setState(() {
                                                    if (int.parse(
                                                            balance.text) >
                                                        snapshotdata
                                                            .data!['balance']) {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            content: Text(
                                                                'uang anda tidak mencukupi'),
                                                          );
                                                        },
                                                      );
                                                    } else {
                                                      AwesomeDialog(
                                                        context: context,
                                                        dialogType:
                                                            DialogType.success,
                                                        animType:
                                                            AnimType.rightSlide,
                                                        title: 'SUCCESS',
                                                        desc:
                                                            'lihat detailnya di history anda',
                                                        btnOkOnPress: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      )..show();
                                                      users
                                                          .doc(data.id)
                                                          .update({
                                                        "balance": FieldValue
                                                            .increment(
                                                                int.parse(
                                                                    balance
                                                                        .text)),
                                                      });
                                                      users
                                                          .doc(user1!.uid)
                                                          .update({
                                                        "balance": FieldValue
                                                            .increment(
                                                                -int.parse(
                                                                    balance
                                                                        .text)),
                                                      });
                                                      users
                                                          .doc(user.uid)
                                                          .collection('History')
                                                          .add({
                                                        "id": user.uid,
                                                        "nama": data['nama'],
                                                        "keterangan": ket.text,
                                                        "method": "transfer",
                                                        "cashe_out":
                                                            balance.text,
                                                      });
                                                      users
                                                          .doc(data.id)
                                                          .collection('History')
                                                          .add({
                                                        "id": user.uid,
                                                        "nama": snapshotdata
                                                            .data!['nama'],
                                                        "keterangan": ket.text,
                                                        "method": "topup",
                                                        "cashe_out":
                                                            balance.text,
                                                      });
                                                    }
                                                  });
                                                },
                                                child: Icon(Icons.send_sharp))
                                          ],
                                          icon:
                                              Icon(Icons.attach_money_outlined),
                                          scrollable: true,
                                          title: Column(
                                            children: [
                                              Center(
                                                  child: Text('transfer ke')),
                                              Text(data['nama']),
                                            ],
                                          ),
                                          content: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Form(
                                              child: Column(
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  TextFormField(
                                                    controller: balance,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration: InputDecoration(
                                                      enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              width: 3,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      195,
                                                                      227,
                                                                      242),
                                                              strokeAlign:
                                                                  StrokeAlign
                                                                      .center)),
                                                      labelText: 'jumlah uang',
                                                      icon: Icon(Icons
                                                          .money_off_csred_outlined),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  TextFormField(
                                                    controller: ket,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    decoration: InputDecoration(
                                                      enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              width: 3,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      195,
                                                                      227,
                                                                      242),
                                                              strokeAlign:
                                                                  StrokeAlign
                                                                      .center)),
                                                      labelText: 'keterangan',
                                                      icon: Icon(
                                                          Icons.description),
                                                    ),
                                                    // controller: qtyconts,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ));
                                    });
                              },
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Container(
                                  padding: EdgeInsets.all(35),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "assets/icon/cards1.png"),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: ListTile(
                                    title: CircleAvatar(
                                        radius: 30,
                                        child: Text(data['nama'] ?? "")),
                                    subtitle: Column(
                                      children: [
                                        Text(DateTime.now().toString()),
                                        Text(data['id'] ?? ""),
                                        Text(data['balance'].toString())
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    });
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
