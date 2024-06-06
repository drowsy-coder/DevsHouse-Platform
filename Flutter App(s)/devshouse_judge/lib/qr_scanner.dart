import 'dart:io';
import 'package:devshouse_judge/team_details.dart';
import 'package:devshouse_judge/team_list.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<StatefulWidget> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (controller != null) {
      controller!.resumeCamera();
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    if (controller != null) {
      controller!.resumeCamera();
    }
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
      final teamName = uri?.pathSegments.last;

      if (teamName != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TeamDetailsScreen(teamId: teamName),
          ),
        ).then((value) {
          controller.resumeCamera();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        actions: [
          IconButton(
            icon: const Icon(Icons.group),
            onPressed: () {
              controller?.pauseCamera();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ManualTeamPage()),
              ).then((value) {
                controller?.resumeCamera();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
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
          const Expanded(
            flex: 1,
            child: Center(
              child: Text(
                'Align the QR code within the frame to scan',
                textAlign: TextAlign.center,
                style: TextStyle(
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
