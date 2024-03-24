import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flight_tracker/pages/map_page.dart';
import 'package:flight_tracker/pages/list_page.dart';
import 'package:vibration/vibration.dart';
import 'package:flight_tracker/global_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ListState> listKey = GlobalKey<ListState>();
  BorderRadiusGeometry radius = const BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    globalData.mapController = MapController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
          borderRadius: radius,
          backdropEnabled: true,
          panel: ListPage(key: listKey),
          onPanelOpened: () {
            Vibration.vibrate(duration: 5);
            listKey.currentState?.panelOpen();
          },
          onPanelClosed: () {
            Vibration.vibrate(duration: 5);
            listKey.currentState?.panelClose();
          },
          body: MapPage()
      ),
    );
  }

}