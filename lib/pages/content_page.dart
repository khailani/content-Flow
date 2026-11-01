import 'package:flutter/material.dart';

import '../data/content_store.dart';
import '../models/content_plan.dart';
import '../theme/app_theme.dart';
import '../widgets/content_widgets.dart';
import 'detail_content.dart';
import 'form_content.dart';

class ContentPage extends StatefulWidget {
  const ContentPage({super.key, required this.store});

  final ContentStore store;

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  String _selectedStatus = 'Semua';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manajemen konten')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateForm,
        icon: const Icon(Icons.add),
        label: const Text('Tambah konten'),
      ),
      body: ListenableBuilder(
        listenable: widget.store,
        builder: (context, _) {
          final allItems = widget.store.items;
          final query = _searchController.text.trim().toLowerCase();
          final visibleItems = allItems.where((item) {
            final matchesStatus =
                _selectedStatus == 'Semua' || item.status == _selectedStatus;
            final matchesQuery =
                query.isEmpty ||
                item.title.toLowerCase().contains(query) ||
                item.client.toLowerCase().contains(query) ||
                item.platform.toLowerCase().contains(query);
            return matchesStatus && matchesQuery;
          }).toList();

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'KONTEN KLIEN',
                                    style: TextStyle(
                                      color: AppTheme.primary,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Semua rencana',
                                    style: TextStyle(
                                      color: AppTheme.ink,
                                      fontSize: 23,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.sage,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                '${allItems.length} item',
                                style: const TextStyle(
                                  color: AppTheme.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Cari dan atur semua rencana publikasi klien.',
                          style: TextStyle(color: AppTheme.muted, fontSize: 13),
                        ),
                        const SizedBox(height: 17),
                        TextField(
                          controller: _searchController,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: 'Cari judul, klien, atau platform',
                            prefixIcon: const Icon(Icons.search_rounded),
                            suffixIcon: _searchController.text.isEmpty
                                ? null
                                : IconButton(
                                    tooltip: 'Hapus pencarian',
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {});
                                    },
                                    icon: const Icon(Icons.close_rounded),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Row(
                          children: [
                            Icon(
                              Icons.tune_rounded,
                              size: 15,
                              color: AppTheme.muted,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'FILTER STATUS',
                              style: TextStyle(
                                color: AppTheme.muted,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 9),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: ['Semua', ...contentStatuses].map((
                              status,
                            ) {
                              final selected = status == _selectedStatus;
                              final count = status == 'Semua'
                                  ? allItems.length
                                  : widget.store.countByStatus(status);
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                  label: Text('$status  $count'),
                                  selected: selected,
                                  showCheckmark: false,
                                  onSelected: (_) =>
                                      setState(() => _selectedStatus = status),
                                  labelStyle: TextStyle(
                                    color: selected
                                        ? Colors.white
                                        : const Color(0xFF52635E),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                  backgroundColor: Colors.white,
                                  elevation: selected ? 1 : 0,
                                  shadowColor: const Color(0x18172F29),
                                  selectedColor: AppTheme.primary,
                                  side: BorderSide(
                                    color: selected
                                        ? AppTheme.primary
                                        : const Color(0xFFE1E7E1),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${visibleItems.length} hasil ditemukan',
                          style: const TextStyle(
                            color: AppTheme.muted,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  Expanded(
                    child: visibleItems.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 90),
                            child: Center(
                              child: EmptyState(
                                title: allItems.isEmpty
                                    ? 'Daftar masih kosong'
                                    : query.isNotEmpty
                                    ? 'Tidak ada hasil yang cocok'
                                    : 'Belum ada konten dengan status $_selectedStatus',
                                message: allItems.isEmpty
                                    ? 'Tambahkan rencana konten pertama untuk mulai mengelola jadwal publikasi.'
                                    : query.isNotEmpty
                                    ? 'Coba kata kunci lain atau hapus pencarian untuk melihat semua konten.'
                                    : 'Coba pilih status lain atau tambahkan konten baru.',
                                action: allItems.isEmpty
                                    ? FilledButton.icon(
                                        onPressed: _openCreateForm,
                                        icon: const Icon(Icons.add),
                                        label: const Text('Tambah konten'),
                                      )
                                    : null,
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                            itemCount: visibleItems.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final item = visibleItems[index];
                              return ContentCard(
                                content: item,
                                onTap: () => _openDetail(item),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _openCreateForm() {
    Navigator.of(context).push<ContentPlan>(
      MaterialPageRoute<ContentPlan>(
        builder: (_) => FormContentPage(store: widget.store),
      ),
    );
  }

  void _openDetail(ContentPlan content) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) =>
            DetailContentPage(contentId: content.id, store: widget.store),
      ),
    );
  }
}
