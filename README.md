# ContentFlow

ContentFlow adalah aplikasi Flutter sederhana untuk membantu tim konsultasi digital mengelola rencana konten klien.

## Fitur

- Beranda menampilkan jumlah semua konten dan jumlah per status.
- Daftar konten menampilkan judul, klien, platform, tanggal publikasi, dan status.
- Pencarian berdasarkan judul, klien, atau platform.
- Filter status: Ide, Proses, Siap Terbit, dan Terbit.
- Detail konten menampilkan seluruh informasi dan deskripsi.
- Tambah, ubah, dan hapus konten; penghapusan meminta konfirmasi.
- Validasi wajib untuk judul konten dan nama klien.
- Pesan kondisi kosong ditampilkan jika belum ada konten atau hasil filter.

## Alur navigasi

```mermaid
flowchart TD
    A[Beranda] --> B[Daftar konten]
    A --> D[Form tambah]
    B --> C[Detail konten]
    B --> D
    C --> E[Form ubah]
    C -->|Hapus setelah konfirmasi| B
    D -->|Simpan atau batal| B
    E -->|Simpan atau batal| C
```

## Data dan batasan

Data contoh dimuat langsung di `ContentStore`. Perubahan dikelola dalam `List` selama aplikasi berjalan dan tidak disimpan setelah aplikasi ditutup. Aplikasi tidak menggunakan API, database, maupun login.

## Menjalankan aplikasi

```sh
flutter pub get
flutter run
```
