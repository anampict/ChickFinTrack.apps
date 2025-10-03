import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Dataproduk extends StatelessWidget {
  const Dataproduk({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 31, left: 28),
              child: Row(
                children: [
                  Text(
                    "Data Produk",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Primary",
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 4, left: 9, right: 9),
              child: CardProduk(
                namaProduk: "Test Ayam",
                kategori: "Ayam Pejantan",
                stok: 30,
                harga: "30.000",
                imagePath:
                    "assets/images/fotoproduk.png", // ganti path sesuai export figma
                onEdit: () {
                  print("Edit ditekan");
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 4, left: 9, right: 9),
              child: CardProduk(
                namaProduk: "Test Ayam",
                kategori: "Ayam Pejantan",
                stok: 30,
                harga: "30.000",
                imagePath:
                    "assets/images/fotoproduk.png", // ganti path sesuai export figma
                onEdit: () {
                  print("Edit ditekan");
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 4, left: 9, right: 9),
              child: CardProduk(
                namaProduk: "Test Ayam",
                kategori: "Ayam Pejantan",
                stok: 30,
                harga: "30.000",
                imagePath:
                    "assets/images/fotoproduk.png", // ganti path sesuai export figma
                onEdit: () {
                  print("Edit ditekan");
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 4, left: 9, right: 9),
              child: CardProduk(
                namaProduk: "Test Ayam",
                kategori: "Ayam Pejantan",
                stok: 30,
                harga: "30.000",
                imagePath:
                    "assets/images/fotoproduk.png", // ganti path sesuai export figma
                onEdit: () {
                  print("Edit ditekan");
                },
              ),
            ),
          ],
        ),
      ),
      // Tambahkan FAB di bawah kanan
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          print("Tambah produk diklik!");
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

//card component
class CardProduk extends StatelessWidget {
  final String namaProduk;
  final String kategori;
  final int stok;
  final String harga;
  final String imagePath;
  final VoidCallback? onEdit;

  const CardProduk({
    super.key,
    required this.namaProduk,
    required this.kategori,
    required this.stok,
    required this.harga,
    required this.imagePath,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar produk
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imagePath, // ganti dengan Image.network kalau dari URL
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),

            // Detail produk
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama + Tombol edit
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          namaProduk,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Primary",
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      InkWell(
                        onTap: onEdit,
                        child: SvgPicture.asset("assets/icons/edit.svg"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Stok & kategori
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xffEE6C22),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "Stok: $stok",
                          style: const TextStyle(
                            fontSize: 9,
                            fontFamily: "Primary",
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xffEE9400),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "Kategori: $kategori",
                          style: const TextStyle(
                            fontSize: 9,
                            fontFamily: "Primary",
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Harga & Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Rp. ${harga.toString()}",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Row(
                        children: const [
                          Text("Status: ", style: TextStyle(fontSize: 12)),
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 18,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
