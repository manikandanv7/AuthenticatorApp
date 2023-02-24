class LogDetails {
  String ip;
  String location;
  String date;
  String? qr;

  LogDetails(
      {required this.ip, required this.location, required this.date, this.qr});

  // from map
  factory LogDetails.fromMap(Map<String, dynamic> map) {
    return LogDetails(
        ip: map['ip'] ?? '',
        location: map['location'] ?? '',
        date: map['date'] ?? '',
        qr: map['qr'] ?? '');
  }

  // to map
  Map<String, dynamic> toMap() {
    return {"ip": ip, "location": location, "date": date, "qr": qr};
  }
}
