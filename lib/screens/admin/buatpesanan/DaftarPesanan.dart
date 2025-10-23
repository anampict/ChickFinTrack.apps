import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/controller/order_controller.dart';
import 'package:my_app/data/models/order_model.dart';
import 'package:my_app/helper/utils.dart';

class Daftarpesanan extends StatelessWidget {
  const Daftarpesanan({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderController orderController = Get.put(OrderController());

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

      // === BODY ===
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Daftar Pesanan",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                fontFamily: "Primary",
              ),
            ),
            const SizedBox(height: 10),

            // Gunakan Obx agar UI reactive
            Expanded(
              child: Obx(() {
                if (orderController.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xffF26D2B)),
                  );
                }

                if (orderController.orders.isEmpty) {
                  return const Center(
                    child: Text(
                      "Belum ada pesanan.",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontFamily: "Primary",
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: orderController.orders.length,
                  itemBuilder: (context, index) {
                    final OrderModel order = orderController.orders[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Material(
                        elevation: 4,
                        shadowColor: Colors.black26,
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // === HEADER ATAS ===
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const CircleAvatar(
                                        radius: 20,
                                        backgroundImage: AssetImage(
                                          "assets/images/image.png",
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        order.user?.name ?? 'Tanpa Nama',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    order.orderDate,
                                    style: const TextStyle(
                                      fontSize: 9,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 50,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // === DETAIL ===
                                    Text(
                                      "Kode Pesanan: ${order.orderNumber}",
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      "Kurir: ${order.courier?.name ?? '-'}",
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "Total Harga : ${formatRupiah(order.totalAmount)}",
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                  ],
                                ),
                              ),

                              // === STATUS ===
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Material(
                                    color: const Color(
                                      0xffA42727,
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      child: Text(
                                        order.activeHistory?.statusName ??
                                            'Tidak Diketahui',
                                        style: const TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xffF26D2B),
                                        ),
                                      ),
                                    ),
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
        ),
      ),

      // === FLOATING BUTTON ===
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xffF26D2B),
        onPressed: () {
          // contoh: Get.to(() => TambahPesananPage());
        },
        child: const Icon(Icons.add, size: 28, color: Colors.white),
      ),
    );
  }
}
