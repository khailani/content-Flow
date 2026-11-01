import 'package:flutter/material.dart';

import '../models/content_plan.dart';
import '../theme/app_theme.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final (Color background, Color foreground) = switch (status) {
      'Ide' => (const Color(0xFFF0EDFF), const Color(0xFF6254A3)),
      'Proses' => (const Color(0xFFFBF0DC), const Color(0xFF91651D)),
      'Siap Terbit' => (const Color(0xFFE4F0E6), const Color(0xFF39754A)),
      'Terbit' => (const Color(0xFFE5EEF1), const Color(0xFF386A78)),
      _ => (const Color(0xFFEBEFEC), const Color(0xFF52635E)),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: foreground,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(
              color: foreground,
              fontSize: 11,
              letterSpacing: 0.1,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class ContentCard extends StatelessWidget {
  const ContentCard({
    super.key,
    required this.content,
    required this.onTap,
    this.compact = false,
  });

  final ContentPlan content;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: Colors.white,
      elevation: 1,
      shadowColor: const Color(0x100F3029),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFFE5EAE5)),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(compact ? 15 : 17),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDF3EE),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  _platformIcon(content.platform),
                  color: AppTheme.primary,
                  size: 21,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      content.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.ink,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${content.client}  ·  ${content.platform}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF71807A),
                        fontSize: 12,
                      ),
                    ),
                    if (!compact) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          StatusBadge(status: content.status),
                          const SizedBox(width: 9),
                          Flexible(
                            child: Text(
                              formatDate(content.publishDate),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF71807A),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              if (compact) ...[
                const SizedBox(width: 10),
                StatusBadge(status: content.status),
              ] else ...[
                const SizedBox(width: 10),
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF2F5F2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_outward_rounded,
                    color: Color(0xFF65766F),
                    size: 16,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _platformIcon(String platform) => switch (platform) {
    'Instagram' => Icons.camera_alt_outlined,
    'TikTok' => Icons.music_note_rounded,
    'Facebook' => Icons.thumb_up_alt_outlined,
    _ => Icons.campaign_outlined,
  };
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    required this.message,
    this.action,
  });

  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 34),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE5EAE5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080F3029),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(
              color: Color(0xFFECF5F1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.event_note_outlined,
              color: AppTheme.primary,
              size: 26,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 5),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF71807A),
              height: 1.45,
              fontSize: 13,
            ),
          ),
          if (action != null) ...[const SizedBox(height: 18), action!],
        ],
      ),
    );
  }
}

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: AppTheme.ink,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        if (actionLabel != null)
          TextButton(onPressed: onAction, child: Text(actionLabel!)),
      ],
    );
  }
}
