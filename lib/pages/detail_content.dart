import 'package:flutter/material.dart';

import '../data/content_store.dart';
import '../models/content_plan.dart';
import '../theme/app_theme.dart';
import '../widgets/content_widgets.dart';
import 'form_content.dart';

class DetailContentPage extends StatelessWidget {
  const DetailContentPage({
    super.key,
    required this.contentId,
    required this.store,
  });

  final int contentId;
  final ContentStore store;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rencana konten')),
      body: ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          final content = store.findById(contentId);
          if (content == null) {
            return const Center(
              child: Text('Konten ini sudah tidak tersedia.'),
            );
          }

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DetailHero(
                      content: content,
                      platformIcon: _platformIcon(content.platform),
                    ),
                    const SizedBox(height: 16),
                    _DetailSection(
                      title: 'Informasi konten',
                      child: Column(
                        children: [
                          _DetailRow(
                            icon: Icons.business_outlined,
                            label: 'Nama klien',
                            value: content.client,
                          ),
                          const Divider(height: 22),
                          _DetailRow(
                            icon: _platformIcon(content.platform),
                            label: 'Platform',
                            value: content.platform,
                          ),
                          const Divider(height: 22),
                          _DetailRow(
                            icon: Icons.calendar_month_outlined,
                            label: 'Tanggal publikasi',
                            value: formatDate(content.publishDate),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    _DetailSection(
                      title: 'Deskripsi',
                      child: Text(
                        content.description.trim().isEmpty
                            ? 'Belum ada deskripsi untuk konten ini.'
                            : content.description,
                        style: const TextStyle(
                          color: Color(0xFF52635E),
                          height: 1.6,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _confirmDelete(context),
                            icon: const Icon(Icons.delete_outline_rounded),
                            label: const Text('Hapus'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFB64242),
                              side: const BorderSide(color: Color(0xFFE6BDBD)),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                          ),
                        ),
                        const SizedBox(width: 11),
                        Expanded(
                          flex: 2,
                          child: FilledButton.icon(
                            onPressed: () => _openEditForm(context, content),
                            icon: const Icon(Icons.edit_outlined),
                            label: const Text('Ubah konten'),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _openEditForm(BuildContext context, ContentPlan content) async {
    await Navigator.of(context).push<ContentPlan>(
      MaterialPageRoute<ContentPlan>(
        builder: (_) => FormContentPage(store: store, content: content),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus konten?'),
        content: const Text(
          'Rencana konten ini akan dihapus dari daftar selama aplikasi berjalan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFB64242),
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      store.delete(contentId);
      if (context.mounted) Navigator.pop(context);
    }
  }

  IconData _platformIcon(String platform) => switch (platform) {
    'Instagram' => Icons.camera_alt_outlined,
    'TikTok' => Icons.music_note_rounded,
    'Facebook' => Icons.thumb_up_alt_outlined,
    _ => Icons.campaign_outlined,
  };
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE3E9E3)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x070F3029),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.ink,
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }
}

class _DetailHero extends StatelessWidget {
  const _DetailHero({required this.content, required this.platformIcon});

  final ContentPlan content;
  final IconData platformIcon;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(23),
      child: Stack(
        children: [
          Positioned(
            right: -35,
            top: -70,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0x1CFFFFFF)),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF173F35), Color(0xFF23594B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0x24FFFFFF),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0x33FFFFFF)),
                      ),
                      child: Icon(platformIcon, color: Colors.white, size: 21),
                    ),
                    const Spacer(),
                    StatusBadge(status: content.status),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'DETAIL KONTEN',
                  style: TextStyle(
                    color: Color(0xFFC5D8CF),
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  content.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    height: 1.2,
                    letterSpacing: -0.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 9),
                Row(
                  children: [
                    const Icon(
                      Icons.business_outlined,
                      color: Color(0xFFC5D8CF),
                      size: 15,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        content.client,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFFD6E1DB),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.calendar_today_outlined,
                      color: Color(0xFFC5D8CF),
                      size: 13,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      formatDate(content.publishDate),
                      style: const TextStyle(
                        color: Color(0xFFD6E1DB),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primary, size: 19),
        const SizedBox(width: 11),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Color(0xFF71807A), fontSize: 13),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: AppTheme.ink,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}
