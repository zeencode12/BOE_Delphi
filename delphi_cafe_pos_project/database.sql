CREATE DATABASE cafe_pos;

USE cafe_pos;

CREATE TABLE transaksi (
id_transaksi INT AUTO_INCREMENT PRIMARY KEY,
tanggal DATETIME,
total INT
);