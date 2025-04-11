class Holiday {
  final String date;
  final String localName;

  Holiday({required this.date, required this.localName});

  factory Holiday.fromJson(Map<String, dynamic> json) {
    return Holiday(
      date: json['date'],
      localName: json['localName'],
    );
  }
}