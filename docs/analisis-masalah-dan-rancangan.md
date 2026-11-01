# Analisis Masalah dan Rancangan Halaman

## Latar belakang

Kreasi Digital Consulting mengelola rencana konten untuk beberapa klien dan platform. Informasi judul, klien, platform, status, deskripsi, dan tanggal publikasi perlu mudah dilihat dan diperbarui. ContentFlow menyatukan informasi tersebut dalam aplikasi Flutter sederhana.

## Pengguna dan kebutuhan

Pengguna utama adalah staf yang merencanakan konten untuk klien. Pengguna perlu:

- melihat jumlah konten dan ringkasan status;
- mencari serta memfilter rencana konten;
- membuka detail konten yang dipilih;
- menambah, mengubah, dan menghapus rencana;
- mendapat validasi saat judul atau nama klien belum diisi.

## Rancangan halaman

| Halaman | Informasi dan aksi |
| --- | --- |
| Beranda | Jam dan tanggal lokal, jumlah konten menurut status, jadwal publikasi berikutnya, dan konten terbaru. Tombol menuju daftar dan form tambah. |
| Manajemen konten | Daftar rencana, pencarian judul/klien/platform, filter status, dan aksi buka detail atau tambah konten. |
| Detail konten | Judul, klien, platform, tanggal publikasi, status, deskripsi, serta aksi ubah dan hapus. Penghapusan meminta konfirmasi. |
| Form konten | Input judul, klien, deskripsi, platform, status, dan tanggal publikasi. Judul dan klien wajib diisi. |

## Alur data

Data contoh disiapkan di `ContentStore` sebagai `List<ContentPlan>`. Halaman memakai objek konten yang dipilih saat membuka detail atau form ubah. Perubahan daftar memberi tahu halaman yang sedang aktif agar ringkasan dan daftar diperbarui. Data hanya berada di memori selama aplikasi berjalan.

## Batasan

Aplikasi tidak memakai database, API, login, atau penyimpanan permanen. Data akan kembali ke contoh awal setelah aplikasi ditutup dan dibuka lagi.
