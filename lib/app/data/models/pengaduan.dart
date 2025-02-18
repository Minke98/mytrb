class Pengaduan {
  String? noTicket;
  String? typePengaduan;
  String? tglPengaduan;
  String? status;

  Pengaduan({
    this.noTicket,
    this.typePengaduan,
    this.tglPengaduan,
    this.status,
  });

  // Convert JSON to TicketModel
  factory Pengaduan.fromJson(Map<String, dynamic> json) {
    return Pengaduan(
      noTicket: json['noTicket'],
      typePengaduan: json['typePengaduan'],
      tglPengaduan: json['tglPengaduan'],
      status: json['status'],
    );
  }

  // Convert TicketModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'noTicket': noTicket,
      'typePengaduan': typePengaduan,
      'tglPengaduan': tglPengaduan,
      'status': status,
    };
  }
}
