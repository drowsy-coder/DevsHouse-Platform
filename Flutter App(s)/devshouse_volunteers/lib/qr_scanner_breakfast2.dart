import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QRScannerBreakfast2 extends StatefulWidget {
  const QRScannerBreakfast2({super.key});

  @override
  State<StatefulWidget> createState() => _QRScannerBreakfast2State();
}

class _QRScannerBreakfast2State extends State<QRScannerBreakfast2> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String message = 'Align the QR code within the frame to scan';

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();
      final Uri? uri = Uri.tryParse(scanData.code!);
      final String? uniqueId =
          uri!.pathSegments.isNotEmpty ? uri.pathSegments.last : null;
      if (uniqueId != null) {
        _checkAndUpdateUser(uniqueId);
      } else {
        setState(() {
          message = 'Invalid QR Code';
        });
        controller.resumeCamera();
      }
    });
  }

  Future<void> _checkAndUpdateUser(String uniqueId) async {
    final collectionRef = FirebaseFirestore.instance.collection('users');
    final querySnapshot = await collectionRef
        .where('unique_id', isEqualTo: uniqueId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first;
      if (doc['breakfast_2'] != true) {
        await doc.reference.update({'breakfast_2': true});
        _showDialog('Verified', Icons.check_circle_outline, Colors.green);
      } else {
        _showDialog(
            'Repeating Breakfast - Don\'t Allow!', Icons.cancel, Colors.red);
      }
    } else {
      _showDialog('No user found', Icons.warning, Colors.amber);
    }
    controller?.resumeCamera();
  }

  void _showDialog(String message, IconData icon, Color color) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.of(context).pop();
        });
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(icon, size: 100, color: color),
                Text(
                  message,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 22),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: Column(
        children: <Widget>[
          const Expanded(
            flex: 1,
            child: Center(
              child: Text(
                "Scan for Breakfast - 17th March",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: MediaQuery.of(context).size.width * 0.75,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
