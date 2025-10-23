import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/controller/users_controller.dart';
import 'package:my_app/data/models/users_model.dart';
import 'package:my_app/routes/app_routes.dart';
import 'package:my_app/screens/admin/manajemenpengguna/DetailPengguna.dart';

class DaftarPengguna extends StatelessWidget {
  const DaftarPengguna({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());

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

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Obx(() {
          if (controller.isLoading.value && controller.filteredUsers.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Daftar Pengguna",
                style: TextStyle(
                  fontFamily: "Primary",
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),

              // Tombol filter role
              Obx(
                () => Row(
                  children: [
                    _buildFilterButton(
                      "Semua",
                      controller.selectedRole.value == "Semua",
                      () => controller.filterByRole("Semua"),
                    ),
                    const SizedBox(width: 8),
                    _buildFilterButton(
                      "Admin",
                      controller.selectedRole.value == "Admin",
                      () => controller.filterByRole("Admin"),
                    ),
                    const SizedBox(width: 8),
                    _buildFilterButton(
                      "Kurir",
                      controller.selectedRole.value == "Kurir",
                      () => controller.filterByRole("Kurir"),
                    ),
                    const SizedBox(width: 8),
                    _buildFilterButton(
                      "Pelanggan",
                      controller.selectedRole.value == "Pelanggan",
                      () => controller.filterByRole("Pelanggan"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              // Daftar user + swipe refresh + pagination scroll bawah
              Expanded(
                child: RefreshIndicator(
                  onRefresh: controller.getUsers,
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (scrollInfo) {
                      if (scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent &&
                          !controller.isLoadMore.value &&
                          controller.currentPage.value <
                              controller.lastPage.value) {
                        controller.loadMoreUsers(); //pagination load more
                      }
                      return false;
                    },
                    child: Obx(() {
                      final users = controller.filteredUsers; // filter user

                      if (users.isEmpty) {
                        return ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: const [
                            SizedBox(height: 200),
                            Center(child: Text("Tidak ada pengguna")),
                          ],
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.only(bottom: 80),
                        itemCount:
                            users.length +
                            (controller.isLoadMore.value ? 1 : 0),
                        itemBuilder: (context, index) {
                          //Loader pagination di bawah
                          if (index == users.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          final UserModel user = users[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: InkWell(
                              onTap: () {
                                Get.to(() => Detailpengguna(userId: user.id));
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Card(
                                color: Colors.white,
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 25,
                                    backgroundImage: user.avatar != null
                                        ? NetworkImage(user.avatar!)
                                        : const AssetImage(
                                                "assets/images/image.png",
                                              )
                                              as ImageProvider,
                                  ),
                                  title: Text(
                                    user.name,
                                    style: const TextStyle(
                                      fontFamily: "Primary",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user.email,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        user.phone,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: Container(
                                    width: 90,
                                    height: 29,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      _capitalizeRole(user.role),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                        fontFamily: "Primary",
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ),
              ),
            ],
          );
        }),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AppRoutes.TambahPengguna);
        },
        backgroundColor: const Color(0xffF26D2B),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }

  // Widget tombol filter
  Widget _buildFilterButton(String text, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? const Color(0xffF26D2B) : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: "Primary",
            color: isActive ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  String _capitalizeRole(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return 'Admin';
      case 'courier':
        return 'Kurir';
      case 'customer':
        return 'Pelanggan';
      default:
        return role;
    }
  }
}
