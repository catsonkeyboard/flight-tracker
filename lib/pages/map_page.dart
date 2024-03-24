import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flight_tracker/global_data.dart';
import 'package:flight_tracker/utils/logger.dart';

import '../models/Flight.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<MapPage> {
  List<Marker> _markers = [];
  List<Polyline> _polyline = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    initializeMapPosition();
  }

  void initializeMapPosition() async{
    Position pos = await _determinePosition();
    Logger.log("latitude: ${pos.latitude}, longitude: ${pos.longitude}");
    setState(() {
      globalData.latitude = pos.latitude;
      globalData.longitude = pos.longitude;
    });
    // globalData.mapController.move(
    //     LatLng(
    //         globalData.latitude,
    //         globalData.longitude
    //     ),
    //     globalData.mapZoom
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: globalData.mapController,
          options: MapOptions(
              initialCenter: globalData.defaultMapCenter,
              initialZoom: globalData.mapZoom,
              interactionOptions:
              const InteractionOptions(flags: ~InteractiveFlag.doubleTapZoom)
          ),
          children: [
            TileLayer(
              urlTemplate: "http://tile.openstreetmap.org/{z}/{x}/{y}.png",
              userAgentPackageName: 'com.catsonkeyboard.track_app',
            ),
            MarkerLayer(
              markers: [
                ..._markers
              ],
            ),
            PolylineLayer(
                polylines: _polyline
            )
          ],
        ),
        Visibility(
          visible: isLoading,
          child: Container(
            color: Colors.black.withOpacity(0.5),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: MediaQuery
              .of(context)
              .padding
              .bottom + 100.0,
          left: MediaQuery
              .of(context)
              .size
              .width / 2 - 40,
          child: Flex(
              direction: Axis.horizontal,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // setState(() {
                    //   isLoading = true;
                    // });
                    // Position pos = await Geolocator.getCurrentPosition();
                    // setState(() {
                    //   isLoading = false;
                    //   globalData.latitude = pos.latitude;
                    //   globalData.longitude = pos.longitude;
                    // });
                    globalData.mapController.moveAndRotate(
                        globalData.defaultMapCenter,
                        globalData.mapZoom,
                        0
                    );
                  },
                  child: const Center(
                    child: Text(
                      "Locate",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: readJson,
                    child: const Center(
                        child: Text(
                          "Q",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18
                          ),
                        ))
                ),
                ElevatedButton(
                    onPressed: _clear,
                    child: const Center(
                        child: Text(
                          "D",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18
                          ),
                        ))
                )
              ]
          ),
        )
      ],
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<void> readJson() async {
    String jsonString = await rootBundle.loadString(
        'assets/flight_position.json');
    final jsonResponse = json.decode(jsonString);
    var jsonArray = jsonResponse['ac'];
    List<Flight> flights = [];
    for (dynamic jsonObject in jsonArray) {
      Flight flight = Flight.fromJson(jsonObject);
      flights.add(flight);
    }
    setState(() {
      double radians = 0;
      _markers = flights.map((point) {
        if(!point.trak.isNaN) {
          if(point.trak > 360)
            point.trak = point.trak % 360;
          double rotation = point.trak - 180;
          radians = pi * rotation / 180;
        }
        return Marker(
          point: LatLng(point.lat, point.lon),
          width: 60,
          height: 60,
          // child: const Icon(
          //   Icons.flight,
          //   size: 30,
          //   color: Colors.blueAccent,
          // ),
          child: Transform.rotate(
            angle: radians, // 旋转角度（单位：弧度）
            child: const Icon(
              Icons.flight,
              size: 30,
              color: Colors.blueAccent,
          ), // 需要旋转的子组件
          )
        );
      }
      ).toList();
    });
  }

  Future<void> _getLocation() async {
    Position pos;
    try {
      pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        globalData.latitude = pos.latitude;
        globalData.longitude = pos.longitude;
      });
      Logger.log("get location sucess");
    } catch (e) {
      Logger.log("get location failed ${e.toString()}");
      return;
    }
  }

  void _clear() {
    setState(() {
      _markers = [];
      _polyline = [];
    });
  }
}
