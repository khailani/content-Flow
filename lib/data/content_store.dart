import 'package:flutter/foundation.dart';

import '../models/content_plan.dart';

class ContentStore extends ChangeNotifier {
  ContentStore()
    : _items = <ContentPlan>[
        ContentPlan(
          id: 1,
          title: 'Tips Produktif di Pagi Hari',
          client: 'Kopi Nusantara',
          platform: 'Instagram',
          status: 'Ide',
          description: 'Carousel ringan berisi rutinitas pagi agar hari terasa lebih produktif. Tutup dengan ajakan menikmati kopi sebelum mulai beraktivitas.',
          publishDate: DateTime(2026, 11, 5),
        ),
        ContentPlan(
          id: 2,
          title: '5 Cara Merawat Kulit',
          client: 'Glow Beauty',
          platform: 'TikTok',
          status: 'Proses',
          description: 'Video pendek dengan lima langkah perawatan kulit harian yang mudah diikuti, disertai demonstrasi produk.',
          publishDate: DateTime(2026, 11, 7),
        ),
        ContentPlan(
          id: 3,
          title: 'Promo Akhir Tahun',
          client: 'Toko Serba Ada',
          platform: 'Instagram',
          status: 'Siap Terbit',
          description: 'Materi promosi diskon akhir tahun untuk feed dan story. Pastikan detail periode promo tercantum di desain.',
          publishDate: DateTime(2026, 11, 10),
        ),
        ContentPlan(
          id: 4,
          title: 'Mengenal Digital Marketing',
          client: 'EduSmart',
          platform: 'Facebook',
          status: 'Terbit',
          description: 'Konten edukasi pengantar digital marketing untuk pemilik usaha kecil yang baru memulai promosi online.',
          publishDate: DateTime(2026, 10, 28),
        ),
      ];

  final List<ContentPlan> _items;
  int _nextId = 5;

  List<ContentPlan> get items => List<ContentPlan>.unmodifiable(_items);

  ContentPlan? findById(int id) {
    for (final item in _items) {
      if (item.id == id) return item;
    }
    return null;
  }

  int countByStatus(String status) =>
      _items.where((item) => item.status == status).length;

  ContentPlan add(ContentPlan content) {
    final created = content.copyWith(id: _nextId++);
    _items.insert(0, created);
    notifyListeners();
    return created;
  }

  void update(ContentPlan content) {
    final index = _items.indexWhere((item) => item.id == content.id);
    if (index == -1) return;
    _items[index] = content;
    notifyListeners();
  }

  void delete(int id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}
