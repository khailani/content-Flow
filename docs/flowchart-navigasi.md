# Flowchart Navigasi ContentFlow

```mermaid
flowchart TD
    H[Beranda] -->|Daftar konten| L[Manajemen konten]
    H -->|Tambah konten| F[Form tambah]
    H -->|Pilih jadwal atau konten terbaru| D[Detail konten]
    L -->|Cari atau filter| L
    L -->|Pilih konten| D
    L -->|Tambah konten| F
    D -->|Ubah| E[Form ubah]
    D -->|Hapus, setelah konfirmasi| L
    F -->|Simpan valid| L
    F -->|Batal| L
    E -->|Simpan perubahan| D
    E -->|Batal| D
```

## Alur singkat

Beranda membuka daftar, jadwal, atau form tambah. Daftar dapat dicari dan difilter sebelum pengguna membuka detail. Detail menyediakan aksi ubah dan hapus. Form menolak penyimpanan jika judul atau nama klien kosong.
