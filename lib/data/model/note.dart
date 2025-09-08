class Note {
  final String id;
  final String title;
  final String description;
  final DateTime updatedAt;

  Note({
    required this.id,
    required this.title,
    required this.description,
    required this.updatedAt,
  });

  Note copyWith({String? title, String? description, DateTime? updatedAt}) => Note(
    id: id,
    title: title ?? this.title,
    description: description ?? this.description,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory Note.fromMap(Map<String, dynamic> map) => Note(
    id: map['id'] as String,
    title: map['title'] as String,
    description: map['description'] as String? ?? '',
    updatedAt: DateTime.parse(map['updatedAt'] as String),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'updatedAt': updatedAt.toIso8601String(),
  };
}
