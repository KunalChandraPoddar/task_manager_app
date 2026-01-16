class Task {
  final String id;
  final String title;
  final DateTime dateTime;
  bool completed;
  bool notified;

  Task({
    required this.id,
    required this.title,
    required this.dateTime,
    this.completed = false,
    this.notified = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'],
    title: json['title'],
    dateTime: DateTime.parse(json['dateTime']),
    completed: json['completed'],
    notified: json['notified'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'dateTime': dateTime.toIso8601String(),
    'completed': completed,
    'notified': notified,
  };
}
