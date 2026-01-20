import 'package:equatable/equatable.dart';

class TextEntity extends Equatable {
  final String id;
  final String title;
  final String content;
  final String? author;

  const TextEntity({
    required this.id,
    required this.title,
    required this.content,
    this.author,
  });

  factory TextEntity.fromJson(Map<String, dynamic> json) {
    return TextEntity(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Untitled',
      content: json['content'] as String? ?? '',
      author: json['author'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, title, content, author];
}
