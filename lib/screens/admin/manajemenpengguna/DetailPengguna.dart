import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/controller/users_controller.dart';
import 'package:my_app/helper/utils.dart';

class Detailpengguna extends StatelessWidget {
  final int userId;
  const Detailpengguna({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());

    // panggil data detail user ketika halaman dibuka
    userController.getUserDetail(userId);

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
      body: Obx(() {
        if (userController.isDetailLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = userController.userDetail.value;
        if (user == null) {
          return const Center(child: Text("Data pengguna tidak ditemukan"));
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumb dan tombol edit
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Pengguna",
                        style: TextStyle(
                          fontFamily: "Primary",
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 3),
                      const Icon(Icons.chevron_right, color: Colors.grey),
                      const SizedBox(width: 3),
                      Text(
                        "Detail",
                        style: const TextStyle(
                          fontFamily: "Primary",
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 55,
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffF26D2B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text(
                        "Edit",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Primary",
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Card detail
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Informasi Pengguna",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: "Primary",
                          fontSize: 14,
                        ),
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _InfoItem(title: "Nama", value: user.name ?? "-"),
                              _InfoItem(
                                title: "Alamat Email",
                                value: user.email ?? "-",
                              ),
                              _InfoItem(
                                title: "Peran",
                                value: user.role ?? "-",
                              ),

                              _InfoItem(
                                title: "Dibuat pada",
                                value: formatTanggal(user.createdAt),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _InfoItem(
                                title: "Nama Warung",
                                value: user.otherName ?? "Tidak ada",
                              ),
                              _InfoItem(
                                title: "Telepon",
                                value: user.phone ?? "-",
                              ),
                              // _InfoItem(title: "Email Terverifikasi Pada", value: user.updatedAt ?? "-"),
                              _InfoItem(
                                title: "Diperbarui pada",
                                value: formatTanggal(user.updatedAt),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String title;
  final String value;
  const _InfoItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: "Primary",
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              fontFamily: "Primary",
            ),
          ),
        ],
      ),
    );
  }
}
