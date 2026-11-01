import 'dart:async';

import 'package:flutter/material.dart';

import '../data/content_store.dart';
import '../models/content_plan.dart';
import '../theme/app_theme.dart';
import '../widgets/content_widgets.dart';
import 'content_page.dart';
import 'detail_content.dart';
import 'form_content.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.store});

  final ContentStore store;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Icon(
                Icons.auto_awesome_mosaic_rounded,
                color: Colors.white,
                size: 19,
              ),
            ),
            const SizedBox(width: 11),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('ContentFlow'),
                SizedBox(height: 1),
                Text(
                  'CONTENT STUDIO',
                  style: TextStyle(
                    color: AppTheme.muted,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton.filledTonal(
            tooltip: 'Daftar konten',
            onPressed: () => _openContentList(context),
            style: IconButton.styleFrom(
              backgroundColor: AppTheme.sage,
              foregroundColor: AppTheme.primary,
            ),
            icon: const Icon(Icons.view_list_rounded),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          final items = store.items;
          final upcoming =
              items
                  .where(
                    (item) =>
                        !DateUtils.dateOnly(item.publishDate)
                            .isBefore(DateUtils.dateOnly(DateTime.now())),
                  )
                  .toList()
                ..sort((a, b) => a.publishDate.compareTo(b.publishDate));
          final featured = upcoming.isNotEmpty
              ? upcoming.first
              : items.isNotEmpty
              ? items.first
              : null;
          final recentItems = items.take(3).toList();

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _LiveDateTimeHeader(),
                    const SizedBox(height: 16),
                    _OverviewBanner(
                      total: items.length,
                      inProgress: store.countByStatus('Proses'),
                      ready: store.countByStatus('Siap Terbit'),
                      onOpen: () => _openContentList(context),
                      onAdd: () => _openCreateForm(context),
                    ),
                    const SizedBox(height: 28),
                    SectionHeading(
                      title: 'Status konten',
                      actionLabel: 'Lihat daftar  →',
                      onAction: () => _openContentList(context),
                    ),
                    const SizedBox(height: 12),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final columns = constraints.maxWidth >= 860
                            ? 4
                            : constraints.maxWidth >= 580
                            ? 3
                            : 2;
                        final cardWidth =
                            (constraints.maxWidth - (columns - 1) * 11) /
                            columns;
                        return GridView.count(
                          crossAxisCount: columns,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 11,
                          mainAxisSpacing: 11,
                          childAspectRatio: cardWidth / 110,
                          children: [
                            _MetricCard(
                              label: 'Ide',
                              value: store.countByStatus('Ide'),
                              total: items.length,
                              icon: Icons.lightbulb_outline_rounded,
                              color: const Color(0xFF7566A8),
                              tint: const Color(0xFFF0EDFA),
                            ),
                            _MetricCard(
                              label: 'Proses',
                              value: store.countByStatus('Proses'),
                              total: items.length,
                              icon: Icons.pending_actions_rounded,
                              color: const Color(0xFF9A702A),
                              tint: const Color(0xFFF8F0E1),
                            ),
                            _MetricCard(
                              label: 'Siap Terbit',
                              value: store.countByStatus('Siap Terbit'),
                              total: items.length,
                              icon: Icons.task_alt_rounded,
                              color: const Color(0xFF3D7950),
                              tint: const Color(0xFFE8F1E8),
                            ),
                            _MetricCard(
                              label: 'Terbit',
                              value: store.countByStatus('Terbit'),
                              total: items.length,
                              icon: Icons.rocket_launch_outlined,
                              color: const Color(0xFF477481),
                              tint: const Color(0xFFE8F0F1),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 27),
                    const SectionHeading(title: 'Jadwal publikasi'),
                    const SizedBox(height: 11),
                    if (featured == null)
                      EmptyState(
                        title: 'Belum ada jadwal',
                        message: 'Tambahkan rencana konten pertama untuk mulai menyusun kalender publikasi.',
                        action: FilledButton.icon(
                          onPressed: () => _openCreateForm(context),
                          icon: const Icon(Icons.add),
                          label: const Text('Buat rencana'),
                        ),
                      )
                    else
                      _UpcomingCard(
                        content: featured,
                        isUpcoming: upcoming.isNotEmpty,
                        onTap: () => _openDetail(context, featured),
                      ),
                    const SizedBox(height: 27),
                    SectionHeading(
                      title: 'Baru ditambahkan',
                      actionLabel: 'Semua konten  →',
                      onAction: () => _openContentList(context),
                    ),
                    const SizedBox(height: 11),
                    if (recentItems.isEmpty)
                      const SizedBox.shrink()
                    else
                      ...recentItems.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ContentCard(
                            content: item,
                            compact: true,
                            onTap: () => _openDetail(context, item),
                          ),
                        ),
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

  void _openContentList(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => ContentPage(store: store)));
  }

  void _openCreateForm(BuildContext context) {
    Navigator.of(context).push<ContentPlan>(
      MaterialPageRoute<ContentPlan>(
        builder: (_) => FormContentPage(store: store),
      ),
    );
  }

  void _openDetail(BuildContext context, ContentPlan content) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => DetailContentPage(contentId: content.id, store: store),
      ),
    );
  }
}

class _LiveDateTimeHeader extends StatefulWidget {
  const _LiveDateTimeHeader();

  @override
  State<_LiveDateTimeHeader> createState() => _LiveDateTimeHeaderState();
}

class _LiveDateTimeHeaderState extends State<_LiveDateTimeHeader> {
  late DateTime _now;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: const Color(0xFFE3E9E3)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x070F3029),
            blurRadius: 16,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.sage,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.calendar_month_rounded,
              color: AppTheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _weekdayName(_now.weekday).toUpperCase(),
                  style: const TextStyle(
                    color: AppTheme.muted,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${_now.day} ${_monthName(_now.month)} ${_now.year}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppTheme.ink,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(width: 1, height: 34, color: const Color(0xFFE6EBE6)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${_twoDigits(_now.hour)}:${_twoDigits(_now.minute)}',
                style: const TextStyle(
                  color: AppTheme.ink,
                  fontSize: 18,
                  height: 1.1,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              const Text(
                'WIB',
                style: TextStyle(
                  color: AppTheme.muted,
                  fontSize: 8,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.7,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String _twoDigits(int value) => value.toString().padLeft(2, '0');

String _weekdayName(int weekday) => const [
  'Senin',
  'Selasa',
  'Rabu',
  'Kamis',
  'Jumat',
  'Sabtu',
  'Minggu',
][weekday - 1];

String _monthName(int month) => const [
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember',
][month - 1];

String _shortMonth(int month) => const [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des',
][month - 1];

class _OverviewBanner extends StatelessWidget {
  const _OverviewBanner({
    required this.total,
    required this.inProgress,
    required this.ready,
    required this.onOpen,
    required this.onAdd,
  });

  final int total;
  final int inProgress;
  final int ready;
  final VoidCallback onOpen;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          Positioned(
            right: -40,
            top: -80,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0x22FFFFFF), width: 1),
              ),
            ),
          ),
          Positioned(
            right: 25,
            top: -34,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0x16FFFFFF), width: 1),
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 500;
                final copy = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x24FFFFFF),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        'TOTAL KONTEN',
                        style: TextStyle(
                          color: Color(0xFFD8E5CF),
                          letterSpacing: 1.2,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 13),
                    const Text(
                      'Konten klien',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        height: 1.12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 7),
                    const Text(
                      'Ringkasan status dan jadwal publikasi.',
                      style: TextStyle(
                        color: Color(0xFFC5D8CF),
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 17),
                    Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        FilledButton.icon(
                          onPressed: onAdd,
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFDDE8CC),
                            foregroundColor: const Color(0xFF1A4438),
                            minimumSize: const Size(0, 43),
                          ),
                          icon: const Icon(Icons.add_rounded, size: 18),
                          label: const Text('Tambah konten'),
                        ),
                        TextButton(
                          onPressed: onOpen,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            minimumSize: const Size(0, 43),
                          ),
                          child: const Text('Daftar konten'),
                        ),
                      ],
                    ),
                  ],
                );

                final metrics = _HeroMetrics(
                  total: total,
                  inProgress: inProgress,
                  ready: ready,
                );
                if (isNarrow) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [copy, const SizedBox(height: 18), metrics],
                  );
                }
                return Row(
                  children: [
                    Expanded(child: copy),
                    const SizedBox(width: 28),
                    metrics,
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroMetrics extends StatelessWidget {
  const _HeroMetrics({
    required this.total,
    required this.inProgress,
    required this.ready,
  });

  final int total;
  final int inProgress;
  final int ready;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 188,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0x20FFFFFF),
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: const Color(0x29FFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SELURUH RENCANA',
            style: TextStyle(
              color: Color(0xFFC5D8CF),
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 3),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$total',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  height: 1,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 6, bottom: 4),
                child: Text(
                  'konten',
                  style: TextStyle(color: Color(0xFFC5D8CF), fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          const Divider(color: Color(0x35FFFFFF), height: 1),
          const SizedBox(height: 12),
          _HeroMetricLine(label: 'Sedang dikerjakan', value: inProgress),
          const SizedBox(height: 9),
          _HeroMetricLine(label: 'Siap tayang', value: ready),
        ],
      ),
    );
  }
}

class _HeroMetricLine extends StatelessWidget {
  const _HeroMetricLine({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Color(0xFFD6E1DB), fontSize: 10),
          ),
        ),
        Text(
          '$value',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.total,
    required this.icon,
    required this.color,
    required this.tint,
  });

  final String label;
  final int value;
  final int total;
  final IconData icon;
  final Color color;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : value / total;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: const Color(0xFFE4E9E3)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x070F3029),
            blurRadius: 16,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: tint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const Spacer(),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: Text(
                  '$value',
                  key: ValueKey(value),
                  style: TextStyle(
                    color: AppTheme.ink,
                    fontSize: 23,
                    height: 1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppTheme.ink,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 9),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 4,
                  backgroundColor: tint,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UpcomingCard extends StatelessWidget {
  const _UpcomingCard({
    required this.content,
    required this.isUpcoming,
    required this.onTap,
  });

  final ContentPlan content;
  final bool isUpcoming;
  final VoidCallback onTap;

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
        side: const BorderSide(color: Color(0xFFE4E9E3)),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 58,
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDF3EE),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Text(
                      '${content.publishDate.day}',
                      style: const TextStyle(
                        color: AppTheme.primary,
                        fontSize: 22,
                        height: 1.1,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      _shortMonth(content.publishDate.month).toUpperCase(),
                      style: const TextStyle(
                        color: AppTheme.primary,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.7,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isUpcoming ? 'PUBLIKASI BERIKUTNYA' : 'UPDATE TERAKHIR',
                      style: const TextStyle(
                        color: AppTheme.primary,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      content.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.ink,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${content.client}  ·  ${formatDate(content.publishDate)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.muted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_rounded,
                size: 18,
                color: Color(0xFF829089),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
