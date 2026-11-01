import 'package:flutter/material.dart';

import '../data/content_store.dart';
import '../models/content_plan.dart';

class FormContentPage extends StatefulWidget {
  const FormContentPage({super.key, required this.store, this.content});

  final ContentStore store;
  final ContentPlan? content;

  @override
  State<FormContentPage> createState() => _FormContentPageState();
}

class _FormContentPageState extends State<FormContentPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _clientController;
  late final TextEditingController _descriptionController;
  late String _platform;
  late String _status;
  late DateTime _publishDate;

  bool get _isEditing => widget.content != null;

  @override
  void initState() {
    super.initState();
    final content = widget.content;
    _titleController = TextEditingController(text: content?.title ?? '');
    _clientController = TextEditingController(text: content?.client ?? '');
    _descriptionController = TextEditingController(
      text: content?.description ?? '',
    );
    _platform = content?.platform ?? contentPlatforms.first;
    _status = content?.status ?? contentStatuses.first;
    _publishDate = content?.publishDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _clientController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Ubah konten' : 'Tambah konten')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
              children: [
                Text(
                  _isEditing ? 'Perbarui brief' : 'Brief konten baru',
                  style: const TextStyle(
                    color: Color(0xFF172F29),
                    fontSize: 24,
                    letterSpacing: -0.4,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _isEditing
                      ? 'Perubahan hanya diterapkan pada konten yang dipilih.'
                      : 'Lengkapi informasi berikut untuk menambahkan konten ke daftar.',
                  style: const TextStyle(
                    color: Color(0xFF71807A),
                    fontSize: 13,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 22),
                _FormPanel(
                  eyebrow: 'CONTENT BRIEF',
                  title: 'Informasi utama',
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _titleController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          labelText: 'Judul konten *',
                          hintText: 'Contoh: Tips produktif di pagi hari',
                          prefixIcon: Icon(Icons.title_rounded),
                        ),
                        validator: (value) => _required(value, 'Judul konten'),
                      ),
                      const SizedBox(height: 13),
                      TextFormField(
                        controller: _clientController,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'Nama klien *',
                          hintText: 'Contoh: Kopi Nusantara',
                          prefixIcon: Icon(Icons.business_outlined),
                        ),
                        validator: (value) => _required(value, 'Nama klien'),
                      ),
                      const SizedBox(height: 13),
                      TextFormField(
                        controller: _descriptionController,
                        textCapitalization: TextCapitalization.sentences,
                        minLines: 3,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: 'Deskripsi',
                          hintText:
                              'Catatan singkat tentang ide atau materi konten',
                          alignLabelWithHint: true,
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(bottom: 51),
                            child: Icon(Icons.notes_rounded),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _FormPanel(
                  eyebrow: 'DISTRIBUSI',
                  title: 'Jadwal & platform',
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        initialValue: _platform,
                        decoration: const InputDecoration(
                          labelText: 'Platform',
                          prefixIcon: Icon(Icons.public_rounded),
                        ),
                        items: contentPlatforms
                            .map(
                              (platform) => DropdownMenuItem<String>(
                                value: platform,
                                child: Text(platform),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) setState(() => _platform = value);
                        },
                      ),
                      const SizedBox(height: 13),
                      DropdownButtonFormField<String>(
                        initialValue: _status,
                        decoration: const InputDecoration(
                          labelText: 'Status konten',
                          prefixIcon: Icon(Icons.track_changes_rounded),
                        ),
                        items: contentStatuses
                            .map(
                              (status) => DropdownMenuItem<String>(
                                value: status,
                                child: Text(status),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) setState(() => _status = value);
                        },
                      ),
                      const SizedBox(height: 13),
                      _DateField(date: _publishDate, onTap: _chooseDate),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text('Batal'),
                      ),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      flex: 2,
                      child: FilledButton.icon(
                        onPressed: _save,
                        icon: const Icon(Icons.check_rounded),
                        label: const Text('Simpan konten'),
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
      ),
    );
  }

  String? _required(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label wajib diisi.';
    }
    return null;
  }

  Future<void> _chooseDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _publishDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Pilih tanggal publikasi',
      cancelText: 'Batal',
      confirmText: 'Pilih',
    );
    if (selected != null) {
      setState(() => _publishDate = selected);
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final draft = ContentPlan(
      id: widget.content?.id ?? 0,
      title: _titleController.text.trim(),
      client: _clientController.text.trim(),
      platform: _platform,
      status: _status,
      description: _descriptionController.text.trim(),
      publishDate: _publishDate,
    );
    final saved = _isEditing ? draft : widget.store.add(draft);
    if (_isEditing) widget.store.update(saved);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isEditing
              ? 'Perubahan konten disimpan.'
              : 'Konten berhasil ditambahkan.',
        ),
      ),
    );
    Navigator.pop(context, saved);
  }
}

class _FormPanel extends StatelessWidget {
  const _FormPanel({
    required this.eyebrow,
    required this.title,
    required this.child,
  });

  final String eyebrow;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
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
            eyebrow,
            style: const TextStyle(
              color: Color(0xFF527465),
              fontSize: 9,
              letterSpacing: 1.1,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF172F29),
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.date, required this.onTap});

  final DateTime date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFFD9E1DA)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.calendar_month_outlined,
                color: Color(0xFF65766F),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tanggal publikasi',
                      style: TextStyle(color: Color(0xFF71807A), fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatDate(date),
                      style: const TextStyle(
                        color: Color(0xFF18342F),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.expand_more, color: Color(0xFF71807A)),
            ],
          ),
        ),
      ),
    );
  }
}
