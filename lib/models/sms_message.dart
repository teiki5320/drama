class SmsMessage {
  final String sender;
  final String content;
  final String? time;

  const SmsMessage({
    required this.sender,
    required this.content,
    this.time,
  });

  bool get isMe => sender.toLowerCase() == 'moi';

  factory SmsMessage.fromJson(Map<String, dynamic> json) => SmsMessage(
        sender: json['sender'] as String,
        content: json['content'] as String,
        time: json['time'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'sender': sender,
        'content': content,
        if (time != null) 'time': time,
      };
}
