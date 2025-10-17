import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:my_app/routes/app_routes.dart';
import 'package:my_app/screens/admin/buatpesanan/BuatPesanan.dart';
import 'package:my_app/screens/admin/produk/DataProduk.dart';
import 'package:my_app/screens/admin/produk/DaftarKategoriProduk.dart';
import 'package:my_app/screens/admin/produk/TambahProduk.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:get/get.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
      body: CustomScrollView(
        slivers: [
          // HEADER
          SliverToBoxAdapter(
            child: Container(
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
                      const Text(
                        "Rp. 30.000.000",
                        style: TextStyle(
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
                          onPressed: () {},
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
                  const Text(
                    "120",
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: "Primary",
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          // TAB ALOKASI
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              padding: const EdgeInsets.all(12),
              height: 109,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Text(
                    "Teralokasikan",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontFamily: "Primary",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  VerticalDivider(color: Colors.white, thickness: 2),
                  Text(
                    "Belum Teralokasikan",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontFamily: "Primary",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // PAGEVIEW GRID
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
                            Get.toNamed(AppRoutes.Pesanan);
                          },
                        ),
                        _buildMenu(
                          "assets/icons/listtransaksi.svg",
                          "List Transaksi",
                        ),

                        _buildMenu(
                          "assets/icons/manajemanpengguna.svg",
                          "Manajemen Pengguna",
                        ),
                      ],
                    ),
                  ),
                  _buildMenu2("assets/icons/box.svg", "Produk"),
                ],
              ),
            ),
          ),

          // INDIKATOR
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
          //judul transaksi
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
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
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
                    contentPadding: const EdgeInsets.all(11),
                    title: Text(
                      "ID RPA00127$index",
                      style: const TextStyle(
                        fontFamily: "Second",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: const Text(
                      "Ayam Pejantan 0,5\ndll\nSelasa 06-Mei-2025",
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xff959595),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "Menunggu",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Primary",
                          fontWeight: FontWeight.w500,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }, childCount: 10),
          ),
        ],
      ),
    );
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
}

Widget _buildMenu2(String iconPath, String label) {
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
        value: "10",
        subtitle: "Tersedia",
        subtitleColor: Colors.orange,
        icon: "assets/icons/produk.svg",
        color: Colors.orange,
      ),
      _buildCard(
        title: "Pelanggan",
        value: "26",
        subtitle: "Terdaftar",
        subtitleColor: Colors.green,
        icon: "assets/icons/pelanggan.svg",
        color: Colors.green,
      ),
      _buildCard(
        title: "Pesanan",
        value: "37",
        subtitle: "+0.0%",
        subtitleColor: Colors.green,
        icon: "assets/icons/kurvapesanan.svg",
        color: Colors.green,
      ),
      _buildCard(
        title: "Revenue",
        value: "Rp. 82,8 Jt",
        subtitle: "+0.0%",
        subtitleColor: Colors.green,
        icon: "assets/icons/kurvapesanan.svg",
        color: Colors.green,
      ),
    ],
  );
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
