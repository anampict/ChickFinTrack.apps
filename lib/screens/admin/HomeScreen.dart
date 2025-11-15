import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:my_app/controller/dashboard_controller.dart';
import 'package:my_app/controller/order_controller.dart';
import 'package:my_app/controller/product_controller.dart';
import 'package:my_app/controller/users_controller.dart';
import 'package:my_app/data/repositories/product_repository.dart';
import 'package:my_app/routes/app_routes.dart';
import 'package:my_app/screens/admin/buatpesanan/DaftarPesanan.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final orderController = Get.put(OrderController());
  final productController = Get.put(
    ProductController(repository: ProductRepository()),
  );
  final userController = Get.put(UserController());
  final dashboardController = Get.put(DashboardController());

  // List banner images
  final List<String> banners = [
    'assets/images/banner1.png',
    'assets/images/banner2.png',
    'assets/images/banner3.png',
  ];

  @override
  void initState() {
    super.initState();
    orderController.fetchOrders(page: 11);

    // Auto scroll banner setiap 3 detik
    Future.delayed(const Duration(seconds: 2), () {
      _autoScrollBanner();
    });
  }

  void _autoScrollBanner() {
    if (!mounted) return;

    Future.delayed(const Duration(seconds: 3), () {
      if (_pageController.hasClients && mounted) {
        int nextPage = _currentPage + 1;
        if (nextPage >= banners.length) {
          nextPage = 0;
        }
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
        _autoScrollBanner();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String formatTanggal(String? tgl) {
    if (tgl == null || tgl.isEmpty) return "-";

    try {
      // replace space → T supaya ISO valid
      final normalized = tgl.replaceFirst(' ', 'T');

      final dateTime = DateTime.parse(normalized);
      final dd = dateTime.day.toString().padLeft(2, '0');
      final mm = dateTime.month.toString().padLeft(2, '0');
      final yyyy = dateTime.year.toString();
      return "$dd-$mm-$yyyy";
    } catch (e) {
      return "-";
    }
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
      body: CustomScrollView(
        slivers: [
          // HEADER
          SliverToBoxAdapter(
            child: Obx(() {
              final isLoading = dashboardController.isLoading.value;
              final dashboard = dashboardController.dashboard.value;

              return Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Total transaksi bulan ini",
                      style: TextStyle(
                        fontSize: 11,
                        fontFamily: "Primary",
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Tampilkan data dari API atau loading
                        Text(
                          isLoading
                              ? "Loading..."
                              : (dashboard?.formattedRevenue ?? "Rp. 0"),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                            fontFamily: "Primary",
                          ),
                        ),
                        SizedBox(
                          width: 120,
                          height: 30,
                          child: ElevatedButton(
                            onPressed: () {
                              // Action untuk lihat detail
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/detail.svg",
                                  width: 10,
                                  height: 10,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  "Lihat Detail",
                                  style: TextStyle(
                                    fontFamily: "Primary",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 8,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Jumlah pesanan hari ini",
                      style: TextStyle(
                        fontSize: 11,
                        fontFamily: "Primary",
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      isLoading ? "..." : "${dashboard?.totalOrders ?? 0}",
                      style: const TextStyle(
                        fontSize: 11,
                        fontFamily: "Primary",
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),

          // BANNER CAROUSEL
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              height: 160,
              child: Column(
                children: [
                  // Banner PageView
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemCount: banners.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              banners[index],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.image_not_supported,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Indicator dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      banners.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Colors.orange
                              : Colors.grey[400],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // PAGEVIEW
          SliverToBoxAdapter(
            child: SizedBox(
              height: 300,
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 31,
                      vertical: 23,
                    ),
                    child: GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 28,
                      children: [
                        _buildMenu(
                          "assets/icons/kategoriproduk.svg",
                          "Kategori Produk",
                          onTap: () {
                            Get.toNamed(AppRoutes.KategoriProduk);
                          },
                        ),
                        _buildMenu(
                          "assets/icons/dataproduk.svg",
                          "Data Produk",
                          onTap: () {
                            Get.toNamed(AppRoutes.DataProduk);
                          },
                        ),
                        _buildMenu(
                          "assets/icons/pesanan.svg",
                          "Pesanan",
                          onTap: () {
                            Get.toNamed(AppRoutes.DaftarPesanan);
                          },
                        ),
                        _buildMenu(
                          "assets/icons/listtransaksi.svg",
                          "List Transaksi",
                          onTap: () {
                            Get.toNamed(AppRoutes.DaftarPesanan);
                          },
                        ),
                        _buildMenu(
                          "assets/icons/user.svg",
                          "Manajemen Pengguna",
                          onTap: () => Get.toNamed(AppRoutes.DaftarPengguna),
                        ),
                      ],
                    ),
                  ),
                  _buildMenu2(),
                ],
              ),
            ),
          ),

          // PAGE INDICATOR
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              child: Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: 2,
                  effect: const ExpandingDotsEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: Colors.orange,
                    dotColor: Colors.grey,
                    expansionFactor: 3,
                  ),
                ),
              ),
            ),
          ),

          // TITLE
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Transaksi Baru",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  fontFamily: "Primary",
                ),
              ),
            ),
          ),

          // LIST TRANSAKSI
          Obx(() {
            if (orderController.isLoading.value &&
                orderController.orders.isEmpty) {
              return const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }

            return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final order = orderController.orders[index];
                print("Order date: ${order.orderDate}");

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    child: ListTile(
                      onTap: () => Get.toNamed(
                        AppRoutes.DetailPesanan,
                        arguments: order,
                      ),
                      contentPadding: const EdgeInsets.all(11),

                      title: Text(
                        order.orderNumber,
                        style: const TextStyle(
                          fontFamily: "Second",
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      subtitle: Text(
                        "${order.orderItems?.map((e) => e.product?.name).join(', ') ?? ''}\n"
                        "${formatTanggal(order.orderDate)}",
                      ),

                      trailing: OrderStatusBadge(
                        statusCode: order.activeHistory?.statusCode,
                        statusName: order.activeHistory?.statusName,
                      ),
                    ),
                  ),
                );
              }, childCount: orderController.orders.length),
            );
          }),
        ],
      ),
    );
  }
}

Widget _buildMenu(String iconPath, String label, {VoidCallback? onTap}) {
  return Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    elevation: 2,
    child: InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Expanded(
                child: Center(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Primary",
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
          Positioned(
            top: -20,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFA726),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(iconPath, width: 36, height: 36),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildMenu2() {
  final productController = Get.find<ProductController>();
  final userController = Get.find<UserController>();
  final dashboardController = Get.find<DashboardController>();

  return Obx(() {
    final produkCount = productController.products.length;
    final pelangganCount = userController.users.length;

    // Data dari Dashboard API
    final dashboard = dashboardController.dashboard.value;
    final pesananCount = dashboard?.totalOrders ?? 0;
    final revenue = dashboard?.totalRevenue ?? 0.0;

    String formatRupiah(double amount) {
      final f = NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp ',
        decimalDigits: 0,
      );
      return f.format(amount);
    }

    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 1.8,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      padding: const EdgeInsets.all(16),
      children: [
        _buildCard(
          title: "Produk",
          value: "$produkCount",
          subtitle: "Tersedia",
          subtitleColor: Colors.orange,
          icon: "assets/icons/produk.svg",
          color: Colors.orange,
        ),
        _buildCard(
          title: "Pelanggan",
          value: "$pelangganCount",
          subtitle: "Terdaftar",
          subtitleColor: Colors.green,
          icon: "assets/icons/pelanggan.svg",
          color: Colors.green,
        ),
        _buildCard(
          title: "Pesanan",
          value: "$pesananCount",
          subtitle: "+0.0%",
          subtitleColor: Colors.green,
          icon: "assets/icons/kurvapesanan.svg",
          color: Colors.green,
        ),
        _buildCard(
          title: "Revenue",
          value: formatRupiah(revenue),
          subtitle: "+0.0%",
          subtitleColor: Colors.green,
          icon: "assets/icons/kurvapesanan.svg",
          color: Colors.green,
        ),
      ],
    );
  });
}

Widget _buildCard({
  required String title,
  required String value,
  required String subtitle,
  required Color subtitleColor,
  required String icon,
  required Color color,
}) {
  return Material(
    elevation: 2,
    borderRadius: BorderRadius.circular(12),
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: subtitleColor,
                ),
              ),
              SvgPicture.asset(icon, width: 18, height: 18, color: color),
            ],
          ),
        ],
      ),
    ),
  );
}
