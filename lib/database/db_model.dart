class Note {
  int? id;
  String title;
  String description;
  String time;

  Note({
    this.id,
    required this.title,
    required this.description,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'time': time,
    };
  }

  static Note fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      time: map['time'],
    );
  }
}
