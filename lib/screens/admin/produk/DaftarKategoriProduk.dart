import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:my_app/controller/category_controller.dart';
import 'package:my_app/routes/app_routes.dart';
import 'package:my_app/screens/admin/produk/TambahKategori.dart';

class Daftarkategoriproduk extends StatelessWidget {
  const Daftarkategoriproduk({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            // Foto Profil
            const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(
                "assets/images/image.png", // contoh foto online
              ),
            ),
            const SizedBox(width: 10),

            // Teks Salam + Nama
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
            padding: const EdgeInsets.only(right: 12), // kasih jarak ke kanan
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.mail, color: Colors.white),
              style: IconButton.styleFrom(
                backgroundColor: Color(0xffF26D2B),
                shape: CircleBorder(),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 17, left: 20),
            child: Text(
              "Kategori",
              style: const TextStyle(
                fontFamily: "Primary",
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),

          const SizedBox(height: 10),

          //Bagian List dinamis pakai Expanded agar scrollable
          Expanded(
            child: GetX<CategoryController>(
              builder: (controller) {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.categories.isEmpty) {
                  return const Center(child: Text("Tidak ada kategori"));
                }

                return RefreshIndicator(
                  onRefresh: controller.fetchCategories, // 🌀 refresh data
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: controller.categories.length,
                    itemBuilder: (context, index) {
                      final category = controller.categories[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
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
                                  category.name,
                                  style: const TextStyle(
                                    fontFamily: "Second",
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Spacer(),
                                InkWell(
                                  onTap: () {
                                    Get.to(
                                      () => Tambahkategori(
                                        category:
                                            category, // kirim data ke form edit
                                      ),
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
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // Tambahkan FAB di bawah kanan
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          Get.toNamed(AppRoutes.TambahKategori);
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
