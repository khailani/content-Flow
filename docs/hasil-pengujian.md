# Hasil Pengujian ContentFlow

Pengujian dilakukan pada aplikasi Flutter yang berjalan di browser. Jalankan skenario berikut dari beranda. Hasil akhir tiap langkah dicatat setelah pengujian manual.

| No. | Fitur | Langkah ringkas | Hasil yang diharapkan | Hasil |
| --- | --- | --- | --- | --- |
| 1 | Tampil | Buka beranda dan daftar konten. | Data contoh, ringkasan status, dan daftar konten tampil. | Menunggu pengujian |
| 2 | Tambah | Tambahkan konten dengan judul dan klien valid. | Konten baru muncul pada daftar dan hitungan diperbarui. | Menunggu pengujian |
| 3 | Ubah | Buka detail konten, ubah satu nilai, lalu simpan. | Nilai baru tampil pada konten yang dipilih. | Menunggu pengujian |
| 4 | Hapus | Hapus konten dari detail dan konfirmasi. | Konten hilang dari daftar setelah konfirmasi. | Menunggu pengujian |
| 5 | Filter | Pilih salah satu filter status. | Hanya konten dengan status terpilih yang tampil. | Menunggu pengujian |
| 6 | Validasi | Kosongkan judul atau nama klien lalu tekan Simpan. | Form menampilkan pesan wajib diisi dan tidak menyimpan data. | Menunggu pengujian |

## Bukti screenshot

- Beranda: `screenshots/01-beranda.png`
- Daftar dan filter: `screenshots/02-daftar-filter.png`
- Form konten: `screenshots/03-form-konten.png`
- Detail konten: `screenshots/04-detail-konten.png`
