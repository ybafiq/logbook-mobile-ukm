class ProjectEntry {
  int? id;
  String title;
  String activity;
  String comment;
  String date;
  String? improvement;
  String userId;

  ProjectEntry({
    this.id,
    required this.title,
    required this.activity,
    required this.comment,
    required this.date,
    this.improvement,
    required this.userId,

  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'activity': activity,
    'comment': comment,
    'date': date,
    'improvement': improvement,
    'user_id': userId,
  };

  factory ProjectEntry.fromMap(Map<String, dynamic> map) => ProjectEntry(
    id: map['id'],
    title: map['title'],
    activity: map['activity'],
    comment: map['comment'],
    date: map['date'],
    improvement: map['improvement'],
    userId: map['user_id'] as String,
  );
}

