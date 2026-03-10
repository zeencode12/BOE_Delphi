<?php

header("Content-Type: application/json");

// koneksi database
$host = "localhost";
$user = "root";
$pass = "";
$db   = "kasir";

$conn = new mysqli($host, $user, $pass, $db);

// cek koneksi
if ($conn->connect_error) {
    echo json_encode([
        "status" => "error",
        "message" => "Koneksi gagal"
    ]);
    exit;
}

// ambil data JSON dari Delphi
$data = json_decode(file_get_contents("php://input"), true);

if (!$data) {
    echo json_encode([
        "status" => "error",
        "message" => "Data JSON tidak diterima"
    ]);
    exit;
}

// ambil data transaksi
$total   = $data["total"];
$bayar   = $data["bayar"];
$kembali = $data["kembali"];
$menu    = $data["menu"];

// simpan ke tabel transaksi
$sql = "INSERT INTO transaksi (total, bayar, kembali)
        VALUES ('$total','$bayar','$kembali')";

if ($conn->query($sql) === TRUE) {

    $id_transaksi = $conn->insert_id;

    // simpan detail menu
    foreach ($menu as $item) {

        $nama     = $item["nama"];
        $harga    = $item["harga"];
        $qty      = $item["qty"];
        $subtotal = $item["subtotal"];

        $sql_detail = "INSERT INTO detail_transaksi
        (id_transaksi, nama_menu, harga, qty, subtotal)
        VALUES
        ('$id_transaksi','$nama','$harga','$qty','$subtotal')";

        $conn->query($sql_detail);
    }

    echo json_encode([
        "status" => "sukses",
        "message" => "Transaksi berhasil disimpan",
        "id_transaksi" => $id_transaksi
    ]);

} else {

    echo json_encode([
        "status" => "error",
        "message" => "Gagal menyimpan transaksi"
    ]);

}

$conn->close();

?>