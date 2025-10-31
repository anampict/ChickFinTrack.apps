import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:my_app/controller/category_controller.dart';
import 'package:my_app/data/models/category_model.dart';
import 'package:my_app/data/repositories/category_repository.dart';
import 'package:my_app/routes/app_routes.dart';
import 'package:my_app/screens/admin/produk/TambahKategori.dart';

class Daftarkategoriproduk extends StatelessWidget {
  const Daftarkategoriproduk({super.key});

  void _hapusKategori(CategoryModel category) {
    Get.dialog(
      AlertDialog(
        title: const Text(
          "Konfirmasi Hapus",
          style: TextStyle(fontSize: 16, fontFamily: "Primary"),
        ),
        content: Text(
          "Apakah Anda yakin ingin menghapus kategori '${category.name}'?",
          style: const TextStyle(fontSize: 14, fontFamily: "Primary"),
        ),
        actions: [
          // Tombol Batal
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              "Batal",
              style: TextStyle(color: Colors.grey, fontFamily: "Primary"),
            ),
          ),
          // Tombol Hapus
          TextButton(
            onPressed: () async {
              final controller = Get.find<CategoryController>();
              Get.back(); // Tutup dialog konfirmasi

              try {
                await controller.deleteCategory(category.id);
                Get.snackbar(
                  "Sukses",
                  "Kategori '${category.name}' berhasil dihapus",
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(12),
                  borderRadius: 10,
                );
              } catch (e) {
                Get.snackbar(
                  "Gagal",
                  "Gagal menghapus kategori: $e",
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.redAccent,
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(12),
                  borderRadius: 10,
                );
              }
            },
            child: const Text(
              "Hapus",
              style: TextStyle(color: Colors.red, fontFamily: "Primary"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
      body: GetX<CategoryController>(
        builder: (controller) {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.categories.isEmpty) {
            return const Center(child: Text("Tidak ada kategori"));
          }

          return RefreshIndicator(
            onRefresh: controller.fetchCategories,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 8, left: 4),
                  child: Text(
                    "Kategori",
                    style: TextStyle(
                      fontFamily: "Primary",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // Daftar kategori
                ...List.generate(controller.categories.length, (index) {
                  final category = controller.categories[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6, top: 10),
                    child: Card(
                      elevation: 2,
                      color: Colors.white,
                      child: SizedBox(
                        height: 80,
                        child: Row(
                          children: [
                            Card(
                              color: const Color(0xffFFB02E),
                              child: SizedBox(
                                width: 60,
                                height: 60,
                                child: Center(
                                  child: SvgPicture.asset(
                                    "assets/icons/kategoriproduk.svg",
                                    width: 39,
                                    height: 39,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Text(
                              category.name ?? '',
                              style: const TextStyle(
                                fontFamily: "Second",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () => _hapusKategori(category),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: SvgPicture.asset(
                                  "assets/icons/hapus.svg",
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(
                                  () => Tambahkategori(category: category),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: SvgPicture.asset(
                                  "assets/icons/edit.svg",
                                  width: 24,
                                  height: 24,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          Get.toNamed(AppRoutes.TambahKategori);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
