import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';


class GlobalDataClass {
  late DateTime selectedDay;
  late MapController mapController;
  double latitude = 0;
  double longitude = 0;
  double mapZoom = 10;
  LatLng defaultMapCenter = const LatLng(22.313751492444286, 113.9140608896911);
}

final globalData = GlobalDataClass();