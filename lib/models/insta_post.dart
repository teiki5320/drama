class InstaPost {
  final String id;
  final String author;
  final int day;
  final String emoji;
  final String caption;

  const InstaPost({
    required this.id,
    required this.author,
    required this.day,
    required this.emoji,
    required this.caption,
  });

  factory InstaPost.fromJson(Map<String, dynamic> json) => InstaPost(
        id: json['id'] as String,
        author: json['author'] as String,
        day: (json['day'] as num).toInt(),
        emoji: json['emoji'] as String,
        caption: json['caption'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'author': author,
        'day': day,
        'emoji': emoji,
        'caption': caption,
      };
}
