from pathlib import Path

from docx import Document
from docx.enum.table import WD_CELL_VERTICAL_ALIGNMENT, WD_TABLE_ALIGNMENT
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.oxml import OxmlElement
from docx.oxml.ns import qn
from docx.shared import Inches, Pt, RGBColor


ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "docs"
GREEN = "205B4C"
PALE = "E7EFE8"
INK = "172F29"
GRAY = "61716A"
WHITE = "FFFFFF"


def shade(cell, fill):
    tc_pr = cell._tc.get_or_add_tcPr()
    shd = tc_pr.find(qn("w:shd"))
    if shd is None:
        shd = OxmlElement("w:shd")
        tc_pr.append(shd)
    shd.set(qn("w:fill"), fill)


def set_cell_text(cell, text, *, color=INK, bold=False, size=9.5, align=None):
    cell.text = ""
    cell.vertical_alignment = WD_CELL_VERTICAL_ALIGNMENT.CENTER
    p = cell.paragraphs[0]
    if align is not None:
        p.alignment = align
    p.paragraph_format.space_after = Pt(0)
    run = p.add_run(text)
    run.font.name = "Arial"
    run.font.size = Pt(size)
    run.font.bold = bold
    run.font.color.rgb = RGBColor.from_string(color)


def style_table(table, header=True):
    table.alignment = WD_TABLE_ALIGNMENT.CENTER
    table.autofit = True
    for row_index, row in enumerate(table.rows):
        for cell in row.cells:
            cell.margin_top = Inches(0.07)
            cell.margin_bottom = Inches(0.07)
            if header and row_index == 0:
                shade(cell, GREEN)
                for p in cell.paragraphs:
                    for run in p.runs:
                        run.font.color.rgb = RGBColor.from_string(WHITE)
                        run.font.bold = True
            elif row_index % 2 == 0:
                shade(cell, "F4F7F4")


def add_table(doc, headers, rows, widths=None):
    table = doc.add_table(rows=1, cols=len(headers))
    table.style = "Table Grid"
    for i, header in enumerate(headers):
        set_cell_text(table.rows[0].cells[i], header, color=WHITE, bold=True)
    for row in rows:
        cells = table.add_row().cells
        for i, value in enumerate(row):
            set_cell_text(cells[i], str(value))
    style_table(table)
    if widths:
        for row in table.rows:
            for i, width in enumerate(widths):
                row.cells[i].width = Inches(width)
    doc.add_paragraph().paragraph_format.space_after = Pt(2)
    return table


def new_doc(title, intro):
    doc = Document()
    section = doc.sections[0]
    section.top_margin = Inches(0.72)
    section.bottom_margin = Inches(0.72)
    section.left_margin = Inches(0.78)
    section.right_margin = Inches(0.78)

    normal = doc.styles["Normal"]
    normal.font.name = "Arial"
    normal.font.size = Pt(10.5)
    normal.font.color.rgb = RGBColor.from_string(INK)
    normal.paragraph_format.space_after = Pt(6)
    normal.paragraph_format.line_spacing = 1.12

    title_style = doc.styles["Title"]
    title_style.font.name = "Arial"
    title_style.font.size = Pt(23)
    title_style.font.bold = True
    title_style.font.color.rgb = RGBColor.from_string(INK)
    title_style.paragraph_format.space_after = Pt(5)
    title_style.paragraph_format.keep_with_next = True

    for style_name, size in (("Heading 1", 15), ("Heading 2", 11.5)):
        style = doc.styles[style_name]
        style.font.name = "Arial"
        style.font.size = Pt(size)
        style.font.bold = True
        style.font.color.rgb = RGBColor.from_string(GREEN)
        style.paragraph_format.space_before = Pt(12)
        style.paragraph_format.space_after = Pt(5)
        style.paragraph_format.keep_with_next = True

    p = doc.add_paragraph(style="Title")
    p.add_run(title)
    intro_p = doc.add_paragraph(intro)
    intro_p.paragraph_format.space_after = Pt(12)
    return doc


def bullet(doc, text):
    p = doc.add_paragraph(style="List Bullet")
    p.paragraph_format.space_after = Pt(3)
    p.add_run(text)
    return p


def save(doc, filename):
    path = OUT / filename
    doc.save(path)
    print(path)


def analysis_doc():
    doc = new_doc(
        "Analisis Masalah dan Rancangan Halaman ContentFlow",
        "Dokumen ini menjelaskan kebutuhan pengguna, rancangan empat halaman, alur data, dan batasan aplikasi manajemen konten digital.",
    )
    doc.add_heading("Latar belakang", level=1)
    doc.add_paragraph(
        "Kreasi Digital Consulting membantu klien merencanakan konten untuk Instagram, TikTok, Facebook, dan platform lain. Informasi konten tersebar di berbagai tempat sehingga staf kesulitan mencatat ide, memantau status pengerjaan, dan mengatur tanggal publikasi."
    )
    doc.add_paragraph(
        "ContentFlow menyatukan informasi tersebut dalam satu aplikasi. Pengguna dapat melihat rencana konten, membuka detail, dan melakukan perubahan tanpa database atau layanan eksternal."
    )
    doc.add_heading("Pengguna dan kebutuhan", level=1)
    doc.add_paragraph(
        "Pengguna utama adalah staf yang mengelola rencana konten untuk beberapa klien. Mereka membutuhkan ringkasan status, daftar yang mudah dicari, detail tiap rencana, serta form untuk mengelola data."
    )
    for text in [
        "Melihat jumlah konten dengan status Ide, Proses, Siap Terbit, dan Terbit.",
        "Mencari konten berdasarkan judul, klien, atau platform, lalu memfilter berdasarkan status.",
        "Menambah, melihat, mengubah, dan menghapus rencana konten.",
        "Menerima validasi jika judul atau nama klien belum diisi.",
    ]:
        bullet(doc, text)

    doc.add_heading("Rancangan halaman", level=1)
    add_table(
        doc,
        ["Halaman", "Isi dan tindakan"],
        [
            ("Beranda", "Jam dan tanggal lokal, jumlah konten per status, jadwal publikasi berikutnya, konten terbaru, dan akses ke daftar atau form tambah."),
            ("Manajemen konten", "Daftar rencana, pencarian judul/klien/platform, filter status, dan akses ke detail atau form tambah."),
            ("Detail konten", "Judul, klien, platform, tanggal publikasi, status, deskripsi, serta aksi ubah dan hapus dengan konfirmasi."),
            ("Form konten", "Input judul, nama klien, deskripsi, platform, status, dan tanggal publikasi. Judul dan nama klien wajib diisi."),
        ],
        widths=[1.45, 5.6],
    )
    doc.add_heading("Pengelolaan data", level=1)
    doc.add_paragraph(
        "Data contoh disimpan sebagai List<ContentPlan> di ContentStore. Setiap halaman memakai data yang dipilih melalui Navigator. Saat data berubah, ContentStore memberi tahu halaman agar daftar dan ringkasan ikut diperbarui."
    )
    doc.add_heading("Batasan aplikasi", level=1)
    doc.add_paragraph(
        "Aplikasi tidak memakai database, API, login, atau penyimpanan permanen. Perubahan hanya bertahan selama aplikasi berjalan. Setelah aplikasi ditutup, data kembali ke data contoh."
    )
    save(doc, "Analisis-dan-Rancangan-ContentFlow.docx")


def flow_doc():
    doc = new_doc(
        "Flowchart Navigasi ContentFlow",
        "Diagram ini menunjukkan perpindahan dari beranda ke daftar, detail, dan form serta hasil dari tindakan pengguna.",
    )
    doc.add_heading("Diagram utama", level=1)
    t = doc.add_table(rows=1, cols=1)
    t.style = "Table Grid"
    set_cell_text(t.cell(0, 0), "BERANDA\nJam, tanggal, ringkasan status, jadwal publikasi", color=WHITE, bold=True, size=11, align=WD_ALIGN_PARAGRAPH.CENTER)
    shade(t.cell(0, 0), GREEN)
    doc.add_paragraph("↓", style="Heading 1").alignment = WD_ALIGN_PARAGRAPH.CENTER
    add_table(
        doc,
        ["Manajemen konten", "Form tambah", "Detail konten"],
        [
            ("Cari dan filter daftar", "Isi informasi rencana", "Lihat detail yang dipilih"),
            ("Pilih konten untuk detail", "Simpan atau batalkan", "Ubah atau hapus"),
        ],
        widths=[2.35, 2.35, 2.35],
    )
    doc.add_heading("Rute navigasi", level=1)
    add_table(
        doc,
        ["Dari", "Tindakan", "Ke"],
        [
            ("Beranda", "Buka daftar konten", "Manajemen konten"),
            ("Beranda atau daftar", "Tambah konten", "Form tambah"),
            ("Beranda atau daftar", "Pilih konten", "Detail konten"),
            ("Detail konten", "Ubah", "Form ubah, lalu kembali ke detail"),
            ("Detail konten", "Hapus dan konfirmasi", "Kembali ke halaman sebelumnya"),
            ("Form tambah", "Simpan data valid", "Kembali ke daftar; konten baru tampil"),
        ],
        widths=[1.7, 2.5, 2.85],
    )
    doc.add_heading("Aturan form", level=1)
    doc.add_paragraph(
        "Form menolak penyimpanan jika judul konten atau nama klien kosong. Tombol Batal kembali tanpa menyimpan perubahan."
    )
    save(doc, "Flowchart-Navigasi-ContentFlow.docx")


def test_doc():
    doc = new_doc(
        "Rencana dan Hasil Pengujian ContentFlow",
        "Dokumen ini mencatat skenario untuk memeriksa tampilan, operasi data, filter, dan validasi. Status menunjukkan pengujian manual belum dijalankan.",
    )
    doc.add_heading("Lingkup pengujian", level=1)
    doc.add_paragraph(
        "Pengujian mencakup fitur yang diminta pada tugas Mobile Programming 2. Setiap skenario harus dijalankan pada aplikasi, lalu hasil aktual dicatat sebelum dokumen ini dikumpulkan sebagai laporan selesai."
    )
    add_table(
        doc,
        ["No.", "Fitur", "Langkah", "Hasil yang diharapkan", "Status"],
        [
            ("1", "Tampil", "Buka beranda dan daftar.", "Data contoh dan ringkasan status terlihat.", "Belum diuji"),
            ("2", "Tambah", "Isi judul dan klien, lalu simpan.", "Konten baru tampil dan hitungan berubah.", "Belum diuji"),
            ("3", "Ubah", "Ubah satu nilai pada konten terpilih.", "Hanya konten terpilih yang berubah.", "Belum diuji"),
            ("4", "Hapus", "Hapus konten dan setujui konfirmasi.", "Konten terpilih hilang dari daftar.", "Belum diuji"),
            ("5", "Filter", "Pilih status Proses.", "Hanya konten berstatus Proses tampil.", "Belum diuji"),
            ("6", "Validasi", "Kosongkan judul atau nama klien.", "Pesan validasi tampil dan data tidak disimpan.", "Belum diuji"),
        ],
        widths=[0.4, 0.8, 1.7, 2.7, 1.05],
    )
    doc.add_heading("Bukti screenshot", level=1)
    doc.add_paragraph(
        "Lampirkan screenshot beranda, daftar dengan filter, form, dan detail konten setelah bukti visual diambil dari aplikasi yang berjalan. Screenshot belum tersedia pada dokumen ini."
    )
    save(doc, "Hasil-Pengujian-ContentFlow.docx")


def presentation_doc():
    doc = new_doc(
        "Naskah Presentasi ContentFlow",
        "Naskah singkat ini membantu menjelaskan tujuan aplikasi, fitur utama, struktur kode, dan berkas yang dikumpulkan.",
    )
    sections = [
        ("Pembukaan", "Halo, saya akan menjelaskan aplikasi ContentFlow. Aplikasi ini membantu staf mengelola rencana konten digital untuk klien."),
        ("Beranda", "Beranda menampilkan hari, tanggal, dan jam lokal. Di bagian bawahnya ada jumlah konten per status, jadwal publikasi berikutnya, dan konten terbaru."),
        ("Daftar dan detail", "Pada halaman Manajemen Konten, pengguna dapat mencari berdasarkan judul, klien, atau platform, lalu memfilter berdasarkan status. Memilih sebuah konten akan membuka detail lengkapnya."),
        ("Operasi konten", "Dari halaman detail, pengguna dapat mengubah atau menghapus konten. Penghapusan meminta konfirmasi. Form tambah dan ubah memvalidasi judul dan nama klien."),
        ("Struktur kode", "main.dart menjalankan aplikasi dan tema. content_plan.dart mendefinisikan data, sedangkan content_store.dart mengelola List dan operasi tambah, ubah, hapus, serta hitung status. Setiap halaman memiliki file tersendiri di folder pages."),
        ("Batasan", "Data dikelola sementara selama aplikasi berjalan. Aplikasi tidak memakai database, API, atau login."),
        ("Berkas pengumpulan", "Berkas tugas mencakup analisis dan rancangan halaman, flowchart navigasi, source code Flutter, screenshot fitur utama, hasil pengujian, dan demonstrasi aplikasi. Hasil pengujian dan screenshot perlu dilengkapi dengan bukti aktual sebelum dikumpulkan."),
        ("Penutup", "Sekian penjelasan aplikasi ContentFlow. Terima kasih."),
    ]
    for heading, text in sections:
        doc.add_heading(heading, level=1)
        doc.add_paragraph(text)
    save(doc, "Naskah-Presentasi-ContentFlow.docx")


if __name__ == "__main__":
    OUT.mkdir(parents=True, exist_ok=True)
    analysis_doc()
    flow_doc()
    test_doc()
    presentation_doc()
