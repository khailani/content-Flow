class ContentPlan {
  const ContentPlan({
    required this.id,
    required this.title,
    required this.client,
    required this.platform,
    required this.status,
    required this.description,
    required this.publishDate,
  });

  final int id;
  final String title;
  final String client;
  final String platform;
  final String status;
  final String description;
  final DateTime publishDate;

  ContentPlan copyWith({
    int? id,
    String? title,
    String? client,
    String? platform,
    String? status,
    String? description,
    DateTime? publishDate,
  }) {
    return ContentPlan(
      id: id ?? this.id,
      title: title ?? this.title,
      client: client ?? this.client,
      platform: platform ?? this.platform,
      status: status ?? this.status,
      description: description ?? this.description,
      publishDate: publishDate ?? this.publishDate,
    );
  }
}

const List<String> contentStatuses = <String>[
  'Ide',
  'Proses',
  'Siap Terbit',
  'Terbit',
];

const List<String> contentPlatforms = <String>[
  'Instagram',
  'TikTok',
  'Facebook',
];

String formatDate(DateTime date) {
  const months = <String>[
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
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}
