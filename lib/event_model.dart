class Event {
  String name;
  String club;
  String status;
  DateTime time;
  String? id;

  Event({
    required this.name,
    required this.club,
    required this.status,
    required this.time,
    this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'club': club,
      'status': status,
      'time': time.toIso8601String(),
      'id': id,
    };
  }

  static Event fromJson(Map<String, dynamic> json) {
    return Event(
      name: json['name'],
      club: json['club'],
      status: json['status'],
      time: DateTime.parse(json['time']),
      id: json['id'],
    );
  }
}
