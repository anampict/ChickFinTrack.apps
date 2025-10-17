import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:my_app/controller/product_controller.dart';
import 'package:my_app/data/models/product_model.dart';
import 'package:my_app/helper/utils.dart';

class DetailProduk extends StatelessWidget {
  const DetailProduk({super.key});

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final int productId = Get.arguments as int;
    final ProductController controller = Get.find<ProductController>();
    // Ambil data produk dari controller
    final ProductModel product = controller.products.firstWhere(
      (p) => p.id == productId,
      orElse: () => throw Exception('Produk tidak ditemukan'),
    );
    final riwayatStok = [
      {"aksi": "Terjual -1", "admin": "Admin", "tanggal": "10/10/2025 03:57"},
      {"aksi": "Terjual -2", "admin": "Admin", "tanggal": "10/10/2025 03:57"},
      {"aksi": "Restock +10", "admin": "Admin", "tanggal": "10/10/2025 03:57"},
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage("assets/images/image.png"),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Selamat Malam",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 9,
                    fontFamily: "Primary",
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  "Admin RPA",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 9,
                    fontFamily: "Primary",
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.mail, color: Colors.white),
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xffF26D2B),
                shape: const CircleBorder(),
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Text(
                  "Produk",
                  style: TextStyle(
                    fontFamily: "Primary",
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 3),
                Icon(Icons.chevron_right, color: Colors.grey),
                SizedBox(width: 3),
                Text(
                  "Detail",
                  style: TextStyle(
                    fontFamily: "Primary",
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // INFORMASI PRODUK
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Informasi Produk",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      SvgPicture.asset("assets/icons/edit.svg", height: 20),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Gambar Produk
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: product.imageUrl != null
                            ? Image.network(
                                product.imageUrl!,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                "assets/images/fotoproduk.png",
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                      ),
                      const SizedBox(width: 10),

                      // Nama Produk + Harga
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                fontFamily: "Primary",
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Stok Saat Ini",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 11,
                                fontFamily: "Primary",
                              ),
                            ),
                            Text(
                              product.stock.toString(),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Primary",
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Harga",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 11,
                                fontFamily: "Primary",
                              ),
                            ),
                            Text(
                              formatRupiah(product.price),
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Deskripsi
                      Expanded(
                        flex: 3,
                        child: Text(
                          product.description ?? "-",
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // DETAIL PRODUK
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Detail Produk",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  _detailRow("SKU", product.sku),
                  _labelRow(
                    "Kategori",
                    product.category?.name ?? "-",
                    Colors.red.shade100,
                    Colors.red.shade800,
                  ),
                  _labelRow(
                    "Status",
                    product.isActive ? "Aktif" : "Nonaktif",
                    Colors.green.shade100,
                    Colors.green.shade800,
                  ),
                  _detailRow("Berat", "${product.weight ?? 0} gr"),
                  _detailRow("Dibuat", formatDate(product.createdAt)),
                  _detailRow("Diperbarui", formatDate(product.updatedAt)),
                ],
              ),
            ),

            const SizedBox(height: 12),

            //  RIWAYAT STOK
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Text(
                        "Riwayat Stok",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "Total Stok: 52 pcs",
                        style: TextStyle(color: Colors.black87, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Column(
                    children: riwayatStok.map((r) {
                      final isRestock = r["aksi"]!.toLowerCase().contains(
                        "restock",
                      );
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isRestock
                                    ? Colors.green[50]
                                    : Colors.red[50],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                r["aksi"]!,
                                style: TextStyle(
                                  color: isRestock
                                      ? Colors.green
                                      : Colors.redAccent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 25),
                            Expanded(
                              child: Center(
                                child: Text(
                                  r["admin"]!,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                            Text(
                              r["tanggal"]!,
                              style: const TextStyle(fontSize: 11),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),

      floatingActionButton: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffF26D2B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
        onPressed: () => showTambahStokDialog(context),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "TAMBAH STOK",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  //  COMPONENT KECIL
  static Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  static Widget _detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _labelRow(
    String title,
    String value,
    Color bgColor,
    Color textColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 11,
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// dialog tambah stok
void showTambahStokDialog(BuildContext context) {
  final TextEditingController stokSaatIniController = TextEditingController();
  final TextEditingController stokDitambahkanController =
      TextEditingController();
  final TextEditingController alasanController = TextEditingController();
  final TextEditingController catatanController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Tambah Stok Produk",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  fontFamily: "Primary",
                ),
              ),
              const SizedBox(height: 16),
              _inputField(
                "Stok saat ini",
                stokSaatIniController,
                inputType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              _inputField(
                "Stok yang ditambahkan",
                stokDitambahkanController,
                inputType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              _inputField("Alasan", alasanController),
              const SizedBox(height: 10),
              _inputField("Catatan", catatanController, maxLines: 3),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: 80,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffF26D2B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Restock",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Batal",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _inputField(
  String label,
  TextEditingController controller, {
  int maxLines = 1,
  TextInputType inputType = TextInputType.text,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
          fontFamily: "Primary",
        ),
      ),
      const SizedBox(height: 6),
      Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(8),
        shadowColor: Colors.black.withOpacity(0.1),
        child: TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: inputType,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
          ),
        ),
      ),
    ],
  );
}
