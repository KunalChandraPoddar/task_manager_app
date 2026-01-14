class Task {
  String title;
  DateTime dateTime;
  bool completed;

  Task({
    required this.title,
    required this.dateTime,
    this.completed = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        title: json['title'],
        dateTime: DateTime.parse(json['dateTime']),
        completed: json['completed'],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'dateTime': dateTime.toIso8601String(),
        'completed': completed,
      };
}
