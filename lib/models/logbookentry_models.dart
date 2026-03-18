class LogbookEntry {
  int? id;
  String title;
  String description;
  DateTime date;
  String? reflection;
  String userId; // New: Optional reflection field

  LogbookEntry({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    this.reflection,
    required this.userId, // Optional
  });

  // Convert to Map for database storage (include reflection)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'reflection': reflection,
      'user_id': userId, // Add this
    };
  }

  // Create from Map (for retrieval, include reflection)
  factory LogbookEntry.fromMap(Map<String, dynamic> map) {
    return LogbookEntry(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      date: DateTime.parse(map['date']),
      reflection: map['reflection'],
      userId: map['user_id'] as String, // Add this
    );
  }

  get comment => null;
}

