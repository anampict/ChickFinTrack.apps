import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/controller/order_controller.dart';
import 'package:my_app/data/models/order_model.dart';
import 'package:my_app/helper/utils.dart';
import 'package:my_app/routes/app_routes.dart';
import 'package:my_app/screens/admin/buatpesanan/BuatPesanan.dart';

class Daftarpesanan extends StatelessWidget {
  const Daftarpesanan({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderController orderController = Get.put(
      OrderController(),
      permanent: false,
    );

    final ScrollController scrollController = ScrollController();

    // listener scroll untuk load more
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 100 &&
          !orderController.isLoadingMore.value &&
          (orderController.pagination.value?['current_page'] ?? 1) <
              (orderController.pagination.value?['last_page'] ?? 1)) {
        orderController.loadMoreOrders();
      }
    });

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
        if (orderController.isLoading.value && orderController.orders.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (orderController.orders.isEmpty) {
          return RefreshIndicator(
            onRefresh: orderController.fetchOrders, // bisa refresh walau kosong
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 200),
                Center(
                  child: Text(
                    "Belum ada pesanan.",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontFamily: "Primary",
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: orderController.fetchOrders,
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent &&
                  !orderController.isLoadingMore.value &&
                  (orderController.pagination.value?['current_page'] ?? 1) <
                      (orderController.pagination.value?['last_page'] ?? 1)) {
                orderController.loadMoreOrders();
              }
              return false;
            },
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.only(bottom: 80),
              itemCount:
                  orderController.orders.length +
                  (orderController.isLoadingMore.value ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == orderController.orders.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final OrderModel order = orderController.orders[index];

                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10,
                    right: 15,
                    left: 15,
                    top: 10,
                  ),
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(AppRoutes.DetailPesanan, arguments: order);
                    },
                    borderRadius: BorderRadius.circular(10),
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
                            // === HEADER ===
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.grey,
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      order.user?.name ?? 'Tanpa Nama',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        fontFamily: "Primary",
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  formatTanggal(
                                    DateTime.tryParse(order.orderDate),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 9,
                                    color: Colors.black87,
                                    fontFamily: "Primary",
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
                                  Text(
                                    "Kode Pesanan: ${order.orderNumber}",
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.black87,
                                      fontFamily: "Primary",
                                    ),
                                  ),
                                  Text(
                                    "Kurir: ${order.courier?.name ?? '-'}",
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.black87,
                                      fontFamily: "Primary",
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Total Harga : ${formatRupiah(order.totalAmount)}",
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontFamily: "Primary",
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
                  ),
                );
              },
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xffF26D2B),
        onPressed: () {
          Get.to(() => Buatpesanan());
        },
        child: const Icon(Icons.add, size: 28, color: Colors.white),
      ),
    );
  }
}
