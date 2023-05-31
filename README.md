
# BIG DATA ANALYTICS PROJECT

<p>Tools : My SQL Workbench </p>
<p>Visualization : Looker Studio (<a href="https://lookerstudio.google.com/reporting/f7108010-d63e-4c9c-b010-46cc028a641a">Klik Disini</a>)</p>
<p>Dataset : <a href="https://docs.google.com/spreadsheets/d/1-6Xt7d4Pa_Pk0Vc7Dl2IjR8iDqbHVdmA/edit?usp=sharing&ouid=116627426136462261898&rtpof=true&sd=true">Klik Disini</a> </p>

## Project Introduction

<p> <strong>Big Data Analytics Project </strong> adalah proyek <em> Virtual Internship Experience </em> yang difasilitasi oleh Rakamin Academy. Dalam proyek ini, saya berperan sebagai Data Analyst Intern yang bertugas menganalisis dan membuat laporan penjualan perusahaan dengan menggunakan data yang tersedia. Dari proyek ini, saya juga belajar banyak tentang <em> Data Warehouse </em>, <em> Data Lake </em>, dan <em> Data Mart </em>.</p>

<br>

<strong> Objectives </strong>
<p> Adapun objective/target dari proyek ini yaitu:</p>
<ul>
  <li> Membuat design datamart (tabel base dan tabel aggregat) </li>
  <li> Membuat visualisasi/dashboard laporan penjualan perusahaan </li>
</ul>

<br>

<strong> Datasets </strong>
<p> Berikut ini adalah data yang dipakai dalam proyek ini:</p>
<ul>
  <li> Penjualan </li>
  <li> Pelanggan </li>
  <li> Barang </li>
</ul>

## Design Datamart
<strong> Tabel Base </strong>
<p>Tabel base adalah tabel yang berisi data asli atau data mentah yang dikumpulkan dari sumbernya dan berisi informasi yang dibutuhkan untuk menjawab pertanyaan atau menyeselasikan masalah tertentu. Tabel base dalam project ini dibuat dari gabungan tabel penjaulan, pelanggan, dan barang dengan primary key pada <code>invoice_id</code>.</p>

<details>
  <summary>Klik untuk melihat Query SQL</summary>
  
```sql
-- Membuat datamart base table penjualan
CREATE TABLE base_table (
SELECT
    pj.id_invoice,
    pj.tanggal,
    pj.id_customer,
    pl.nama,
    pj.id_distributor,
    pj.id_cabang,
    pl.cabang_sales,
    pl.id_group,
    pl.group,
    pj.id_barang,
    b.nama_barang,
    pj.brand_id,
    pj.lini,
    pj.jumlah_barang,
    b.kemasan,
    pj.harga,
    pj.mata_uang
FROM penjualan pj
LEFT JOIN pelanggan pl
	ON pl.id_customer = pj.id_customer
LEFT JOIN barang b
	ON b.kode_barang = pj.id_barang
ORDER BY pj.tanggal
);

-- Menentukan primary key
ALTER TABLE base_table ADD PRIMARY KEY(id_invoice);
```
  
</details>

![Deskripsi Gambar](path_ke_gambar)


<br>

<strong> Tabel Aggregat </strong>
<p>Tabel aggregat adalah tabel yang dibuat dengan mengumpulkan dan menghitung data dari tabel basis. Tabel aggregat ini berisi informasi yang lebih ringkas dan digunakan untuk menganalisis data lebih cepat dan efisien. Hasil tabel ini akan digunakan untuk sumber pembuatan dashboard laporan penjualan.</p>

<details>
  <summary>Klik untuk melihat Query SQL</summary>
  
```sql
-- Membuat datamart aggregat table penjualan
CREATE TABLE agg_table (
SELECT
    tanggal,
    MONTHNAME(tanggal) AS bulan,
    id_invoice,
    cabang_sales AS lokasi_cabang,
    nama AS pelanggan,
    nama_barang AS produk,
    lini AS merek,
    jumlah_barang AS jumlah_produk_terjual,
    harga AS harga_satuan,
    (jumlah_barang * harga) AS total_pendapatan
FROM base_table
ORDER BY 1, 4, 5, 6, 7, 8, 9, 10
);
```
  
</details>

## Data Visualization

