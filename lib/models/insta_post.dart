class InstaComment {
  final String author;
  final String content;

  const InstaComment({required this.author, required this.content});

  factory InstaComment.fromJson(Map<String, dynamic> json) => InstaComment(
        author: json['author'] as String,
        content: json['content'] as String,
      );

  Map<String, dynamic> toJson() => {
        'author': author,
        'content': content,
      };
}

class InstaPost {
  final String id;
  final String author;
  final int day;
  final String emoji;
  final String caption;
  final String? imageAsset;
  final int likes;
  final int commentsCount;
  final List<InstaComment> topComments;

  const InstaPost({
    required this.id,
    required this.author,
    required this.day,
    required this.emoji,
    required this.caption,
    this.imageAsset,
    this.likes = 0,
    this.commentsCount = 0,
    this.topComments = const [],
  });

  factory InstaPost.fromJson(Map<String, dynamic> json) => InstaPost(
        id: json['id'] as String,
        author: json['author'] as String,
        day: (json['day'] as num).toInt(),
        emoji: json['emoji'] as String,
        caption: json['caption'] as String,
        imageAsset: json['imageAsset'] as String?,
        likes: (json['likes'] as num?)?.toInt() ?? 0,
        commentsCount: (json['commentsCount'] as num?)?.toInt() ?? 0,
        topComments: ((json['topComments'] as List?) ?? const [])
            .map((e) => InstaComment.fromJson(e as Map<String, dynamic>))
            .toList(growable: false),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'author': author,
        'day': day,
        'emoji': emoji,
        'caption': caption,
        if (imageAsset != null) 'imageAsset': imageAsset,
        'likes': likes,
        'commentsCount': commentsCount,
        if (topComments.isNotEmpty)
          'topComments': topComments.map((c) => c.toJson()).toList(),
      };
}
