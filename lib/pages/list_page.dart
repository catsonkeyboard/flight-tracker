import 'dart:async';
import 'package:flight_tracker/models/flight.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:flight_tracker/global_data.dart';
import 'package:flight_tracker/utils/logger.dart';


class ListPage extends StatefulWidget {
  const ListPage({super.key});
  @override
  ListState createState() => ListState();
}

class ListState extends State<ListPage> {
  List<Flight> _flights = [];
  bool listScrollable = true;
  int selected = 0;
  Icon panelDropIcon = const Icon(Icons.arrow_drop_up);

  @override
  void initState() {
    super.initState();
    _flights = [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
            child: Center(
              child: panelDropIcon,
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 200.0,
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: listScrollable
                      ? null
                      : const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: _flights.length,
                  itemBuilder: (context, index) {
                    return _animatedItem(index, _flights[index]);
                  }
              ),
            ),
          ),
        ]
    );
  }

  Widget _animatedItem(int index, Flight flight) {
    return InkWell(
      child: AnimatedContainer(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(20),
        color: selected == index ? Colors.blueGrey.shade100 : Colors.white,
        ),
        child: _item(index, flight),
      ),
    );
  }

  Widget _item(int index, Flight flight) {
    return ListTile(
      // margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      title: Text(flight.reg)
    );
  }

  void panelOpen() {
    Logger.log('opened');
    setState(() {
      listScrollable = true;
      panelDropIcon = const Icon(Icons.arrow_drop_down);
    });
  }

  void panelClose() {
    Logger.log('closed');
    setState(() {
      listScrollable = false;
      panelDropIcon = const Icon(Icons.arrow_drop_up);
    });
  }
}