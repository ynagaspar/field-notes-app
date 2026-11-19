import 'dart:convert';

class Note {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String? imagePath;

  const Note({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.imagePath,
  });

  Note copyWith({
    String? title,
    String? description,
    DateTime? date,
    String? imagePath,
    bool clearImage = false,
  }) {
    return Note(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      imagePath: clearImage ? null : (imagePath ?? this.imagePath),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'date': date.toIso8601String(),
        'imagePath': imagePath,
      };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'] as String,
        title: json['title'] as String? ?? '',
        description: json['description'] as String? ?? '',
        date: DateTime.tryParse(json['date'] as String? ?? '') ??
            DateTime.now(),
        imagePath: json['imagePath'] as String?,
      );

  static String encodeList(List<Note> notes) =>
      jsonEncode(notes.map((n) => n.toJson()).toList());

  static List<Note> decodeList(String source) {
    final data = jsonDecode(source) as List<dynamic>;
    return data
        .map((e) => Note.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

String formatDate(DateTime d) => '${_months[d.month - 1]} ${d.day}, ${d.year}';
