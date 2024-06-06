import 'dart:async';
import 'dart:ui' as ui;
import 'package:devshouse/screens/map/map_alert.dart';
import 'package:devshouse/screens/map/video_display_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class VITMap extends StatefulWidget {
  const VITMap({super.key});

  @override
  State<VITMap> createState() => _VITMapState();
}

class _VITMapState extends State<VITMap> {
  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(12.83966720164967, 80.15526799194957),
    zoom: 17,
  );

  List<String> locationName = [
    "MG",
    "Main Gate",
    "Gazebo",
    "North Square",
    "V-Mart",
    "Dominos",
  ];

  List<String> descriptions = [
    "The heart of DevsHouse '24, where innovation meets creativity. A venue buzzing with ideas and technology.",
    "The grand entrance to VIT Chennai, where your journey into a world of knowledge and discovery begins.",
    "A cozy nook for quick bites and refreshing drinks. Perfect for those moments when you need a little pick-me-up.",
    "The go-to spot for tea aficionados and coffee lovers alike. Enjoy a variety of light snacks in a relaxed atmosphere.",
    "Your convenience store on campus. From packaged snacks to essential drinks, find everything you need to keep you going.",
    "The ultimate destination for pizza lovers. Indulge in a slice of heaven and enjoy your favorite pizzas made to perfection.",
  ];

  List<String> infoImages = [
    "assets/IMG_20230407_140449349 Medium.jpeg",
    "assets/Purchase-Office.jpg",
    "assets/1*hHqEK7SKVFqHYyIUw6Y74A.jpg",
    "assets/NorthSquare-2.jpg",
    "assets/AllMart (1) Medium.jpeg",
    "assets/rb3b-Dominos-Pizza-VIT-exterior.jpg",
  ];

  List<String> marker = [
    "assets/devshouse-black-logo.png",
    "assets/Unknown-3.jpg",
    "assets/5787016.png",
    "assets/4300605.png",
    "assets/shopping-cart-114.png",
    "assets/Domino's_pizza_logo.svg.png",
  ];

  final List<Marker> _markers = <Marker>[];

  final List<LatLng> _latLang = <LatLng>[
    const LatLng(12.839719504490347, 80.15521971218855), //MG
    const LatLng(12.84025046572062, 80.15272843194869), //Main Gate
    const LatLng(12.841629504619002, 80.15464777381395), //Gazebo
    const LatLng(12.844196505796262, 80.15407907479243), //North Square
    const LatLng(12.84464790940032, 80.15374086929253), //V-Mart
    const LatLng(12.843822467176679, 80.15269178863286), //Dominos
  ];

  Widget _buildNavigationCard({
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 150,
          height: 100,
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.videocam,
                color: Colors.white,
                size: 25,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToVideoScreen(BuildContext context, String videoUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoDisplayScreen(videoUrl: videoUrl),
      ),
    );
  }

  Future<Uint8List> getBytesFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    loadData();
  }

  Future<void> _requestLocationPermission() async {
    var status = await Permission.locationWhenInUse.status;
    if (!status.isGranted) {
      await Permission.locationWhenInUse.request();
    }
  }

  void loadData() async {
    for (int i = 0; i < _latLang.length; i++) {
      Uint8List? markerIcon = await getBytesFromAssets(marker[i], 130);

      _markers.add(
        Marker(
          markerId: MarkerId(i.toString()),
          position: _latLang[i],
          icon: BitmapDescriptor.fromBytes(markerIcon),
          onTap: () {
            showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return CustomInfoWindow(
                  title: locationName[i],
                  description: descriptions[i],
                  image: infoImages[i],
                  context: context,
                );
              },
            );
          },
        ),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("VIT Chennai Map"),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Card(
              margin: const EdgeInsets.all(12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: GoogleMap(
                  initialCameraPosition: _initialCameraPosition,
                  markers: Set<Marker>.of(_markers),
                  myLocationEnabled: true,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavigationCard(
                  title: "Gate to Venue",
                  onTap: () => _navigateToVideoScreen(context,
                      "https://firebasestorage.googleapis.com/v0/b/devshouse-dscvitc.appspot.com/o/8315e0fc-94be-4def-912f-34cdbc1db3d1.mp4?alt=media&token=2dd63c88-e823-40d5-98b0-43adba2da3db"),
                ),
                _buildNavigationCard(
                  title: "Venue to Gazebo",
                  onTap: () => _navigateToVideoScreen(context,
                      "https://firebasestorage.googleapis.com/v0/b/devshouse-dscvitc.appspot.com/o/31d8e2d4-bc62-4b44-8bf3-6e36030c1b34.mp4?alt=media&token=afdec122-f56f-42a7-9fd3-88456008f2f9"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
