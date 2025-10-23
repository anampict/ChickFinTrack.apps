import 'package:flutter/material.dart';

class Daftarpesanan extends StatelessWidget {
  const Daftarpesanan({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> orders = [
      {
        "nama": "Limin",
        "kode": "AB/28092025/0051",
        "kurir": "Syaroni",
        "harga": "Rp.360.000",
        "status": "Menunggu",
        "tanggal": "Sep 28, 2025 23:12",
        "gambar": "assets/images/image.png",
      },
      {
        "nama": "IBC Pandaan",
        "kode": "AB/28092025/0051",
        "kurir": "Syaroni",
        "harga": "Rp.360.000",
        "status": "Menunggu",
        "tanggal": "Sep 28, 2025 23:12",
        "gambar": "assets/images/image.png",
      },
      {
        "nama": "Gedung Wolue",
        "kode": "AB/28092025/0051",
        "kurir": "Syaroni",
        "harga": "Rp.360.000",
        "status": "Menunggu",
        "tanggal": "Sep 28, 2025 23:12",
        "gambar": "assets/images/image.png",
      },
      {
        "nama": "Bukit Mas Surabaya",
        "kode": "AB/28092025/0051",
        "kurir": "Syaroni",
        "harga": "Rp.360.000",
        "status": "Menunggu",
        "tanggal": "Sep 28, 2025 23:12",
        "gambar": "assets/images/image.png",
      },
    ];

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
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Material(
                      elevation: 4,
                      shadowColor: Colors.black26,
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // === HEADER BARIS ATAS ===
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage: AssetImage(
                                        order["gambar"],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      order["nama"],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  order["tanggal"],
                                  style: const TextStyle(
                                    fontSize: 9,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // === DETAIL PESANAN ===
                            Text(
                              "Kode Pesanan: ${order["kode"]}",
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              "Kurir: ${order["kurir"]}",
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Total Harga : ${order["harga"]}",
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 6),
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
                                      order["status"],
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
              ),
            ),
          ],
        ),
      ),

      // === FLOATING BUTTON ===
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xffF26D2B),
        onPressed: () {},
        child: const Icon(Icons.add, size: 28, color: Colors.white),
      ),
    );
  }
}
