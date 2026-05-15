import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/phone_apps.dart';

/// Banner drop-down de notification — apparaît en haut de l'écran
/// brièvement, comme iOS. Animé : slide down, hold 3.5s, slide up.
class NotificationBanner extends StatefulWidget {
  const NotificationBanner({
    super.key,
    required this.appId,
    required this.title,
    required this.body,
    this.onTap,
  });

  final String appId;
  final String title;
  final String body;
  final VoidCallback? onTap;

  @override
  State<NotificationBanner> createState() => _NotificationBannerState();
}

class _NotificationBannerState extends State<NotificationBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 280),
  );

  @override
  void initState() {
    super.initState();
    HapticFeedback.lightImpact();
    _ctrl.forward();
    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) {
        _ctrl.reverse().then((_) {
          if (mounted) Navigator.of(context).pop();
        });
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final meta = appById(widget.appId);
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        final t = Curves.easeOutCubic.transform(_ctrl.value);
        return Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Transform.translate(
                  offset: Offset(0, (1 - t) * -120),
                  child: Opacity(
                    opacity: t,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                      child: GestureDetector(
                        onTap: () {
                          _ctrl.reverse().then((_) {
                            if (mounted) Navigator.of(context).pop();
                            widget.onTap?.call();
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.95),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: meta.color,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(meta.icon,
                                    color: meta.fgColor, size: 18),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            meta.label.toUpperCase(),
                                            style: GoogleFonts.inter(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey.shade600,
                                              letterSpacing: 0.4,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'maintenant',
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      widget.title,
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF1A1A1A),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      widget.body,
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        color: const Color(0xFF3A3A3A),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Helper pour afficher un banner depuis n'importe où.
Future<void> showPhoneNotification(
  BuildContext context, {
  required String appId,
  required String title,
  required String body,
  VoidCallback? onTap,
}) {
  return Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 1),
      pageBuilder: (_, __, ___) => NotificationBanner(
        appId: appId,
        title: title,
        body: body,
        onTap: onTap,
      ),
    ),
  );
}
