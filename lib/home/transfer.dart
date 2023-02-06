import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/home/card.dart';

import 'package:finalproject/widget/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TransferPage extends StatefulWidget {
  TransferPage({super.key});

  @override
  State<TransferPage> createState() => _TransferPageState();
}

User? user1 = FirebaseAuth.instance.currentUser;

class _TransferPageState extends State<TransferPage> {
  @override
  Widget build(BuildContext context) {
    final balance = TextEditingController();
    final ket = TextEditingController();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Siapa yang ingin anda transfer?')),
      body: SafeArea(
        maintainBottomViewPadding: false,
        child: Container(
          padding: EdgeInsets.all(25),
          child: StreamBuilder<QuerySnapshot>(
            stream: users.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
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
                                              users.doc(data.id).update({
                                                "balance": FieldValue.increment(
                                                    int.parse(balance.text)),
                                              });
                                              users.doc(user1!.uid).update({
                                                "balance": FieldValue.increment(
                                                    -int.parse(balance.text)),
                                              });
                                              users
                                                  .doc(user!.uid)
                                                  .collection('History')
                                                  .add({
                                                "id": user!.uid,
                                                "nama": data['nama'],
                                                "keterangan": ket.text,
                                                "cashe_out": balance.text,
                                              });
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: Icon(Icons.send_sharp))
                                    ],
                                    icon: Icon(Icons.attach_money_outlined),
                                    scrollable: true,
                                    title: Column(
                                      children: [
                                        Center(child: Text('transfer ke')),
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
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 3,
                                                            color:
                                                                Color.fromARGB(
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
                                              keyboardType: TextInputType.text,
                                              decoration: InputDecoration(
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 3,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    195,
                                                                    227,
                                                                    242),
                                                            strokeAlign:
                                                                StrokeAlign
                                                                    .center)),
                                                labelText: 'keterangan',
                                                icon: Icon(Icons.description),
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
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/icon/cards1.png"),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListTile(
                              title: CircleAvatar(
                                  radius: 30, child: Text(data['nama'] ?? "")),
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
