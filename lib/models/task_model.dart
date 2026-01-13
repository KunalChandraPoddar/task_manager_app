class Task {
  final String id;
  final String title;
  final DateTime dateTime;
  bool completed;

  Task({
    required this.id,
    required this.title,
    required this.dateTime,
    this.completed = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'dateTime': dateTime.toIso8601String(),
        'completed': completed,
      };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'],
        title: json['title'],
        dateTime: DateTime.parse(json['dateTime']),
        completed: json['completed'],
      );
}
