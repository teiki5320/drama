import 'package:flutter/material.dart';

import '../../core/colors.dart';
import '../../models/sms_message.dart';

class SmsBubble extends StatelessWidget {
  const SmsBubble({super.key, required this.message});

  final SmsMessage message;

  @override
  Widget build(BuildContext context) {
    final me = message.isMe;
    final bg = me ? AppColors.smsBlue : AppColors.smsGray;
    final fg = me ? Colors.white : AppColors.textPrimary;
    final align = me ? Alignment.centerRight : Alignment.centerLeft;
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(18),
      topRight: const Radius.circular(18),
      bottomLeft: Radius.circular(me ? 18 : 4),
      bottomRight: Radius.circular(me ? 4 : 18),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment:
            me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!me)
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 2),
              child: Text(
                message.sender,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          Align(
            alignment: align,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.78,
              ),
              child: Container(
                decoration: BoxDecoration(color: bg, borderRadius: radius),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                child: Text(
                  message.content,
                  style: TextStyle(color: fg, fontSize: 15, height: 1.35),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
