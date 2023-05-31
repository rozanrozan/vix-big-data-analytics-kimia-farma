/*
Author: Rozan
Date: 01/04/2023
Tool used: MySQL Workbench 
*/

/*
--------------------------
CREATE DATABASE DAN TABEL
--------------------------
*/

-- Membuat schema database
CREATE SCHEMA projek_kimfar;
USE projek_kimfar;

-- Membuat tabel 
-- Tabel penjualan
CREATE TABLE `projek_kimfar`.`penjualan` (
  `id_distributor` VARCHAR(45) NOT NULL,
  `id_cabang` VARCHAR(45) NULL,
  `id_invoice` VARCHAR(45) NOT NULL,
  `tanggal` VARCHAR(45) NULL,
  `id_customer` VARCHAR(45) NULL,
  `id_barang` VARCHAR(45) NULL,
  `jumlah_barang` INT NULL,
  `unit` VARCHAR(45) NULL,
  `harga` DECIMAL(45) NULL,
  `mata_uang` VARCHAR(45) NULL,
  `brand_id` VARCHAR(45) NULL,
  `lini` VARCHAR(45) NULL,
  PRIMARY KEY (`id_invoice`));
  
-- tabel pelanggan
CREATE TABLE `projek_kimfar`.`pelanggan` (
  `id_customer` VARCHAR(45) NOT NULL,
  `level` VARCHAR(45) NULL,
  `nama` VARCHAR(45) NULL,
  `id_cabang_sales` VARCHAR(45) NULL,
  `cabang_sales` VARCHAR(45) NULL,
  `id_group` VARCHAR(45) NULL,
  `group` VARCHAR(45) NULL,
  PRIMARY KEY (`id_customer`));

-- Tabel barang
CREATE TABLE `projek_kimfar`.`barang` (
  `kode_barang` VARCHAR(45) NOT NULL,
  `sektor` VARCHAR(45) NULL,
  `nama_barang` VARCHAR(45) NULL,
  `tipe` VARCHAR(45) NULL,
  `nama_tipe` VARCHAR(45) NULL,
  `kode_lini` VARCHAR(45) NULL,
  `lini` VARCHAR(45) NULL,
  `kemasan` VARCHAR(45) NULL,
  PRIMARY KEY (`kode_barang`));

/*
-- setelah membuat database dan tabel lalu melakukan import dataset
1. Select tabel, next
2. Klik pada icon import record from an external file, next
3. Select file to import, next
4. Centang use existing tabel dan truncate table before import, pastikan nama tabel sesuai, next
5. Pastikan nama kolom sesuai, next
6. Klik next pada import data
*/

-- Update tipe data date dari varchar pada kolom tanggal
SET SQL_SAFE_UPDATES = 0;
update penjualan set tanggal = str_to_date(tanggal, "%d/%m/%Y");
ALTER TABLE penjualan CHANGE COLUMN tanggal tanggal DATE;

/*
--------------------------
MEMBUAT TABEL BASE
--------------------------
*/

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
WHERE
	pj.lini = "SLCYL"
ORDER BY pj.tanggal
);

-- Menentukan primary key
ALTER TABLE base_table ADD PRIMARY KEY(id_invoice);

/*
--------------------------
MEMBUAT TABEL AGGREGAT
--------------------------
*/

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