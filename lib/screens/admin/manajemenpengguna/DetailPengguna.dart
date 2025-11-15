import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_app/controller/order_controller.dart';
import 'package:my_app/controller/users_controller.dart';
import 'package:my_app/helper/utils.dart';
import 'package:my_app/routes/app_routes.dart';
import 'package:my_app/screens/admin/buatpesanan/DetailPesanan.dart';
import 'package:my_app/screens/admin/manajemenpengguna/TambahAlamat.dart';

class Detailpengguna extends StatelessWidget {
  final int userId;
  const Detailpengguna({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());

    // panggil data detail user ketika halaman dibuka
    userController.getUserDetail(userId);
    print('Memuat detail pengguna dengan ID: $userId');

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
        if (userController.isDetailLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = userController.userDetail.value;
        if (user == null) {
          return const Center(child: Text("Data pengguna tidak ditemukan"));
        }

        return SingleChildScrollView(
          child: Padding(
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
                      width: 120,
                      height: 30,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.toNamed(
                            AppRoutes.DashboardKeuangan,
                            arguments: {
                              'userId': userId,
                            }, // userId dari parameter class
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xff009BEE,
                          ), // warna biru
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // SVG icon (nanti kamu ganti path-nya)
                            SvgPicture.asset(
                              'assets/icons/uang.svg',
                              width: 18,
                              height: 18,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              "Keuangan",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Primary",
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      width: 55,
                      height: 30,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.toNamed(
                            AppRoutes.TambahPengguna,
                            arguments: {'user': user},
                          )!.then((_) {
                            userController.getUserDetail(user.id);
                          });
                        },
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
                  color: Colors.white,
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
                                _InfoItem(
                                  title: "Nama",
                                  value: user.name ?? "-",
                                ),
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
                Padding(
                  padding: const EdgeInsets.only(top: 26),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DefaultTabController(
                        length: 2,
                        child: Column(
                          children: [
                            // === TAB BAR ===
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: TabBar(
                                dividerColor: Colors.transparent,
                                labelColor: Colors.white,
                                unselectedLabelColor: Colors.black54,
                                indicatorSize: TabBarIndicatorSize.tab,
                                indicator: BoxDecoration(
                                  color: const Color(0xffF26D2B),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                tabs: const [
                                  Tab(text: "Alamat"),
                                  Tab(text: "Pesanan"),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // === TAB VIEW ===
                            SizedBox(
                              height: 400, // biar ada area scroll
                              child: TabBarView(
                                children: [
                                  // ---------------- Tab Alamat ----------------
                                  _AlamatTab(),

                                  // ---------------- Tab Pesanan ----------------
                                  _PesananTab(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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

// ============ TAB ALAMAT ============
class _AlamatTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Daftar Alamat",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                fontFamily: "Primary",
                color: Colors.black,
              ),
            ),
            InkWell(
              onTap: () {
                final userController = Get.find<UserController>();
                final user = userController.userDetail.value;
                if (user != null) {
                  Get.toNamed(
                    AppRoutes.TambahAlamat,
                    arguments: {'userId': user.id},
                  );
                }
              },

              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xffF26D2B),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text(
                  "Tambah",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Primary",
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        Expanded(
          child: Obx(() {
            final user = userController.userDetail.value;

            if (user == null || user.addresses.isEmpty) {
              return const Center(
                child: Text(
                  "Belum ada alamat tersimpan",
                  style: TextStyle(
                    fontFamily: "Primary",
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: user.addresses.length,
              itemBuilder: (context, index) {
                final alamat = user.addresses[index];
                print(
                  "Alamat ke-$index: ${alamat.addressLine1}, Kota: ${alamat.city}, Kecamatan: ${alamat.districtId}, Kode Pos: ${alamat.postalCode}",
                );

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Material(
                    elevation: 1,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Nama + label Utama
                          Row(
                            children: [
                              Text(
                                alamat.shippingName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  fontFamily: "Primary",
                                ),
                              ),
                              const SizedBox(width: 6),
                              if (alamat.isDefault)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    "Utama",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 6),

                          // Alamat + tombol aksi
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${alamat.addressLine1}, ${alamat.city ?? ''}, ${alamat.cityId ?? ''}, ${alamat.postalCode ?? ''}",
                                      style: const TextStyle(
                                        fontSize: 11.5,
                                        fontFamily: "Primary",
                                      ),
                                    ),
                                    if (alamat.addressLine2?.isNotEmpty ??
                                        false)
                                      Text(
                                        alamat.addressLine2!,
                                        style: const TextStyle(fontSize: 11.5),
                                      ),
                                    const SizedBox(height: 2),
                                    Text(
                                      user.phone,
                                      style: const TextStyle(
                                        fontSize: 11.5,
                                        fontFamily: "Primary",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // Tampilkan dialog konfirmasi
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
                                            "Apakah Anda yakin ingin menghapus alamat ini?",
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
                                              onPressed: () async {
                                                Get.back(); // Tutup dialog
                                                await userController
                                                    .deleteAddress(
                                                      userId: user.id,
                                                      addressId: alamat.id,
                                                    );
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
                                    borderRadius: BorderRadius.circular(6),
                                    child: const Padding(
                                      padding: EdgeInsets.all(2),
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  InkWell(
                                    onTap: () {
                                      Get.to(
                                        () => Tambahalamat(
                                          address: {
                                            'id': alamat.id,
                                            'shipping_name':
                                                alamat.shippingName,
                                            'address_line1':
                                                alamat.addressLine1,
                                            'address_line2':
                                                alamat.addressLine2,
                                            'district_id': alamat.districtId
                                                ?.toString(),
                                            'city_id': alamat.cityId
                                                ?.toString(),
                                            'postal_code': alamat.postalCode,
                                            'phone': user.phone,
                                            'is_default': alamat.isDefault,
                                          },
                                        ),
                                        arguments: {'userId': user.id},
                                      )?.then((_) {
                                        // Refresh data setelah edit
                                        userController.getUserDetail(user.id);
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(6),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2),
                                      child: SvgPicture.asset(
                                        "assets/icons/edit.svg",
                                        width: 18,
                                        height: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}

// ============ TAB PESANAN ============
class _PesananTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    final orderController = Get.put(OrderController());
    final userId = userController.userDetail.value?.id;

    // Load orders jika belum ada
    if (orderController.orders.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        orderController.refreshOrders();
      });
    }

    return Obx(() {
      // Loading state
      if (orderController.isLoading.value && orderController.orders.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xffF26D2B)),
        );
      }

      // Filter orders berdasarkan userId
      final userOrders = orderController.orders
          .where((order) => order.userId == userId)
          .toList();

      // Empty state
      if (userOrders.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                "Belum ada pesanan",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontFamily: "Primary",
                ),
              ),
            ],
          ),
        );
      }

      // List pesanan
      return RefreshIndicator(
        onRefresh: () async {
          await orderController.refreshOrders();
        },
        child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 16),
          itemCount: userOrders.length,
          itemBuilder: (context, index) {
            final order = userOrders[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 10, right: 8, left: 8),
              child: InkWell(
                onTap: () {
                  // Navigate ke detail pesanan
                  Get.to(() => Detailpesanan(order: order));
                },
                borderRadius: BorderRadius.circular(10),
                child: Material(
                  elevation: 3,
                  shadowColor: Colors.black26,
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header: Order number & Status
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                order.orderNumber,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  fontFamily: "Primary",
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(
                                  order.activeHistory?.statusName,
                                ).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                order.activeHistory?.statusName ??
                                    'Tidak Diketahui',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color: _getStatusColor(
                                    order.activeHistory?.statusName,
                                  ),
                                  fontFamily: "Primary",
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Tanggal
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 11,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              formatTanggal(DateTime.tryParse(order.orderDate)),
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                                fontFamily: "Primary",
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // Kurir
                        Row(
                          children: [
                            Icon(
                              Icons.local_shipping_outlined,
                              size: 11,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                order.courier?.name ?? '-',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                  fontFamily: "Primary",
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Total Harga
                        Text(
                          formatRupiah(order.totalAmount),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xffF26D2B),
                            fontFamily: "Primary",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  // Helper untuk warna status
  Color _getStatusColor(String? status) {
    if (status == null) return Colors.grey;

    final statusLower = status.toLowerCase();

    if (statusLower.contains('selesai') ||
        statusLower.contains('completed') ||
        statusLower.contains('delivered') ||
        statusLower.contains('diterima')) {
      return Colors.green;
    } else if (statusLower.contains('pending') ||
        statusLower.contains('menunggu') ||
        statusLower.contains('diproses')) {
      return Colors.orange;
    } else if (statusLower.contains('batal') ||
        statusLower.contains('cancel') ||
        statusLower.contains('ditolak')) {
      return Colors.red;
    } else if (statusLower.contains('proses') ||
        statusLower.contains('processing') ||
        statusLower.contains('shipping') ||
        statusLower.contains('kirim') ||
        statusLower.contains('dikirim')) {
      return const Color(0xffF26D2B);
    }

    return Colors.grey;
  }
}
