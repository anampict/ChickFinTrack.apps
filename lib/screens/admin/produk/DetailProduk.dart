import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:my_app/controller/product_controller.dart';
import 'package:my_app/controller/stock_controller.dart';
import 'package:my_app/data/models/product_model.dart';
import 'package:my_app/helper/utils.dart';

class DetailProduk extends StatefulWidget {
  const DetailProduk({super.key});

  @override
  State<DetailProduk> createState() => _DetailProdukState();
}

class _DetailProdukState extends State<DetailProduk> {
  late final int productId;
  late final ProductController productController;
  late final StockController stockController;

  @override
  void initState() {
    super.initState();
    productId = Get.arguments as int;
    productController = Get.find<ProductController>();
    stockController = Get.put(StockController());

    // Ambil data stok
    stockController.fetchStock(productId);
  }

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    // Ambil produk
    final ProductModel product = productController.products.firstWhere(
      (p) => p.id == productId,
      orElse: () => throw Exception('Produk tidak ditemukan'),
    );

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

      // RefreshIndicator hanya untuk refresh manual
      body: RefreshIndicator(
        onRefresh: () async {
          await stockController.fetchStock(productId);
          await productController.getProducts();
        },
        child: Obx(() {
          // Saat pertama kali load data stok
          if (stockController.isLoading.value &&
              stockController.stockList.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Breadcrumb
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
                                const Text(
                                  "Stok Saat Ini",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 11,
                                    fontFamily: "Primary",
                                  ),
                                ),
                                Obx(
                                  () => Text(
                                    productController.products
                                        .firstWhere((p) => p.id == productId)
                                        .stock
                                        .toString(),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Primary",
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
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

                //DETAIL PRODUK
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Detail Produk",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
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

                //RIWAYAT STOK
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
                        ],
                      ),
                      const SizedBox(height: 8),
                      Obx(() {
                        if (stockController.isLoading.value &&
                            stockController.stockList.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        if (stockController.stockList.isEmpty) {
                          return const Text('Belum ada riwayat stok');
                        }
                        return Column(
                          children: stockController.stockList.map((s) {
                            final isRestock = s.changeType == 'restock';
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
                                      '${isRestock ? "Restock" : "Terjual"} ${s.quantityChange > 0 ? "+${s.quantityChange}" : s.quantityChange}',
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
                                        s.notes ?? '-',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    formatDate(s.createdAt),
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          );
        }),
      ),

      // Tombol tambah stok
      floatingActionButton: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffF26D2B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
        onPressed: () =>
            showTambahStokDialog(context, productId, product.stock),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "TAMBAH STOK",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  //Komponen kecil
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
void showTambahStokDialog(
  BuildContext context,
  int productId,
  int stokSaatIni,
) {
  final TextEditingController stokDitambahkanController =
      TextEditingController();
  final TextEditingController alasanController = TextEditingController();
  final TextEditingController catatanController = TextEditingController();

  final StockController stockController = Get.find<StockController>();

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

              Text(
                "Stok saat ini: $stokSaatIni pcs",
                style: const TextStyle(fontSize: 13),
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
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffF26D2B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () async {
                        final qty =
                            int.tryParse(stokDitambahkanController.text) ?? 0;
                        if (qty <= 0) return;

                        final success = await stockController.addStock(
                          productId,
                          qty,
                          catatanController.text,
                        );

                        if (success) {
                          Get.back(); // tutup dialog
                        }
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
                      onPressed: () => Get.back(),
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
