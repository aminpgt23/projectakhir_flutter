import 'package:finalproject/home/transfer.dart';
import 'package:flutter/material.dart';
import 'package:qris/qris.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrisPage extends StatefulWidget {
  @override
  State<QrisPage> createState() => _QrisPageState();
}

bool flash_On = false;
bool fronCamp = false;
GlobalKey qrkey = GlobalKey();

class _QrisPageState extends State<QrisPage> {
  late QRViewController controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          QRView(
              key: qrkey,
              overlay: QrScannerOverlayShape(borderColor: Colors.white),
              onQRViewCreated: (QRViewController _controller) {
                this.controller = _controller;
                controller.scannedDataStream.listen((val) {
                  print("value");
                  if (mounted) {
                    controller.dispose();
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => TransferPage(),
                    //     ));
                  }
                });
              }),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: 60),
              child: Text(
                'scanner',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ButtonBar(
              alignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        flash_On = !flash_On;
                      });
                      controller.toggleFlash();
                    },
                    icon: Icon(
                      flash_On ? Icons.flash_on : Icons.flash_off,
                      color: Colors.white,
                    )),
                IconButton(
                    onPressed: () {
                      setState(() {
                        fronCamp = !fronCamp;
                      });
                      controller.flipCamera();
                    },
                    icon: Icon(
                      fronCamp ? Icons.camera_front : Icons.camera_rear,
                      color: Colors.white,
                    )),
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
