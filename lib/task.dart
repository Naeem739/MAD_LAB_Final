class Task {
  String title;
  DateTime date;
  int id;
  String contactName;
  String phoneNumber;

  Task({
    required this.title,
    required this.date,
    required this.id,
    required this.contactName,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'date': date.toIso8601String(),
        'id': id,
        'contactName': contactName,
        'phoneNumber': phoneNumber,
      };

  static Task fromJson(Map<String, dynamic> json) => Task(
        title: json['title'],
        date: DateTime.parse(json['date']),
        id: json['id'],
        contactName: json['contactName'],
        phoneNumber: json['phoneNumber'],
      );
}
