import 'package:flutter/material.dart';

import 'package:finalproject/widget/theme.dart';

class TransaksiItem extends StatelessWidget {
  TransaksiItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: blueColor),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(children: [
        Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(right: 10),
          child: SizedBox(
            width: 35,
            height: 35,
            child: Center(child: Text("awa")),
          ),
        ),
        Expanded(
            child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text("12/21",
                  style: TextStyle(color: blackColor, fontSize: 12)),
            ),
            Text(
              "200",
              style: TextStyle(color: blackColor, fontSize: 12),
            )
          ],
        )),
        Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text('transfer'),
            )
          ],
        )
      ]),
    );
  }
}
