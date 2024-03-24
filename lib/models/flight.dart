class Flight {

  int postime;

  String reg;

  String type;

  double lat;

  double lon;

  double alt;

  double ttrk;

  double trak;

  Flight({
    required this.postime,
    required this.reg,
    required this.type,
    required this.lat,
    required this.lon,
    required this.alt,
    required this.ttrk,
    required this.trak
  });

  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight(
      postime: int.parse(json['postime']),
      reg: json['reg'],
      type: json['type'],
      lat: double.parse(json['lat']),
      lon: double.parse(json['lon']),
      alt: (json['alt'] == null || json['alt'] == "") ? double.nan : double.parse(json['alt']),
      ttrk: (json['ttrk'] == null || json['ttrk'] == "") ? double.nan : double.parse(json['ttrk']),
      trak: (json['trak'] == null || json['trak'] == "") ? double.nan : double.parse(json['trak']),
    );
  }
}