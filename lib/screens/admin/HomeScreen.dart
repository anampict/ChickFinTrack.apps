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

      // Body pakai CustomScrollView
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

          // Grid Menu
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 23,
                left: 31,
                right: 31,
                bottom: 26,
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
                  ),
                  _buildMenu("assets/icons/dataproduk.svg", "Data Produk"),
                  _buildMenu("assets/icons/pesanan.svg", "Pesanan"),
                  _buildMenu(
                    "assets/icons/listtransaksi.svg",
                    "List Transaksi",
                  ),
                  _buildMenu("assets/icons/cetakfaktur.svg", "Cetak Faktur"),
                  _buildMenu(
                    "assets/icons/manajemanpengguna.svg",
                    "Manajemen Pengguna",
                  ),
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
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  fontFamily: "Primary",
                ),
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ), // jarak antar Material
                child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  child: Container(
                    height: 120, // atur tinggi material (bisa disesuaikan)
                    width: double.infinity, // biar full lebar
                    padding: const EdgeInsets.all(11), // isi dalam card
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        "ID RPA00127$index",
                        style: TextStyle(
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
                          color: Color(0xff959595),
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

  Widget _buildMenu(String iconPath, String label) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // TODO: Navigasi
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // isi card
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 40), // ruang untuk icon yang nongol
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
                const SizedBox(height: 12), // padding bawah biar lega
              ],
            ),

            // icon lingkaran nongol di atas
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

  //widget menu 2
 
}
