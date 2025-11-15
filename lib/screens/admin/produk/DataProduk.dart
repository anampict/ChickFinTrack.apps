import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_app/controller/product_controller.dart';
import 'package:my_app/helper/utils.dart';
import 'package:my_app/routes/app_routes.dart';
import 'package:my_app/screens/admin/produk/TambahProduk.dart';

class Dataproduk extends StatelessWidget {
  const Dataproduk({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductController controller = Get.find<ProductController>();

    return Scaffold(
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
                  "Selamat Datang",
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
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.products.isEmpty) {
          return RefreshIndicator(
            onRefresh:
                controller.getProducts, // ✅ tetap bisa refresh walau kosong
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 200),
                Center(
                  child: Text(
                    "Tidak ada produk",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.getProducts,
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent &&
                  !controller.isLoadMore.value &&
                  controller.currentPage.value < controller.lastPage.value) {
                controller.loadMoreProducts();
              }
              return false;
            },
            child: Obx(() {
              if (controller.isLoading.value && controller.products.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.products.isEmpty) {
                return const Center(child: Text('Tidak ada produk'));
              }

              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount:
                    controller.products.length +
                    (controller.isLoadMore.value
                        ? 1
                        : 0), // Tambah 1 buat loader bawah
                itemBuilder: (context, index) {
                  // Loader saat pagination
                  if (index == controller.products.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final product = controller.products[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                    child: CardProduk(
                      namaProduk: product.name,
                      kategori: product.category?.name ?? "-",
                      stok: product.stock,
                      harga: formatRupiah(product.price),
                      isActive: product.isActive,
                      imagePath:
                          product.imageUrl ?? "assets/images/fotoproduk.png",
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.DetailProduk,
                          arguments: product.id,
                        );
                      },
                      onEdit: () {
                        Get.to(() => TambahProduk(product: product));
                      },
                      onDelete: () {
                        Get.dialog(
                          AlertDialog(
                            title: const Text(
                              "Konfirmasi Hapus",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Primary",
                              ),
                            ),
                            content: const Text(
                              "Apakah Anda yakin ingin menghapus produk ini?",
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Primary",
                              ),
                            ),
                            actions: [
                              // Tombol Batal
                              TextButton(
                                onPressed: () => Get.back(),
                                child: const Text(
                                  "Batal",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: "Primary",
                                  ),
                                ),
                              ),
                              // Tombol Hapus
                              TextButton(
                                onPressed: () {
                                  Get.back(); // Tutup dialog
                                  controller.deleteProduct(product.id);
                                },
                                child: const Text(
                                  "Hapus",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontFamily: "Primary",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          Get.toNamed(AppRoutes.TambahProduk);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// ================== CARD PRODUK ====================
class CardProduk extends StatelessWidget {
  final String namaProduk;
  final String kategori;
  final int stok;
  final String harga;
  final String imagePath;
  final bool isActive;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const CardProduk({
    super.key,
    required this.namaProduk,
    required this.kategori,
    required this.stok,
    required this.harga,
    required this.isActive,
    required this.imagePath,
    this.onEdit,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(
        12,
      ), // biar efek ripple ngikutin bentuk card
      child: Card(
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar produk
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: imagePath.startsWith('http')
                    ? Image.network(
                        imagePath,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        imagePath,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(width: 12),

              // Detail produk
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama + Tombol edit
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            namaProduk,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Primary",
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        InkWell(
                          onTap: onDelete,
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: onEdit,
                          child: SvgPicture.asset("assets/icons/edit.svg"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Stok & Kategori
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xffF0F0F0),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/stok.svg',
                                width: 10,
                                height: 10,
                                colorFilter: const ColorFilter.mode(
                                  Color(0xff5B5B5B),
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "Stok: $stok",
                                style: const TextStyle(
                                  fontSize: 9,
                                  fontFamily: "Primary",
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xffF0F0F0),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "Kategori: $kategori",
                            style: const TextStyle(
                              fontSize: 9,
                              fontFamily: "Primary",
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Harga & Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          harga,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Row(
                          children: [
                            const Text(
                              "Status: ",
                              style: TextStyle(fontSize: 12),
                            ),
                            Icon(
                              isActive ? Icons.check_circle : Icons.cancel,
                              color: isActive ? Colors.green : Colors.red,
                              size: 18,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
