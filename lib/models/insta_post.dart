class InstaPost {
  final String id;
  final String author;
  final int day;
  final String emoji;
  final String caption;
  final String? imageAsset;
  final int likes;
  final int commentsCount;

  const InstaPost({
    required this.id,
    required this.author,
    required this.day,
    required this.emoji,
    required this.caption,
    this.imageAsset,
    this.likes = 0,
    this.commentsCount = 0,
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
      };
}
