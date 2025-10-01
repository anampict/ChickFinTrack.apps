import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

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
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.mail, color: Colors.white),
            style: IconButton.styleFrom(
              backgroundColor: Color(0xffF26D2B), // warna background
              shape: CircleBorder(), // biar bulat
            ),
          ),
        ],
      ),

      // 🔹 Body pakai CustomScrollView
      body: CustomScrollView(
        slivers: [
          // Header total transaksi
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
                        width: 120, // atur sesuai kebutuhan
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
                            mainAxisAlignment: MainAxisAlignment
                                .center, // biar icon + teks di tengah
                            children: [
                              // Icon dari assets
                              SvgPicture.asset(
                                "assets/icons/detail.svg", // ganti dengan ikonmu
                                width: 10,
                                height: 10,
                                color: Colors.white, // biar serasi
                              ),
                              const SizedBox(
                                width: 8,
                              ), // jarak antara icon dan teks
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
                    "Jumlah pesanan hari ini: 120",
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: "Primary",
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          // Tab alokasi
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              padding: const EdgeInsets.all(12),
              width: 338,
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
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  VerticalDivider(color: Colors.white, thickness: 2),
                  Text(
                    "Belum Teralokasikan",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),

          // Grid Menu
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildMenu(Icons.category, "Kategori"),
                  _buildMenu(Icons.shopping_basket, "Produk"),
                  _buildMenu(Icons.receipt_long, "Pesanan"),
                  _buildMenu(Icons.list_alt, "Transaksi"),
                  _buildMenu(Icons.print, "Cetak Faktur"),
                  _buildMenu(Icons.account_balance_wallet, "Piutang"),
                ],
              ),
            ),
          ),

          // Judul Transaksi Baru
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Transaksi Baru",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),

          // List Transaksi
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text("ID RPA00127$index"),
                  subtitle: const Text(
                    "Ayam Pejantan 0,5 dll\nSelasa 06-Mei-2025",
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "Menunggu",
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ),
              );
            }, childCount: 10),
          ),
        ],
      ),

      //  Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.orange,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  // Widget menu kecil
  Widget _buildMenu(IconData icon, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Colors.orange.shade100,
          radius: 24,
          child: Icon(icon, color: Colors.orange, size: 28),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
